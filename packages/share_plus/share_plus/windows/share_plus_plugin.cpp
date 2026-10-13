#include "share_plus_windows_plugin.h"

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <flutter/standard_method_codec.h>

#include "vector.h"

namespace share_plus_windows {

namespace {

// Looks up |key| in |map| without inserting a null value for missing keys,
// which |std::map::operator[]| would do.
const flutter::EncodableValue *ValueOrNull(const flutter::EncodableMap &map,
                                           const char *key) {
  auto it = map.find(flutter::EncodableValue(key));
  if (it == map.end()) {
    return nullptr;
  }
  return &it->second;
}

std::optional<std::string> StringOrNull(const flutter::EncodableMap &map,
                                        const char *key) {
  const auto *value = ValueOrNull(map, key);
  if (value == nullptr) {
    return std::nullopt;
  }
  if (const auto *string_value = std::get_if<std::string>(value)) {
    return *string_value;
  }
  return std::nullopt;
}

std::vector<std::string> StringListOrEmpty(const flutter::EncodableMap &map,
                                           const char *key) {
  std::vector<std::string> result;
  const auto *value = ValueOrNull(map, key);
  if (value == nullptr) {
    return result;
  }
  if (const auto *list = std::get_if<flutter::EncodableList>(value)) {
    for (const auto &entry : *list) {
      if (const auto *string_value = std::get_if<std::string>(&entry)) {
        result.emplace_back(*string_value);
      }
    }
  }
  return result;
}

bool HasValue(const std::optional<std::string> &value) {
  return value.has_value() && !value->empty();
}

} // namespace

void SharePlusWindowsPlugin::RegisterWithRegistrar(
    flutter::PluginRegistrarWindows *registrar) {
  auto channel =
      std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
          registrar->messenger(), kSharePlusChannelName,
          &flutter::StandardMethodCodec::GetInstance());
  auto plugin = std::make_unique<SharePlusWindowsPlugin>(registrar);
  channel->SetMethodCallHandler(
      [plugin_pointer = plugin.get()](const auto &call, auto result) {
        plugin_pointer->HandleMethodCall(call, std::move(result));
      });

  registrar->AddPlugin(std::move(plugin));
}

SharePlusWindowsPlugin::SharePlusWindowsPlugin(
    flutter::PluginRegistrarWindows *registrar)
    : registrar_(registrar) {}

SharePlusWindowsPlugin::~SharePlusWindowsPlugin() {
  RemoveDataRequestedHandler();
  data_transfer_manager_.Reset();
  data_transfer_manager_interop_.Reset();
  storage_items_.Reset();
}

HWND SharePlusWindowsPlugin::GetWindow() {
  return ::GetAncestor(registrar_->GetView()->GetNativeWindow(), GA_ROOT);
}

void SharePlusWindowsPlugin::RemoveDataRequestedHandler() {
  if (has_data_transfer_manager_token_ && data_transfer_manager_ != nullptr) {
    data_transfer_manager_->remove_DataRequested(data_transfer_manager_token_);
  }
  has_data_transfer_manager_token_ = false;
  data_transfer_manager_token_ = {};
}

WRL::ComPtr<DataTransfer::IDataTransferManager>
SharePlusWindowsPlugin::GetDataTransferManager() {
  using Microsoft::WRL::Wrappers::HStringReference;
  // Drop the handler registered for the previous share request before the
  // manager is replaced, otherwise it stays registered forever and every
  // following request is served by several handlers at once.
  RemoveDataRequestedHandler();
  data_transfer_manager_.Reset();
  data_transfer_manager_interop_.Reset();

  HRESULT hr = ::RoGetActivationFactory(
      HStringReference(
          RuntimeClass_Windows_ApplicationModel_DataTransfer_DataTransferManager)
          .Get(),
      IID_PPV_ARGS(&data_transfer_manager_interop_));
  if (FAILED(hr)) {
    return nullptr;
  }
  hr = data_transfer_manager_interop_->GetForWindow(
      GetWindow(), IID_PPV_ARGS(&data_transfer_manager_));
  if (FAILED(hr)) {
    data_transfer_manager_.Reset();
  }
  return data_transfer_manager_;
}

