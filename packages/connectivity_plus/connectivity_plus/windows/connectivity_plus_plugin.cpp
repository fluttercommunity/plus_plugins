// clang-format off
#include "include/connectivity_plus/network_manager.h"
// clang-format on
#include "include/connectivity_plus/connectivity_plus_windows_plugin.h"

#include <flutter/event_channel.h>
#include <flutter/event_sink.h>
#include <flutter/event_stream_handler.h>
#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <flutter/standard_method_codec.h>

#include <functional>
#include <memory>

namespace {

typedef flutter::EventChannel<flutter::EncodableValue> FlEventChannel;
typedef flutter::EventSink<flutter::EncodableValue> FlEventSink;
typedef flutter::MethodCall<flutter::EncodableValue> FlMethodCall;
typedef flutter::MethodResult<flutter::EncodableValue> FlMethodResult;
typedef flutter::MethodChannel<flutter::EncodableValue> FlMethodChannel;
typedef flutter::StreamHandler<flutter::EncodableValue> FlStreamHandler;
typedef flutter::StreamHandlerError<flutter::EncodableValue>
    FlStreamHandlerError;

class ConnectivityPlusWindowsPlugin : public flutter::Plugin {
public:
  ConnectivityPlusWindowsPlugin();
  virtual ~ConnectivityPlusWindowsPlugin();

  std::shared_ptr<NetworkManager> GetManager() const;

  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

private:
  void HandleMethodCall(const FlMethodCall &method_call,
                        std::unique_ptr<FlMethodResult> result);

  std::shared_ptr<NetworkManager> manager;
};

class ConnectivityStreamHandler : public FlStreamHandler {
public:
  ConnectivityStreamHandler(std::shared_ptr<NetworkManager> manager);
  virtual ~ConnectivityStreamHandler();

protected:
  void AddConnectivityEvent();

  std::unique_ptr<FlStreamHandlerError>
  OnListenInternal(const flutter::EncodableValue *arguments,
                   std::unique_ptr<FlEventSink> &&sink) override;

  std::unique_ptr<FlStreamHandlerError>
  OnCancelInternal(const flutter::EncodableValue *arguments) override;

private:
  std::shared_ptr<NetworkManager> manager;
  std::unique_ptr<FlEventSink> sink;
};

ConnectivityPlusWindowsPlugin::ConnectivityPlusWindowsPlugin() {
  manager = std::make_shared<NetworkManager>();
  manager->Init();
}

ConnectivityPlusWindowsPlugin::~ConnectivityPlusWindowsPlugin() {
  manager->Cleanup();
}

std::shared_ptr<NetworkManager>
ConnectivityPlusWindowsPlugin::GetManager() const {
  return manager;
}

void ConnectivityPlusWindowsPlugin::RegisterWithRegistrar(
    flutter::PluginRegistrarWindows *registrar) {
  auto plugin = std::make_unique<ConnectivityPlusWindowsPlugin>();

  auto methodChannel =
      std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
          registrar->messenger(), "dev.fluttercommunity.plus/connectivity",
          &flutter::StandardMethodCodec::GetInstance());

  methodChannel->SetMethodCallHandler(
      [plugin_pointer = plugin.get()](const auto &call, auto result) {
        plugin_pointer->HandleMethodCall(call, std::move(result));
      });

  auto eventChannel = std::make_unique<FlEventChannel>(
      registrar->messenger(), "dev.fluttercommunity.plus/connectivity_status",
      &flutter::StandardMethodCodec::GetInstance());

  eventChannel->SetStreamHandler(
      std::make_unique<ConnectivityStreamHandler>(plugin->GetManager()));

  registrar->AddPlugin(std::move(plugin));
}

static std::string ConnectivityToString(ConnectivityType connectivityType) {
  switch (connectivityType) {
  case ConnectivityType::WiFi:
    return "wifi";
  case ConnectivityType::Ethernet:
    return "ethernet";
  case ConnectivityType::None:
  default:
    return "none";
  }
}

void ConnectivityPlusWindowsPlugin::HandleMethodCall(
    const flutter::MethodCall<flutter::EncodableValue> &method_call,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (method_call.method_name().compare("check") == 0) {
    std::string connectivity =
        ConnectivityToString(manager->GetConnectivityType());
    result->Success(flutter::EncodableValue(connectivity));
  } else {
    result->NotImplemented();
  }
}

ConnectivityStreamHandler::ConnectivityStreamHandler(
    std::shared_ptr<NetworkManager> manager)
    : manager(manager) {}

ConnectivityStreamHandler::~ConnectivityStreamHandler() {}

void ConnectivityStreamHandler::AddConnectivityEvent() {
  std::string connectivity =
      ConnectivityToString(manager->GetConnectivityType());
  sink->Success(flutter::EncodableValue(connectivity));
}

std::unique_ptr<FlStreamHandlerError>
ConnectivityStreamHandler::OnListenInternal(
    const flutter::EncodableValue *arguments,
    std::unique_ptr<FlEventSink> &&events) {
  sink = std::move(events);

  auto callback =
      std::bind(&ConnectivityStreamHandler::AddConnectivityEvent, this);

  if (!manager->StartListen(callback)) {
    return std::make_unique<FlStreamHandlerError>(
        std::to_string(manager->GetError()), "NetworkManager::StartListen",
        nullptr);
  }

  AddConnectivityEvent();
  return nullptr;
}

std::unique_ptr<FlStreamHandlerError>
ConnectivityStreamHandler::OnCancelInternal(
    const flutter::EncodableValue *arguments) {
  manager->StopListen();
  sink.reset();
  return nullptr;
}

} // namespace

void ConnectivityPlusWindowsPluginRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  ConnectivityPlusWindowsPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
