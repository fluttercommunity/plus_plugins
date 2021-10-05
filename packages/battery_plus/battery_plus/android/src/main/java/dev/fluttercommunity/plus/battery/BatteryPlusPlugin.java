// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package dev.fluttercommunity.plus.battery;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.ContextWrapper;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.BatteryManager;
import android.os.Build;
import android.os.Build.VERSION;
import android.os.Build.VERSION_CODES;
import android.os.PowerManager;
import android.provider.Settings;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.EventChannel.EventSink;
import io.flutter.plugin.common.EventChannel.StreamHandler;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;
import java.util.Locale;

/** BatteryPlusPlugin */
public class BatteryPlusPlugin implements MethodCallHandler, StreamHandler, FlutterPlugin {

  private Context applicationContext;
  private BroadcastReceiver chargingStateChangeReceiver;
  private MethodChannel methodChannel;
  private EventChannel eventChannel;

  public static final String POWER_SAVE_MODE_SAMSUNG = "1";
  private static final int POWER_SAVE_MODE_XIAOMI = 1;
  private static final int POWER_SAVE_MODE_HUAWEI = 4;

  /** Plugin registration. */
  public static void registerWith(PluginRegistry.Registrar registrar) {
    final BatteryPlusPlugin instance = new BatteryPlusPlugin();
    instance.onAttachedToEngine(registrar.context(), registrar.messenger());
  }

  @Override
  public void onAttachedToEngine(FlutterPluginBinding binding) {
    onAttachedToEngine(binding.getApplicationContext(), binding.getBinaryMessenger());
  }

  private void onAttachedToEngine(Context applicationContext, BinaryMessenger messenger) {
    this.applicationContext = applicationContext;
    methodChannel = new MethodChannel(messenger, "dev.fluttercommunity.plus/battery");
    eventChannel = new EventChannel(messenger, "dev.fluttercommunity.plus/charging");
    eventChannel.setStreamHandler(this);
    methodChannel.setMethodCallHandler(this);
  }

  @Override
  public void onDetachedFromEngine(FlutterPluginBinding binding) {
    applicationContext = null;
    methodChannel.setMethodCallHandler(null);
    methodChannel = null;
    eventChannel.setStreamHandler(null);
    eventChannel = null;
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    Intent intent =
        new ContextWrapper(applicationContext)
            .registerReceiver(null, new IntentFilter(Intent.ACTION_BATTERY_CHANGED));
    BatteryManager batteryManager =
        (BatteryManager) applicationContext.getSystemService(Context.BATTERY_SERVICE);

    switch (call.method) {
      case "isBatteryPresent":
        result.success(intent.getExtras().getBoolean(BatteryManager.EXTRA_PRESENT));

      case "getBatteryLevel":
        int batteryLevel = getBatteryLevel(intent);
        if (batteryLevel != -1) result.success(batteryLevel);
        else result.error("UNAVAILABLE", "Battery level not available.", null);
        break;

      case "isInBatterySaveMode":
        Boolean isInPowerSaveMode = this.isInPowerSaveMode();
        if (isInPowerSaveMode != null) result.success(isInPowerSaveMode);
        else result.error("UNAVAILABLE", "Battery save mode not available.", null);
        break;

      case "getBatteryHealth":
        String batteryHealth = this.getBatteryHealth(intent);
        if (batteryHealth != "") result.success(batteryHealth);
        else result.error("UNAVAILABLE", "Battery health is not available.", null);
        break;

      case "getBatteryCapacity":
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.LOLLIPOP) {
          result.success(
              batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CHARGE_COUNTER));
        } else {
          result.error("UNAVAILABLE", "Battery capacity is not available.", null);
        }
        break;

      case "getBatteryPluggedType":
        String plugged = "";
        plugged = this.getBatteryPluggedType(intent);
        if (plugged != "") result.success(plugged);
        else result.error("UNAVAILABLE", "Battery pluggedin type is not available.", null);
        break;