HRESULT SharePlusWindowsPlugin::GetStorageFileFromPath(
    const wchar_t *path, WindowsStorage::IStorageFile **file) {
  using Microsoft::WRL::Wrappers::HStringReference;
  WRL::ComPtr<WindowsStorage::IStorageFileStatics> factory = nullptr;
  HRESULT hr = S_OK;
  *file = nullptr;
  hr = WindowsFoundation::GetActivationFactory(
      HStringReference(RuntimeClass_Windows_Storage_StorageFile).Get(),
      &factory);
  if (SUCCEEDED(hr)) {
    WRL::ComPtr<
        WindowsFoundation::IAsyncOperation<WindowsStorage::StorageFile *>>
        async_operation;
    hr = factory->GetFileFromPathAsync(HStringReference(path).Get(),
                                       &async_operation);
    if (SUCCEEDED(hr)) {
      WRL::ComPtr<IAsyncInfo> info;
      hr = async_operation.As(&info);
      if (SUCCEEDED(hr)) {
        AsyncStatus status;
        while (SUCCEEDED(hr = info->get_Status(&status)) &&
               status == AsyncStatus::Started)
          SleepEx(0, TRUE);
        if (FAILED(hr) || status != AsyncStatus::Completed) {
          info->get_ErrorCode(&hr);
        } else {
          hr = async_operation->GetResults(file);
        }
      }
    }
  }
  return hr;
}

HRESULT SharePlusWindowsPlugin::BuildStorageItems() {
  storage_items_.Reset();
  storage_items_size_ = 0;
  if (paths_.empty()) {
    return S_OK;
  }

  auto items = WRL::Make<Vector<WindowsStorage::IStorageItem *>>();
  if (items == nullptr) {
    return E_OUTOFMEMORY;
  }

  for (const std::string &path : paths_) {
    const auto wide_path = Utf16FromUtf8(path);
    WRL::ComPtr<WindowsStorage::IStorageFile> file;
    HRESULT hr = GetStorageFileFromPath(wide_path.c_str(), &file);
    if (FAILED(hr) || file == nullptr) {
      return FAILED(hr) ? hr : E_FAIL;
    }
    // |IStorageFile| does not derive from |IStorageItem| at the ABI level, so
    // the interface has to be queried instead of cast.
    WRL::ComPtr<WindowsStorage::IStorageItem> item;
    hr = file.As(&item);
    if (FAILED(hr)) {
      return hr;
    }
    hr = items->Append(item.Get());
    if (FAILED(hr)) {
      return hr;
    }
    ++storage_items_size_;
  }

  return items.As(&storage_items_);
}

std::wstring SharePlusWindowsPlugin::ResolveShareTitle() {
  // Windows rejects a |DataPackage| without a title, which surfaces as
  // "We couldn't show you all the ways you could share" in the share sheet.
  if (HasValue(share_title_)) {
    return Utf16FromUtf8(*share_title_);
  }
  if (HasValue(share_subject_)) {
    return Utf16FromUtf8(*share_subject_);
  }
  if (HasValue(share_text_)) {
    return Utf16FromUtf8(*share_text_);
  }
  if (HasValue(share_uri_)) {
    return Utf16FromUtf8(*share_uri_);
  }
  // Sharing files only, with no title provided: fall back to the window title.
  wchar_t window_title[256] = {};
  const int length =
      ::GetWindowTextW(GetWindow(), window_title, ARRAYSIZE(window_title));
  if (length > 0) {
    return std::wstring(window_title, static_cast<size_t>(length));
  }
  return L"Share";
}

HRESULT SharePlusWindowsPlugin::OnDataRequested(
    DataTransfer::IDataRequestedEventArgs *e) {
  using Microsoft::WRL::Wrappers::HStringReference;
  WRL::ComPtr<DataTransfer::IDataRequest> request;
  HRESULT hr = e->get_Request(&request);
  if (FAILED(hr)) {
    return hr;
  }
  WRL::ComPtr<DataTransfer::IDataPackage> data;
  hr = request->get_Data(&data);
  if (FAILED(hr)) {
    return hr;
  }
  WRL::ComPtr<DataTransfer::IDataPackagePropertySet> properties;
  hr = data->get_Properties(&properties);
  if (FAILED(hr)) {
    return hr;
  }

  const auto title = ResolveShareTitle();
  hr = properties->put_Title(HStringReference(title.c_str()).Get());
  if (FAILED(hr)) {
    return hr;
  }

  // Prefer the URI over the text when both are present, matching the other
  // platform implementations.
  std::wstring body;
  if (HasValue(share_uri_)) {
    body = Utf16FromUtf8(*share_uri_);
  } else if (HasValue(share_text_)) {
    body = Utf16FromUtf8(*share_text_);
  }
  if (!body.empty()) {
    properties->put_Description(HStringReference(body.c_str()).Get());
    hr = data->SetText(HStringReference(body.c_str()).Get());
    if (FAILED(hr)) {
      return hr;
    }
  }

  // Only set storage items when there is at least one: an empty collection
  // makes the share sheet fail to enumerate share targets.
  if (storage_items_ != nullptr && storage_items_size_ > 0) {
    WRL::ComPtr<WindowsFoundation::Collections::IIterable<
        WindowsStorage::IStorageItem *>>
        iterable;
    hr = storage_items_.As(&iterable);
    if (FAILED(hr)) {
      return hr;
    }
    hr = data->SetStorageItemsReadOnly(iterable.Get());
    if (FAILED(hr)) {
      return hr;
    }
  }

  return S_OK;
}

