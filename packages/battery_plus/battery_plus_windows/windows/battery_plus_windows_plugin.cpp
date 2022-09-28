#include "include/battery_plus_windows/battery_plus_windows_plugin.h"

#include <flutter/event_channel.h>
#include <flutter/event_sink.h>
#include <flutter/event_stream_handler.h>
#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <flutter/standard_method_codec.h>
#include <windows.h>

#include <functional>
#include <memory>

#include "include/battery_plus_windows/system_battery.h"

namespace {

typedef flutter::EventChannel<flutter::EncodableValue> FlEventChannel;
typedef flutter::EventSink<flutter::EncodableValue> FlEventSink;
typedef flutter::MethodCall<flutter::EncodableValue> FlMethodCall;
typedef flutter::MethodResult<flutter::EncodableValue> FlMethodResult;
typedef flutter::MethodChannel<flutter::EncodableValue> FlMethodChannel;
typedef flutter::StreamHandler<flutter::EncodableValue> FlStreamHandler;
typedef flutter::StreamHandlerError<flutter::EncodableValue>
    FlStreamHandlerError;

class BatteryPlusWindowsPlugin : public flutter::Plugin {
public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  BatteryPlusWindowsPlugin(flutter::PluginRegistrarWindows *registrar);
  ~BatteryPlusWindowsPlugin();

private:
  void HandleMethodCall(const FlMethodCall &method_call,
                        std::unique_ptr<FlMethodResult> result);
  std::unique_ptr<FlMethodChannel> _methodChannel;
  std::unique_ptr<FlEventChannel> _eventChannel;
};

class BatteryStatusStreamHandler : public FlStreamHandler {
public:
  BatteryStatusStreamHandler(flutter::PluginRegistrarWindows *registrar);

protected:
  void AddStatusEvent(BatteryStatus status);

  std::unique_ptr<FlStreamHandlerError>
  OnListenInternal(const flutter::EncodableValue *arguments,
                   std::unique_ptr<FlEventSink> &&events) override;

  std::unique_ptr<FlStreamHandlerError>
  OnCancelInternal(const flutter::EncodableValue *arguments) override;

private:
  int _delegate = -1;
  SystemBattery _battery;
  std::unique_ptr<FlEventSink> _events;
  flutter::PluginRegistrarWindows *_registrar = nullptr;
};

void BatteryPlusWindowsPlugin::RegisterWithRegistrar(
    flutter::PluginRegistrarWindows *registrar) {
  registrar->AddPlugin(std::make_unique<BatteryPlusWindowsPlugin>(registrar));
}

BatteryPlusWindowsPlugin::BatteryPlusWindowsPlugin(
    flutter::PluginRegistrarWindows *registrar) {
  _methodChannel = std::make_unique<FlMethodChannel>(
      registrar->messenger(), "dev.fluttercommunity.plus/battery",
      &flutter::StandardMethodCodec::GetInstance());

  _methodChannel->SetMethodCallHandler([this](const auto &call, auto result) {
    HandleMethodCall(call, std::move(result));
  });

  _eventChannel = std::make_unique<FlEventChannel>(
      registrar->messenger(), "dev.fluttercommunity.plus/charging",
      &flutter::StandardMethodCodec::GetInstance());

  _eventChannel->SetStreamHandler(
      std::make_unique<BatteryStatusStreamHandler>(registrar));
}

BatteryPlusWindowsPlugin::~BatteryPlusWindowsPlugin() {}

BatteryStatusStreamHandler::BatteryStatusStreamHandler(
    flutter::PluginRegistrarWindows *registrar)
    : _registrar(registrar) {}

void BatteryStatusStreamHandler::AddStatusEvent(BatteryStatus status) {
  if (status != BatteryStatus::Error) {
    _events->Success(_battery.GetStatusString());
  } else {
    _events->Error(std::to_string(_battery.GetError()),
                   _battery.GetErrorString());
  }
}

std::unique_ptr<FlStreamHandlerError>
BatteryStatusStreamHandler::OnListenInternal(
    const flutter::EncodableValue *arguments,
    std::unique_ptr<FlEventSink> &&events) {
  _events = std::move(events);

  HWND hwnd = _registrar->GetView()->GetNativeWindow();
  BatteryStatusCallback callback = std::bind(
      &BatteryStatusStreamHandler::AddStatusEvent, this, std::placeholders::_1);

  if (!_battery.StartListen(hwnd, callback)) {
    return std::make_unique<FlStreamHandlerError>(
        std::to_string(_battery.GetError()), _battery.GetErrorString(),
        nullptr);
  }

  _delegate = _registrar->RegisterTopLevelWindowProcDelegate(
      [this](HWND hwnd, UINT message, WPARAM wparam, LPARAM lparam) {
        _battery.ProcessMsg(hwnd, message, wparam, lparam);
        return std::nullopt;
      });

  AddStatusEvent(_battery.GetStatus());
  return nullptr;
}

std::unique_ptr<FlStreamHandlerError>
BatteryStatusStreamHandler::OnCancelInternal(
    const flutter::EncodableValue *arguments) {
  _registrar->UnregisterTopLevelWindowProcDelegate(_delegate);
  if (!_battery.StopListen()) {
    return std::make_unique<FlStreamHandlerError>(
        std::to_string(_battery.GetError()), _battery.GetErrorString(),
        nullptr);
  }
  _delegate = -1;
  _events.reset();
  return nullptr;
}

void BatteryPlusWindowsPlugin::HandleMethodCall(
    const FlMethodCall &method_call, std::unique_ptr<FlMethodResult> result) {
  if (method_call.method_name().compare("isInBatterySaveMode") == 0) {
    SystemBattery battery;
    int batteryStatus = battery.GetBatterySaveMode();
    if (batteryStatus == 0 || batteryStatus == 1) {
      bool isBatteryMode = batteryStatus == 1;
      result->Success(flutter::EncodableValue(isBatteryMode));
    } else {
      result->Error(std::to_string(battery.GetError()),
                    battery.GetErrorString());
    }
  } else if (method_call.method_name().compare("getBatteryLevel") == 0) {
    SystemBattery battery;
    int level = battery.GetLevel();
    if (level >= 0) {
      result->Success(flutter::EncodableValue(level));
    } else {
      result->Error(std::to_string(battery.GetError()),
                    battery.GetErrorString());
    }
  } else if (method_call.method_name().compare("getBatteryState") == 0) {
    SystemBattery battery;
    result->Success(flutter::EncodableValue(battery.GetStatusString()));
  } else {
    result->NotImplemented();
  }
}

} // namespace

void BatteryPlusWindowsPluginRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  BatteryPlusWindowsPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
