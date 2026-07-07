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

#include <algorithm>
#include <functional>
#include <map>
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
  bool TryStartListen();
  void ScheduleStartListenRetry();
  void CancelStartListenRetry();
  static void CALLBACK RetryTimerProc(HWND hwnd, UINT message, UINT_PTR id,
                                      DWORD time);

  // Thread-affine (platform thread), like the stream handler itself.
  static std::map<UINT_PTR, ConnectivityStreamHandler *> retry_handlers_;

  std::shared_ptr<NetworkManager> manager;
  std::unique_ptr<FlEventSink> sink;
  UINT_PTR retry_timer_id_ = 0;
  int retry_attempts_ = 0;
};

std::map<UINT_PTR, ConnectivityStreamHandler *>
    ConnectivityStreamHandler::retry_handlers_;

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
  case ConnectivityType::VPN:
    return "vpn";
  case ConnectivityType::Other:
    return "other";
  case ConnectivityType::None:
  default:
    return "none";
  }
}

static flutter::EncodableList
EncodeConnectivityTypes(std::set<ConnectivityType> connectivityTypes) {
  flutter::EncodableList encodedList;

  if (connectivityTypes.empty()) {
    encodedList.push_back(
        flutter::EncodableValue(ConnectivityToString(ConnectivityType::None)));
    return encodedList;
  }

  for (const auto &type : connectivityTypes) {
    std::string connectivityString = ConnectivityToString(type);
    encodedList.push_back(flutter::EncodableValue(connectivityString));
  }

  return encodedList;
}

void ConnectivityPlusWindowsPlugin::HandleMethodCall(
    const flutter::MethodCall<flutter::EncodableValue> &method_call,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (method_call.method_name().compare("check") == 0) {
    result->Success(EncodeConnectivityTypes(manager->GetConnectivityTypes()));
  } else {
    result->NotImplemented();
  }
}

ConnectivityStreamHandler::ConnectivityStreamHandler(
    std::shared_ptr<NetworkManager> manager)
    : manager(manager) {}

ConnectivityStreamHandler::~ConnectivityStreamHandler() {
  CancelStartListenRetry();
}

void ConnectivityStreamHandler::AddConnectivityEvent() {
  sink->Success(EncodeConnectivityTypes(manager->GetConnectivityTypes()));
}

bool ConnectivityStreamHandler::TryStartListen() {
  auto callback =
      std::bind(&ConnectivityStreamHandler::AddConnectivityEvent, this);
  return manager->StartListen(callback);
}

void ConnectivityStreamHandler::ScheduleStartListenRetry() {
  // 100ms, 200ms, 400ms, ... — enough to escape whatever input-synchronous
  // window the platform thread was inside.
  UINT delay = 100u << (std::min)(retry_attempts_, 4);
  retry_timer_id_ = SetTimer(nullptr, 0, delay, RetryTimerProc);
  if (retry_timer_id_ != 0) {
    retry_handlers_[retry_timer_id_] = this;
  }
}

void ConnectivityStreamHandler::CancelStartListenRetry() {
  if (retry_timer_id_ != 0) {
    KillTimer(nullptr, retry_timer_id_);
    retry_handlers_.erase(retry_timer_id_);
    retry_timer_id_ = 0;
  }
}

void CALLBACK ConnectivityStreamHandler::RetryTimerProc(HWND hwnd,
                                                        UINT message,
                                                        UINT_PTR id,
                                                        DWORD time) {
  KillTimer(hwnd, id);
  auto it = retry_handlers_.find(id);
  if (it == retry_handlers_.end()) {
    return;
  }
  ConnectivityStreamHandler *self = it->second;
  retry_handlers_.erase(it);
  self->retry_timer_id_ = 0;

  if (!self->sink) {
    return; // Cancelled while the retry was pending.
  }

  if (self->TryStartListen()) {
    self->AddConnectivityEvent();
    return;
  }

  if (self->manager->GetError() == RPC_E_CANTCALLOUT_ININPUTSYNCCALL &&
      ++self->retry_attempts_ < 5) {
    self->ScheduleStartListenRetry();
    return;
  }

  // Persistent failure: report through the sink, where Dart-side stream
  // onError handlers can observe it (unlike an OnListen error, which the
  // framework can only surface as an uncatchable FlutterError).
  self->sink->Error(std::to_string(self->manager->GetError()),
                    "NetworkManager::StartListen", nullptr);
}

std::unique_ptr<FlStreamHandlerError>
ConnectivityStreamHandler::OnListenInternal(
    const flutter::EncodableValue *arguments,
    std::unique_ptr<FlEventSink> &&events) {
  sink = std::move(events);

  if (!TryStartListen()) {
    if (manager->GetError() == RPC_E_CANTCALLOUT_ININPUTSYNCCALL) {
      // The platform thread is inside an input-synchronous call (e.g. a
      // SendMessage-driven window callback), where COM rejects the outgoing
      // Advise. The subscription itself is fine — retry once the message
      // loop spins, and still emit the initial snapshot below.
      retry_attempts_ = 0;
      ScheduleStartListenRetry();
    } else {
      return std::make_unique<FlStreamHandlerError>(
          std::to_string(manager->GetError()), "NetworkManager::StartListen",
          nullptr);
    }
  }

  AddConnectivityEvent();
  return nullptr;
}

std::unique_ptr<FlStreamHandlerError>
ConnectivityStreamHandler::OnCancelInternal(
    const flutter::EncodableValue *arguments) {
  CancelStartListenRetry();
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