void SharePlusWindowsPlugin::HandleMethodCall(
    const flutter::MethodCall<flutter::EncodableValue> &method_call,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  // Handle the share method.
  if (method_call.method_name().compare(kShare) != 0) {
    result->NotImplemented();
    return;
  }

  const auto *args =
      std::get_if<flutter::EncodableMap>(method_call.arguments());
  if (args == nullptr) {
    result->Error("share_plus", "Missing or invalid arguments.");
    return;
  }

  // Reset every field: values missing from this call must not be inherited
  // from the previous one.
  share_text_ = StringOrNull(*args, "text");
  share_subject_ = StringOrNull(*args, "subject");
  share_uri_ = StringOrNull(*args, "uri");
  share_title_ = StringOrNull(*args, "title");
  paths_ = StringListOrEmpty(*args, "paths");
  mime_types_ = StringListOrEmpty(*args, "mimeTypes");

  // Resolve the files before the share UI is shown. The |DataRequested|
  // handler runs on the UI thread with a short deadline, and the synchronous
  // wait performed here would make it time out.
  HRESULT hr = BuildStorageItems();
  if (FAILED(hr)) {
    result->Error("share_plus", "Failed to open the files to share.");
    return;
  }

  auto data_transfer_manager = GetDataTransferManager();
  if (data_transfer_manager == nullptr ||
      data_transfer_manager_interop_ == nullptr) {
    result->Error("share_plus", "DataTransferManager is not available.");
    return;
  }

  auto callback = WRL::Callback<WindowsFoundation::ITypedEventHandler<
      DataTransfer::DataTransferManager *,
      DataTransfer::DataRequestedEventArgs *>>(
      [this](DataTransfer::IDataTransferManager *,
             DataTransfer::IDataRequestedEventArgs *e) -> HRESULT {
        return OnDataRequested(e);
      });

  hr = data_transfer_manager->add_DataRequested(callback.Get(),
                                                &data_transfer_manager_token_);
  if (FAILED(hr)) {
    result->Error("share_plus", "Failed to register the share handler.");
    return;
  }
  has_data_transfer_manager_token_ = true;

  hr = data_transfer_manager_interop_->ShowShareUIForWindow(GetWindow());
  if (FAILED(hr)) {
    RemoveDataRequestedHandler();
    result->Error("share_plus", "Failed to show the share UI.");
    return;
  }

  result->Success(flutter::EncodableValue(kShareResultUnavailable));
}

// Converts string encoded in UTF-8 to wstring.
// Returns an empty |std::wstring| on failure.
// Present as static helper method.
std::wstring SharePlusWindowsPlugin::Utf16FromUtf8(const std::string &string) {
  if (string.empty()) {
    return std::wstring();
  }
  // |string.size()| excludes the terminator on purpose: including it would
  // embed a NUL in the result, which WinRT strings carry along.
  const int size_needed = MultiByteToWideChar(
      CP_UTF8, 0, string.c_str(), static_cast<int>(string.size()), nullptr, 0);
  if (size_needed <= 0) {
    return std::wstring();
  }
  std::wstring result(static_cast<size_t>(size_needed), 0);
  const int converted_length = MultiByteToWideChar(
      CP_UTF8, 0, string.c_str(), static_cast<int>(string.size()), &result[0],
      size_needed);
  if (converted_length == 0) {
    return std::wstring();
  }
  return result;
}

} // namespace share_plus_windows
