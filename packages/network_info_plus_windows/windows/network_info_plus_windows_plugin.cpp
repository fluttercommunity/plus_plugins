// clang-format off
#include "include/network_info_plus_windows/network_info.h"
// clang-format on
#include "include/network_info_plus_windows/network_info_plus_windows_plugin.h"

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <flutter/standard_method_codec.h>


namespace {

class NetworkInfoPlusWindowsPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  NetworkInfoPlusWindowsPlugin();

  virtual ~NetworkInfoPlusWindowsPlugin();

 private:
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void HandleMethodResult(
      const std::string &value,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> &result);

  NetworkInfo _networkInfo;
};

// static
void NetworkInfoPlusWindowsPlugin::RegisterWithRegistrar(
    flutter::PluginRegistrarWindows *registrar) {
  auto channel =
      std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
          registrar->messenger(), "dev.fluttercommunity.plus/network_info",
          &flutter::StandardMethodCodec::GetInstance());

  auto plugin = std::make_unique<NetworkInfoPlusWindowsPlugin>();

  channel->SetMethodCallHandler(
      [plugin_pointer = plugin.get()](const auto &call, auto result) {
        plugin_pointer->HandleMethodCall(call, std::move(result));
      });

  registrar->AddPlugin(std::move(plugin));
}

NetworkInfoPlusWindowsPlugin::NetworkInfoPlusWindowsPlugin() {}

NetworkInfoPlusWindowsPlugin::~NetworkInfoPlusWindowsPlugin() {}

void NetworkInfoPlusWindowsPlugin::HandleMethodCall(
    const flutter::MethodCall<flutter::EncodableValue> &method_call,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (method_call.method_name().compare("wifiName") == 0) {
    HandleMethodResult(_networkInfo.GetWifiName(), result);
  } else if (method_call.method_name().compare("wifiBSSID") == 0) {
    HandleMethodResult(_networkInfo.GetWifiBssid(), result);
  } else if (method_call.method_name().compare("wifiIPAddress") == 0) {
    HandleMethodResult(_networkInfo.GetWifiIpAddress(), result);
  } else {
    result->NotImplemented();
  }
}

void NetworkInfoPlusWindowsPlugin::HandleMethodResult(
    const std::string &value,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> &result) {
  if (_networkInfo.HasError()) {
    result->Error(std::to_string(_networkInfo.GetError()),
                  _networkInfo.GetErrorString());
  } else {
    result->Success(flutter::EncodableValue(value));
  }
}

}  // namespace

void NetworkInfoPlusWindowsPluginRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  NetworkInfoPlusWindowsPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
