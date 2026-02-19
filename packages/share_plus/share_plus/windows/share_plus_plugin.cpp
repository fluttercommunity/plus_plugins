#include "share_plus_windows_plugin.h"

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <flutter/standard_method_codec.h>

#include <algorithm>

#include "vector.h"

namespace share_plus_windows
{

  void SharePlusWindowsPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarWindows *registrar)
  {
    auto channel =
        std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
            registrar->messenger(), kSharePlusChannelName,
            &flutter::StandardMethodCodec::GetInstance());
    auto plugin = std::make_unique<SharePlusWindowsPlugin>(registrar);
    channel->SetMethodCallHandler(
        [plugin_pointer = plugin.get()](const auto &call, auto result)
        {
          plugin_pointer->HandleMethodCall(call, std::move(result));
        });

    registrar->AddPlugin(std::move(plugin));
  }

  SharePlusWindowsPlugin::SharePlusWindowsPlugin(
      flutter::PluginRegistrarWindows *registrar)
      : registrar_(registrar) {}

  SharePlusWindowsPlugin::~SharePlusWindowsPlugin()
  {
    if (data_transfer_manager_ != nullptr)
    {
      data_transfer_manager_->remove_DataRequested(data_transfer_manager_token_);
      data_transfer_manager_.Reset();
    }
    if (data_transfer_manager_interop_ != nullptr)
    {
      data_transfer_manager_interop_.Reset();
    }
  }

  HWND SharePlusWindowsPlugin::GetWindow()
  {
    return ::GetAncestor(registrar_->GetView()->GetNativeWindow(), GA_ROOT);
  }

  WRL::ComPtr<DataTransfer::IDataTransferManager>
  SharePlusWindowsPlugin::GetDataTransferManager()
  {
    using Microsoft::WRL::Wrappers::HStringReference;
    HRESULT hr = ::RoGetActivationFactory(
        HStringReference(
            RuntimeClass_Windows_ApplicationModel_DataTransfer_DataTransferManager)
            .Get(),
        IID_PPV_ARGS(&data_transfer_manager_interop_));

    if (SUCCEEDED(hr) && data_transfer_manager_interop_)
    {
      hr = data_transfer_manager_interop_->GetForWindow(
          GetWindow(), IID_PPV_ARGS(&data_transfer_manager_));
    }

    return data_transfer_manager_;
  }

  bool SharePlusWindowsPlugin::IsApplicationDataPath(const std::wstring &path,
                                                     std::wstring &relative_path,
                                                     int &folder_type)
  {

    std::wstring lower_path = path;
    std::transform(lower_path.begin(), lower_path.end(), lower_path.begin(),
                   ::towlower);

    const std::wstring packages_marker = L"\\appdata\\local\\packages\\";
    const std::wstring local_marker = L"\\local\\";
    const std::wstring localcache_marker = L"\\localcache\\";
    const std::wstring temp_marker = L"\\temp\\";
    const std::wstring roamingstate_marker = L"\\roamingstate\\";
    const std::wstring sharedstate_marker = L"\\sharedstate\\";

    size_t pos = lower_path.find(packages_marker);
    if (pos != std::wstring::npos)
    {

      size_t after_packages = pos + packages_marker.length();

      size_t package_end = lower_path.find(L'\\', after_packages);
      if (package_end != std::wstring::npos)
      {
        std::wstring remainder = lower_path.substr(package_end);

        if (remainder.find(localcache_marker) != std::wstring::npos)
        {
          size_t temp_pos = remainder.find(temp_marker);
          if (temp_pos != std::wstring::npos)
          {
            folder_type = 2;
            relative_path = path.substr(package_end + temp_pos + temp_marker.length());
            return true;
          }

          folder_type = 1;
          size_t localcache_pos = remainder.find(localcache_marker);
          relative_path = path.substr(package_end + localcache_pos + localcache_marker.length());
          return true;
        }

        if (remainder.find(roamingstate_marker) != std::wstring::npos)
        {
          folder_type = 3;
          size_t roaming_pos = remainder.find(roamingstate_marker);
          relative_path = path.substr(package_end + roaming_pos + roamingstate_marker.length());
          return true;
        }

        if (remainder.find(sharedstate_marker) != std::wstring::npos)
        {
          folder_type = 4;
          size_t shared_pos = remainder.find(sharedstate_marker);
          relative_path = path.substr(package_end + shared_pos + sharedstate_marker.length());
          return true;
        }

        if (remainder.find(local_marker) != std::wstring::npos)
        {
          size_t local_pos = remainder.find(local_marker);

          if (remainder.substr(local_pos, localcache_marker.length()) != localcache_marker)
          {
            folder_type = 0;
            relative_path = path.substr(package_end + local_pos + local_marker.length());
            return true;
          }
        }
      }
    }

    return false;
  }

  HRESULT SharePlusWindowsPlugin::GetStorageFileFromApplicationData(
      const std::wstring &path, WindowsStorage::IStorageFile **file)
  {
    using Microsoft::WRL::Wrappers::HStringReference;

    std::wstring relative_path;
    int folder_type;

    if (!IsApplicationDataPath(path, relative_path, folder_type))
    {
      return E_INVALIDARG;
    }

    HRESULT hr = S_OK;
    *file = nullptr;

    WRL::ComPtr<WindowsStorage::IApplicationDataStatics> app_data_statics;
    hr = WindowsFoundation::GetActivationFactory(
        HStringReference(RuntimeClass_Windows_Storage_ApplicationData).Get(),
        &app_data_statics);

    if (FAILED(hr))
    {
      return hr;
    }

    WRL::ComPtr<WindowsStorage::IApplicationData> app_data;
    hr = app_data_statics->get_Current(&app_data);

    if (FAILED(hr))
    {
      return hr;
    }

    WRL::ComPtr<WindowsStorage::IStorageFolder> folder;
    switch (folder_type)
    {
    case 0:
      hr = app_data->get_LocalFolder(&folder);
      break;
    case 1:
    {
      WRL::ComPtr<WindowsStorage::IApplicationData2> app_data2;
      hr = app_data.As(&app_data2);
      if (SUCCEEDED(hr))
      {
        hr = app_data2->get_LocalCacheFolder(&folder);
      }
    }
    break;
    case 2:
      hr = app_data->get_TemporaryFolder(&folder);
      break;
    case 3:
      hr = app_data->get_RoamingFolder(&folder);
      break;
    case 4:
    {
      WRL::ComPtr<WindowsStorage::IApplicationData2> app_data2;
      hr = app_data.As(&app_data2);
      if (SUCCEEDED(hr))
      {
        hr = app_data2->get_SharedLocalFolder(&folder);
      }
    }
    break;
    default:
      return E_INVALIDARG;
    }

    if (FAILED(hr) || !folder)
    {
      return hr;
    }

    WRL::ComPtr<WindowsFoundation::IAsyncOperation<WindowsStorage::StorageFile *>>
        async_operation;
    hr = folder->GetFileAsync(HStringReference(relative_path.c_str()).Get(),
                              &async_operation);

    if (SUCCEEDED(hr))
    {
      WRL::ComPtr<IAsyncInfo> info;
      hr = async_operation.As(&info);
      if (SUCCEEDED(hr))
      {
        AsyncStatus status;
        while (SUCCEEDED(hr = info->get_Status(&status)) &&
               status == AsyncStatus::Started)
          SleepEx(0, TRUE);
        if (FAILED(hr) || status != AsyncStatus::Completed)
        {
          info->get_ErrorCode(&hr);
        }
        else
        {
          hr = async_operation->GetResults(file);
        }
      }
    }

    return hr;
  }

  HRESULT SharePlusWindowsPlugin::GetStorageFileFromPath(
      wchar_t *path, WindowsStorage::IStorageFile **file)
  {
    using Microsoft::WRL::Wrappers::HStringReference;

    if (path == nullptr || file == nullptr)
    {
      return E_POINTER;
    }

    *file = nullptr;
    std::wstring path_wstr(path);

    std::wstring relative_path;
    int folder_type;
    if (IsApplicationDataPath(path_wstr, relative_path, folder_type))
    {
      HRESULT hr = GetStorageFileFromApplicationData(path_wstr, file);
      if (SUCCEEDED(hr) && *file != nullptr)
      {
        return hr;
      }
    }

    WRL::ComPtr<WindowsStorage::IStorageFileStatics> factory = nullptr;
    HRESULT hr = WindowsFoundation::GetActivationFactory(
        HStringReference(RuntimeClass_Windows_Storage_StorageFile).Get(),
        &factory);

    if (FAILED(hr))
    {
      return hr;
    }

    WRL::ComPtr<
        WindowsFoundation::IAsyncOperation<WindowsStorage::StorageFile *>>
        async_operation;
    hr = factory->GetFileFromPathAsync(HStringReference(path).Get(),
                                       &async_operation);
    if (SUCCEEDED(hr))
    {
      WRL::ComPtr<IAsyncInfo> info;
      hr = async_operation.As(&info);
      if (SUCCEEDED(hr))
      {
        AsyncStatus status;
        while (SUCCEEDED(hr = info->get_Status(&status)) &&
               status == AsyncStatus::Started)
          SleepEx(0, TRUE);
        if (FAILED(hr) || status != AsyncStatus::Completed)
        {
          info->get_ErrorCode(&hr);
        }
        else
        {
          hr = async_operation->GetResults(file);
        }
      }
    }
    return hr;
  }

  void SharePlusWindowsPlugin::HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result)
  {

    if (method_call.method_name().compare(kShare) == 0)
    {
      auto data_transfer_manager = GetDataTransferManager();

      if (!data_transfer_manager)
      {
        result->Error("UNAVAILABLE", "Data transfer manager not available");
        return;
      }

      auto args = std::get<flutter::EncodableMap>(*method_call.arguments());

      if (auto text_value = std::get_if<std::string>(
              &args[flutter::EncodableValue("text")]))
      {
        share_text_ = *text_value;
      }
      if (auto subject_value = std::get_if<std::string>(
              &args[flutter::EncodableValue("subject")]))
      {
        share_subject_ = *subject_value;
      }
      if (auto uri_value = std::get_if<std::string>(
              &args[flutter::EncodableValue("uri")]))
      {
        share_uri_ = *uri_value;
      }
      if (auto title_value = std::get_if<std::string>(
              &args[flutter::EncodableValue("title")]))
      {
        share_title_ = *title_value;
      }
      if (auto paths = std::get_if<flutter::EncodableList>(
              &args[flutter::EncodableValue("paths")]))
      {
        paths_.clear();
        for (auto &path : *paths)
        {
          paths_.emplace_back(std::get<std::string>(path));
        }
      }
      if (auto mime_types = std::get_if<flutter::EncodableList>(
              &args[flutter::EncodableValue("mimeTypes")]))
      {
        mime_types_.clear();
        for (auto &mime_type : *mime_types)
        {
          mime_types_.emplace_back(std::get<std::string>(mime_type));
        }
      }

      // Create the share callback
      auto callback = WRL::Callback<WindowsFoundation::ITypedEventHandler<
          DataTransfer::DataTransferManager *,
          DataTransfer::DataRequestedEventArgs *>>(
          [&](auto &&, DataTransfer::IDataRequestedEventArgs *e)
          {
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
            if (share_title_ && !share_title_.value_or("").empty())
            {
              auto title = Utf16FromUtf8(share_title_.value_or(""));
              properties->put_Title(HStringReference(title.c_str()).Get());
            }
            else if (share_subject_ && !share_subject_.value_or("").empty())
            {
              auto title = Utf16FromUtf8(share_subject_.value_or(""));
              properties->put_Title(HStringReference(title.c_str()).Get());
            }
            else
            {
              auto title = Utf16FromUtf8(share_text_.value_or(""));
              properties->put_Title(HStringReference(title.c_str()).Get());
            }

            // Set the text of the share dialog
            if (share_text_ && !share_text_.value_or("").empty())
            {
              auto text = Utf16FromUtf8(share_text_.value_or(""));
              properties->put_Description(
                  HStringReference(text.c_str()).Get());
              data->SetText(HStringReference(text.c_str()).Get());
            }

            // If URI provided, set the URI to share
            if (share_uri_ && !share_uri_.value_or("").empty())
            {
              auto uri = Utf16FromUtf8(share_uri_.value_or(""));
              properties->put_Description(
                  HStringReference(uri.c_str()).Get());
              data->SetText(HStringReference(uri.c_str()).Get());
            }

            // Add files to the data.
            Vector<WindowsStorage::IStorageItem *> storage_items;
            for (const std::string &path : paths_)
            {
              auto str = Utf16FromUtf8(path);
              wchar_t *ptr = const_cast<wchar_t *>(str.c_str());
              WindowsStorage::IStorageFile *file = nullptr;
              if (SUCCEEDED(GetStorageFileFromPath(ptr, &file)) &&
                  file != nullptr)
              {
                storage_items.Append(
                    reinterpret_cast<WindowsStorage::IStorageItem *>(file));
              }
            }
            data->SetStorageItemsReadOnly(&storage_items);

            return S_OK;
          });

      // Add the callback to the data transfer manager
      data_transfer_manager->add_DataRequested(callback.Get(),
                                               &data_transfer_manager_token_);
      if (data_transfer_manager_interop_ != nullptr)
      {
        data_transfer_manager_interop_->ShowShareUIForWindow(GetWindow());
      }
      result->Success(flutter::EncodableValue(kShareResultUnavailable));
    }
    else
    {
      result->NotImplemented();
    }
  }

  // Converts string encoded in UTF-8 to wstring.
  // Returns an empty |std::wstring| on failure.
  // Present as static helper method.
  std::wstring SharePlusWindowsPlugin::Utf16FromUtf8(std::string string)
  {
    if (string.empty())
    {
      return std::wstring();
    }

    int size_needed =
        MultiByteToWideChar(CP_UTF8, 0, string.c_str(), -1, NULL, 0);
    if (size_needed <= 0)
    {
      return std::wstring();
    }

    std::wstring result(size_needed - 1, 0);
    int converted_length = MultiByteToWideChar(CP_UTF8, 0, string.c_str(), -1,
                                               &result[0], size_needed);
    if (converted_length == 0)
    {
      return std::wstring();
    }
    return result;
  }

} // namespace share_plus_windows
