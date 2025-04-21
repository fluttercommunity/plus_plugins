#include "share_plus_windows_plugin.h"

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <flutter/standard_method_codec.h>

#include "vector.h"

namespace share_plus_windows {

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
  if (data_transfer_manager_ != nullptr) {
    data_transfer_manager_->remove_DataRequested(data_transfer_manager_token_);
    data_transfer_manager_.Reset();
  }
  if (data_transfer_manager_interop_ != nullptr) {
    data_transfer_manager_interop_.Reset();
  }
}

HWND SharePlusWindowsPlugin::GetWindow() {
  return ::GetAncestor(registrar_->GetView()->GetNativeWindow(), GA_ROOT);
}

WRL::ComPtr<DataTransfer::IDataTransferManager>
SharePlusWindowsPlugin::GetDataTransferManager() {
  using Microsoft::WRL::Wrappers::HStringReference;
  ::RoGetActivationFactory(
      HStringReference(
          RuntimeClass_Windows_ApplicationModel_DataTransfer_DataTransferManager)
          .Get(),
      IID_PPV_ARGS(&data_transfer_manager_interop_));
  data_transfer_manager_interop_->GetForWindow(
      GetWindow(), IID_PPV_ARGS(&data_transfer_manager_));
  return data_transfer_manager_;
}

HRESULT SharePlusWindowsPlugin::GetStorageFileFromPath(
    wchar_t *path, WindowsStorage::IStorageFile **file) {
  using Microsoft::WRL::Wrappers::HStringReference;
  WRL::ComPtr<WindowsStorage::IStorageFileStatics> factory = nullptr;
  HRESULT hr = S_OK;
  *file = nullptr;
  if (!factory) {
    hr = WindowsFoundation::GetActivationFactory(
        HStringReference(RuntimeClass_Windows_Storage_StorageFile).Get(),
        &factory);
  }
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
          async_operation->GetResults(file);
        }
      }
    }
  }
  return hr;
}

void SharePlusWindowsPlugin::HandleMethodCall(
    const flutter::MethodCall<flutter::EncodableValue> &method_call,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  // Handle the share method.
  if (method_call.method_name().compare(kShare) == 0) {
    auto data_transfer_manager = GetDataTransferManager();
    auto args = std::get<flutter::EncodableMap>(*method_call.arguments());

    // Extract the text, subject, uri, title, paths and mimeTypes from the arguments
    if (auto text_value = std::get_if<std::string>(
            &args[flutter::EncodableValue("text")])) {
      share_text_ = *text_value;
    }
    if (auto subject_value = std::get_if<std::string>(
            &args[flutter::EncodableValue("subject")])) {
      share_subject_ = *subject_value;
    }
    if (auto uri_value = std::get_if<std::string>(
      &args[flutter::EncodableValue("uri")])) {
      share_uri_ = *uri_value;
    }
    if (auto title_value = std::get_if<std::string>(
      &args[flutter::EncodableValue("title")])) {
      share_title_ = *title_value;
    }
    if (auto paths = std::get_if<flutter::EncodableList>(
      &args[flutter::EncodableValue("paths")])) {
      paths_.clear();
      for (auto& path : *paths) {
        paths_.emplace_back(std::get<std::string>(path));
      }
    }
    if (auto mime_types = std::get_if<flutter::EncodableList>(
      &args[flutter::EncodableValue("mimeTypes")])) {
      mime_types_.clear();
      for (auto& mime_type : *mime_types) {
        mime_types_.emplace_back(std::get<std::string>(mime_type));
      }
    }

    // Create the share callback
    auto callback = WRL::Callback<WindowsFoundation::ITypedEventHandler<
        DataTransfer::DataTransferManager *,
        DataTransfer::DataRequestedEventArgs *>>(
        [&](auto &&, DataTransfer::IDataRequestedEventArgs *e) {
          using Microsoft::WRL::Wrappers::HStringReference;
          WRL::ComPtr<DataTransfer::IDataRequest> request;
          e->get_Request(&request);
          WRL::ComPtr<DataTransfer::IDataPackage> data;
          request->get_Data(&data);
          WRL::ComPtr<DataTransfer::IDataPackagePropertySet> properties;
          data->get_Properties(&properties);

          // Set the title of the share dialog
          // Prefer the title, then the subject, then the text
          // Setting a title is mandatory for Windows
          if (share_title_ && !share_title_.value_or("").empty()) {
            auto title = Utf16FromUtf8(share_title_.value_or(""));
            properties->put_Title(HStringReference(title.c_str()).Get());
          }
          else if (share_subject_ && !share_subject_.value_or("").empty()) {
            auto title = Utf16FromUtf8(share_subject_.value_or(""));
            properties->put_Title(HStringReference(title.c_str()).Get());
          }
          else {
            auto title = Utf16FromUtf8(share_text_.value_or(""));
            properties->put_Title(HStringReference(title.c_str()).Get());
          }

          // Set the text of the share dialog
          if (share_text_ && !share_text_.value_or("").empty()) {
            auto text = Utf16FromUtf8(share_text_.value_or(""));
            properties->put_Description(
                HStringReference(text.c_str()).Get());
            data->SetText(HStringReference(text.c_str()).Get());
          }

          // If URI provided, set the URI to share
          if (share_uri_ && !share_uri_.value_or("").empty()) {
            auto uri = Utf16FromUtf8(share_uri_.value_or(""));
            properties->put_Description(
              HStringReference(uri.c_str()).Get());
            data->SetText(HStringReference(uri.c_str()).Get());
          }

          // Add files to the data.
          Vector<WindowsStorage::IStorageItem*> storage_items;
          for (const std::string& path : paths_) {
            auto str = Utf16FromUtf8(path);
            wchar_t* ptr = const_cast<wchar_t*>(str.c_str());
            WindowsStorage::IStorageFile* file = nullptr;
            if (SUCCEEDED(GetStorageFileFromPath(ptr, &file)) &&
              file != nullptr) {
              storage_items.Append(
                reinterpret_cast<WindowsStorage::IStorageItem*>(file));
            }
          }
          data->SetStorageItemsReadOnly(&storage_items);

          return S_OK;
        });

    // Add the callback to the data transfer manager
    data_transfer_manager->add_DataRequested(callback.Get(),
                                             &data_transfer_manager_token_);
    if (data_transfer_manager_interop_ != nullptr) {
      data_transfer_manager_interop_->ShowShareUIForWindow(GetWindow());
    }
    result->Success(flutter::EncodableValue(kShareResultUnavailable));
  } else {
    result->NotImplemented();
  }
}

// Converts string encoded in UTF-8 to wstring.
// Returns an empty |std::wstring| on failure.
// Present as static helper method.
std::wstring SharePlusWindowsPlugin::Utf16FromUtf8(std::string string) {
  int size_needed =
      MultiByteToWideChar(CP_UTF8, 0, string.c_str(), -1, NULL, 0);
  if (size_needed == 0) {
    return std::wstring();
  }
  std::wstring result(size_needed, 0);
  int converted_length = MultiByteToWideChar(CP_UTF8, 0, string.c_str(), -1,
                                             &result[0], size_needed);
  if (converted_length == 0) {
    return std::wstring();
  }
  return result;
}

} // namespace share_plus_windows
