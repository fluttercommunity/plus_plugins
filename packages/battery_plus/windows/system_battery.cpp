#include "include/battery_plus_windows/system_battery.h"

#include <winnt.h>

namespace {
enum ACLineStatus {
  Offline = 0,
  Online = 1,
};

enum BatteryLevel {
  Empty = 0,
  Full = 100,
  Unknown = 255,
};

enum BatteryFlag {
  High = 1,     // the battery capacity is at more than 66 percent
  Low = 2,      // the battery capacity is at less than 33 percent
  Critical = 4, // the battery capacity is at less than five percent
  Charging = 8,
  NoBattery = 128 // no system battery
};

bool GetBatteryStatus(LPSYSTEM_POWER_STATUS lpStatus) {
  return GetSystemPowerStatus(lpStatus) != 0;
}

bool IsValidBatteryStatus(LPSYSTEM_POWER_STATUS lpStatus) {
  return lpStatus->BatteryFlag != NoBattery &&
         lpStatus->BatteryLifePercent != Unknown;
}
} // namespace

SystemBattery::SystemBattery() {}

SystemBattery::~SystemBattery() { StopListen(); }

int SystemBattery::GetBatterySaveMode() const {
  SYSTEM_POWER_STATUS status;
  if (!GetBatteryStatus(&status)) {
    return -1;
  }
  return status.SystemStatusFlag;
}

int SystemBattery::GetLevel() const {
  SYSTEM_POWER_STATUS status;
  if (!GetBatteryStatus(&status) || !IsValidBatteryStatus(&status)) {
    return -1;
  }
  return status.BatteryLifePercent;
}

BatteryStatus SystemBattery::GetStatus() const {
  SYSTEM_POWER_STATUS status;
  if (!GetBatteryStatus(&status)) {
    return BatteryStatus::Error;
  }
  if (IsValidBatteryStatus(&status)) {
    if (status.ACLineStatus == Online) {
      if (status.BatteryLifePercent == Full) {
        return BatteryStatus::Full;
      } else if (status.BatteryFlag & Charging) {
        return BatteryStatus::Charging;
      }
    } else if (status.ACLineStatus == Offline) {
      if (!(status.BatteryFlag & Charging)) {
        return BatteryStatus::Discharging;
      }
    }
  }
  return BatteryStatus::Unknown;
}

std::string SystemBattery::GetStatusString() const {
  switch (GetStatus()) {
  case BatteryStatus::Charging:
    return "charging";
  case BatteryStatus::Discharging:
    return "discharging";
  case BatteryStatus::Full:
    return "full";
  case BatteryStatus::Unknown:
  default:
    return "unknown";
  }
}

int SystemBattery::GetError() const { return GetLastError(); }

std::string SystemBattery::GetErrorString() const {
  // ### TODO: FormatMessage()
  return "GetSystemPowerStatus() failed";
}

bool SystemBattery::StartListen(HWND hwnd, BatteryStatusCallback callback) {
  if (_notifier) {
    return false;
  }
  _callback = callback;
  _notifier = RegisterPowerSettingNotification(hwnd, &GUID_ACDC_POWER_SOURCE,
                                               DEVICE_NOTIFY_WINDOW_HANDLE);
  return _notifier != nullptr;
}

void SystemBattery::ProcessMsg(HWND hwnd, UINT message, WPARAM wparam,
                               LPARAM lparam) {
  if (!_callback) {
    return;
  }
  if (message == WM_POWERBROADCAST && wparam == PBT_APMPOWERSTATUSCHANGE) {
    _callback(GetStatus());
  }
}

bool SystemBattery::StopListen() {
  if (!_notifier) {
    return false;
  }
  HPOWERNOTIFY notifier = nullptr;
  std::swap(notifier, _notifier);
  _callback = nullptr;
  return UnregisterPowerSettingNotification(notifier) != 0;
}
