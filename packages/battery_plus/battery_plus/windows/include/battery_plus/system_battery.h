#ifndef FLUTTER_PLUGIN_BATTERY_PLUS_SYSTEM_BATTERY_H_
#define FLUTTER_PLUGIN_BATTERY_PLUS_SYSTEM_BATTERY_H_

#include <flutter_plugin_registrar.h>
#include <windows.h>

#include <functional>
#include <string>

enum class BatteryStatus { Full, Charging, Discharging, Error, Unknown };

typedef std::function<void(BatteryStatus)> BatteryStatusCallback;

class SystemBattery {
public:
  SystemBattery();
  ~SystemBattery();

  int GetBatterySaveMode() const;
  int GetLevel() const;

  BatteryStatus GetStatus() const;
  std::string GetStatusString() const;

  int GetError() const;
  std::string GetErrorString() const;

  bool StartListen(HWND hwnd, BatteryStatusCallback callback);
  void ProcessMsg(HWND hwnd, UINT message, WPARAM wparam, LPARAM lparam);
  bool StopListen();

private:
  HPOWERNOTIFY _notifier = nullptr;
  BatteryStatusCallback _callback = nullptr;
};

#endif // FLUTTER_PLUGIN_BATTERY_PLUS_SYSTEM_BATTERY_H_