      case "getBatteryTechnology":
        String technology = "";

        if (intent.getExtras() != null) {
          technology = intent.getExtras().getString(BatteryManager.EXTRA_TECHNOLOGY);
        }
        if (technology != "") result.success(technology);
        else result.error("UNAVAILABLE", "Battery technology is not available.", null);
        break;

      case "getBatteryTemperature":
        int temperature = intent.getIntExtra(BatteryManager.EXTRA_TEMPERATURE, 0);
        if (temperature > 0) result.success(((float) temperature) / 10f);
        else result.error("UNAVAILABLE", "Battery temperature is not available.", null);
        break;

      case "getBatteryVoltage":
        int voltage = intent.getIntExtra(BatteryManager.EXTRA_VOLTAGE, 0);
        if (voltage > 0) result.success(voltage);
        else result.error("UNAVAILABLE", "Battery voltage is not available.", null);
        break;

      case "getBatteryCurrentAverage":
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.LOLLIPOP) {
          result.success(
              batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CURRENT_AVERAGE));
        } else {
          result.error("UNAVAILABLE", "Battery current average is not available.", null);
        }
        break;

      case "getBatteryCurrentNow":
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.LOLLIPOP) {
          result.success(
              batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CURRENT_NOW));
        } else {
          result.error("UNAVAILABLE", "Battery current now is not available.", null);
        }
        break;

      case "getBatteryRemainingCapacity":
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.LOLLIPOP) {
          result.success(
              batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_ENERGY_COUNTER));
        } else {
          result.error("UNAVAILABLE", "Remaining battery capacity is not available.", null);
        }
        break;

      case "getBatteryChargeTimeRemaining":
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
          result.success(batteryManager.computeChargeTimeRemaining());
        } else {
          result.error("UNAVAILABLE", "Battery charge time remaining is not available.", null);
        }
        break;

      case "getBatteryScale":
        int scale = intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1);
        if (scale != -1) result.success(scale);
        else result.error("UNAVAILABLE", "Battery charge time remaining is not available.", null);
        break;

      default:
        result.notImplemented();
        break;
    }
  }

  @Override
  public void onListen(Object arguments, EventSink events) {
    chargingStateChangeReceiver = createChargingStateChangeReceiver(events);
    applicationContext.registerReceiver(
        chargingStateChangeReceiver, new IntentFilter(Intent.ACTION_BATTERY_CHANGED));

    int status = getBatteryProperty(BatteryManager.BATTERY_PROPERTY_STATUS);
    publishBatteryStatus(events, status);
  }

  @Override
  public void onCancel(Object arguments) {
    applicationContext.unregisterReceiver(chargingStateChangeReceiver);
    chargingStateChangeReceiver = null;
  }

  private int getBatteryLevel(Intent intent) {
    int batteryLevel = -1;
    if (VERSION.SDK_INT >= VERSION_CODES.LOLLIPOP) {
      batteryLevel = getBatteryProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY);
    } else {
      batteryLevel =
          (intent.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) * 100)
              / intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1);
    }

    return batteryLevel;
  }

  private String getBatteryHealth(Intent intent) {
    int status = intent.getIntExtra(BatteryManager.EXTRA_HEALTH, -1);
    String health = "";
    switch (status) {
      case BatteryManager.BATTERY_HEALTH_COLD:
        health = "BATTERY_HEALTH_COLD";
        break;
      case BatteryManager.BATTERY_HEALTH_DEAD:
        health = "BATTERY_HEALTH_DEAD";
        break;
      case BatteryManager.BATTERY_HEALTH_GOOD:
        health = "BATTERY_HEALTH_GOOD";
        break;
      case BatteryManager.BATTERY_HEALTH_OVER_VOLTAGE:
        health = "BATTERY_HEALTH_OVER_VOLTAGE";
        break;
      case BatteryManager.BATTERY_HEALTH_OVERHEAT:
        health = "BATTERY_HEALTH_OVERHEAT";
        break;
      case BatteryManager.BATTERY_HEALTH_UNSPECIFIED_FAILURE:
        health = "BATTERY_HEALTH_UNSPECIFIED_FAILURE";
        break;
      case BatteryManager.BATTERY_HEALTH_UNKNOWN:
        health = "BATTERY_HEALTH_UNKNOWN";
        break;
      default:
        break;
    }
    return health;
  }

  private String getBatteryPluggedType(Intent intent) {
    int status = intent.getIntExtra(BatteryManager.EXTRA_PLUGGED, 0);
    String plugged = "unknown";
    switch (status) {
      case BatteryManager.BATTERY_PLUGGED_WIRELESS:
        plugged = "BATTERY_PLUGGED_WIRELESS";
        break;

      case BatteryManager.BATTERY_PLUGGED_USB:
        plugged = "BATTERY_PLUGGED_USB";
        break;

      case BatteryManager.BATTERY_PLUGGED_AC:
        plugged = "BATTERY_PLUGGED_AC";
        break;

      default:
        plugged = "BATTERY_PLUGGED_NONE";
        break;
    }
    return plugged;
  }

  private Boolean isInPowerSaveMode() {
    String manufacturer = Build.MANUFACTURER.toLowerCase(Locale.getDefault());
    if (VERSION.SDK_INT >= VERSION_CODES.LOLLIPOP) {
      switch (manufacturer) {
        case "xiaomi":
          {
            return getPowerSaveModeForXiaomi();
          }
        case "huawei":
          {
            return getPowerSaveModeHuawei();
          }
        case "samsung":
          {
            return getPowerSaveModeSamsung();
          }
        default:
          PowerManager powerManager =
              (PowerManager) applicationContext.getSystemService(Context.POWER_SERVICE);
          return powerManager.isPowerSaveMode();
      }
    }
    return null;
  }

  private boolean getPowerSaveModeSamsung() {
    String mode = Settings.System.getString(applicationContext.getContentResolver(), "psm_switch");
    return (mode.equals(POWER_SAVE_MODE_SAMSUNG));
  }

  private Boolean getPowerSaveModeHuawei() {
    int mode =
        Settings.System.getInt(applicationContext.getContentResolver(), "SmartModeStatus", -1);
    if (mode != -1) {
      return (mode == POWER_SAVE_MODE_HUAWEI);
    }
    return null;
  }

  private Boolean getPowerSaveModeForXiaomi() {
    int mode =
        Settings.System.getInt(applicationContext.getContentResolver(), "POWER_SAVE_MODE_OPEN", -1);
    if (mode != -1) {
      return (mode == POWER_SAVE_MODE_XIAOMI);
    }
    return null;
  }

  private int getBatteryProperty(int property) {
    BatteryManager batteryManager =
        (BatteryManager) applicationContext.getSystemService(applicationContext.BATTERY_SERVICE);
    return batteryManager.getIntProperty(property);
  }

  private static void publishBatteryStatus(final EventSink events, int status) {
    switch (status) {
      case BatteryManager.BATTERY_STATUS_CHARGING:
        events.success("charging");
        break;
      case BatteryManager.BATTERY_STATUS_FULL:
        events.success("full");
        break;
      case BatteryManager.BATTERY_STATUS_DISCHARGING:
      case BatteryManager.BATTERY_STATUS_NOT_CHARGING:
        events.success("discharging");
        break;
      case BatteryManager.BATTERY_STATUS_UNKNOWN:
        events.success("unknown");
        break;
      default:
        events.error("UNAVAILABLE", "Charging status unavailable", null);
        break;
    }
  }

  private BroadcastReceiver createChargingStateChangeReceiver(final EventSink events) {
    return new BroadcastReceiver() {
      @Override
      public void onReceive(Context context, Intent intent) {
        int status = intent.getIntExtra(BatteryManager.EXTRA_STATUS, -1);
        publishBatteryStatus(events, status);
      }
    };
  }
}
