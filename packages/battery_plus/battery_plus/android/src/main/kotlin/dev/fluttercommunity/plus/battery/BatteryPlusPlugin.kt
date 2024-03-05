package dev.fluttercommunity.plus.battery

import android.annotation.SuppressLint
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.EventChannel
import io.flutter.embedding.engine.plugins.FlutterPlugin
import android.content.Context
import android.content.BroadcastReceiver
import io.flutter.plugin.common.MethodChannel
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.plugin.common.MethodCall
import android.os.Build.VERSION_CODES
import io.flutter.plugin.common.EventChannel.EventSink
import android.content.IntentFilter
import android.content.Intent
import android.os.BatteryManager
import android.os.Build.VERSION
import android.content.ContextWrapper
import android.os.Build
import java.util.Locale
import android.os.PowerManager
import android.provider.Settings
import androidx.annotation.RequiresApi
import androidx.core.content.ContextCompat
import androidx.core.content.ContextCompat.RECEIVER_NOT_EXPORTED


/** BatteryPlusPlugin  */
class BatteryPlusPlugin : MethodCallHandler, EventChannel.StreamHandler, FlutterPlugin {
    private var applicationContext: Context? = null
    private var chargingStateChangeReceiver: BroadcastReceiver? = null
    private var methodChannel: MethodChannel? = null
    private var eventChannel: EventChannel? = null

    override fun onAttachedToEngine(binding: FlutterPluginBinding) {
        this.applicationContext = binding.applicationContext
        methodChannel = MethodChannel(binding.binaryMessenger, "dev.fluttercommunity.plus/battery")
        eventChannel = EventChannel(binding.binaryMessenger, "dev.fluttercommunity.plus/charging")
        eventChannel!!.setStreamHandler(this)
        methodChannel!!.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(binding: FlutterPluginBinding) {
        applicationContext = null
        methodChannel!!.setMethodCallHandler(null)
        methodChannel = null
        eventChannel!!.setStreamHandler(null)
        eventChannel = null
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "getBatteryLevel" -> {
                val currentBatteryLevel = getBatteryLevel()
                if (currentBatteryLevel != -1) {
                    result.success(currentBatteryLevel)
                } else {
                    result.error("UNAVAILABLE", "Battery level not available.", null)
                }
            }

            "getBatteryState" -> {
                val currentBatteryStatus = getBatteryStatus()
                if (currentBatteryStatus != null) {
                    result.success(currentBatteryStatus)
                } else {
                    result.error("UNAVAILABLE", "Charging status not available.", null)
                }
            }

            "isInBatterySaveMode" -> {
                val isInPowerSaveMode = isInPowerSaveMode()
                if (isInPowerSaveMode != null) {
                    result.success(isInPowerSaveMode)
                } else {
                    result.error("UNAVAILABLE", "Battery save mode not available.", null)
                }
            }

            else -> result.notImplemented()
        }
    }

    @SuppressLint("WrongConstant") // Error in ContextCompat for RECEIVER_NOT_EXPORTED
    override fun onListen(arguments: Any?, events: EventSink) {
        chargingStateChangeReceiver = createChargingStateChangeReceiver(events)
        applicationContext?.let {
            ContextCompat.registerReceiver(
                it, chargingStateChangeReceiver,
                IntentFilter(Intent.ACTION_BATTERY_CHANGED), RECEIVER_NOT_EXPORTED
            )
        }
        val status = getBatteryStatus()
        publishBatteryStatus(events, status)
    }

    override fun onCancel(arguments: Any?) {
        applicationContext!!.unregisterReceiver(chargingStateChangeReceiver)
        chargingStateChangeReceiver = null
    }

    private fun getBatteryStatus(): String? {
        val status: Int = if (VERSION.SDK_INT >= VERSION_CODES.O) {
            getBatteryProperty(BatteryManager.BATTERY_PROPERTY_STATUS)
        } else {
            val intent = ContextWrapper(applicationContext).registerReceiver(null, IntentFilter(Intent.ACTION_BATTERY_CHANGED))
            intent?.getIntExtra(BatteryManager.EXTRA_STATUS, -1) ?: -1
        }
        return convertBatteryStatus(status)
    }

    private fun getBatteryLevel(): Int {
        return if (VERSION.SDK_INT >= VERSION_CODES.LOLLIPOP) {
            getBatteryProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
        } else {
            val intent = ContextWrapper(applicationContext).registerReceiver(null, IntentFilter(Intent.ACTION_BATTERY_CHANGED))
            val level = intent!!.getIntExtra(BatteryManager.EXTRA_LEVEL, -1)
            val scale = intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1)
            (level * 100 / scale)
        }
    }

    private fun isInPowerSaveMode(): Boolean? {
        val deviceManufacturer = Build.MANUFACTURER.lowercase(Locale.getDefault())

        return if (VERSION.SDK_INT >= VERSION_CODES.LOLLIPOP) {
            when (deviceManufacturer) {
                "xiaomi" -> isXiaomiPowerSaveModeActive()
                "huawei" -> isHuaweiPowerSaveModeActive()
                "samsung" -> isSamsungPowerSaveModeActive()
                else -> checkPowerServiceSaveMode()
            }
        } else {
            null
        }
    }

    private fun isSamsungPowerSaveModeActive(): Boolean {
        val mode = Settings.System.getString(applicationContext!!.contentResolver, POWER_SAVE_MODE_SAMSUNG_NAME)
        return if (mode == null && VERSION.SDK_INT >= VERSION_CODES.LOLLIPOP) {
            checkPowerServiceSaveMode()
        } else {
            mode == POWER_SAVE_MODE_SAMSUNG_VALUE
        }
    }

    @RequiresApi(VERSION_CODES.LOLLIPOP)
    private fun isHuaweiPowerSaveModeActive(): Boolean {
        val mode = Settings.System.getInt(applicationContext!!.contentResolver, POWER_SAVE_MODE_HUAWEI_NAME, -1)
        return if (mode != -1) {
            mode == POWER_SAVE_MODE_HUAWEI_VALUE
        } else {
            // On Devices like the P30 lite, we always get an -1 result code.
            // Stackoverflow issue: https://stackoverflow.com/a/70500770
            checkPowerServiceSaveMode()
        }
    }

    private fun isXiaomiPowerSaveModeActive(): Boolean? {
        val mode = Settings.System.getInt(applicationContext!!.contentResolver, POWER_SAVE_MODE_XIAOMI_NAME, -1)
        return if (mode != -1) {
            mode == POWER_SAVE_MODE_XIAOMI_VALUE
        } else {
            null
        }
    }

    @RequiresApi(api = VERSION_CODES.LOLLIPOP)
    private fun checkPowerServiceSaveMode(): Boolean {
        val powerManager =
            applicationContext!!.getSystemService(Context.POWER_SERVICE) as PowerManager
        return powerManager.isPowerSaveMode
    }

    @RequiresApi(api = VERSION_CODES.LOLLIPOP)
    private fun getBatteryProperty(property: Int): Int {
        val batteryManager = applicationContext!!.getSystemService(Context.BATTERY_SERVICE) as BatteryManager
        return batteryManager.getIntProperty(property)
    }

    private fun createChargingStateChangeReceiver(events: EventSink): BroadcastReceiver {
        return object : BroadcastReceiver() {
            override fun onReceive(context: Context, intent: Intent) {
                val status = intent.getIntExtra(BatteryManager.EXTRA_STATUS, -1)
                publishBatteryStatus(events, convertBatteryStatus(status))
            }
        }
    }

    private fun convertBatteryStatus(status: Int): String? {
        return when (status) {
            BatteryManager.BATTERY_STATUS_CHARGING -> "charging"
            BatteryManager.BATTERY_STATUS_FULL -> "full"
            BatteryManager.BATTERY_STATUS_DISCHARGING -> "discharging"
            BatteryManager.BATTERY_STATUS_NOT_CHARGING -> "connected_not_charging"
            BatteryManager.BATTERY_STATUS_UNKNOWN -> "unknown"
            else -> null
        }
    }

    private fun publishBatteryStatus(events: EventSink, status: String?) {
        if (status != null) {
            events.success(status)
        } else {
            events.error("UNAVAILABLE", "Charging status unavailable", null)
        }
    }

    companion object {
        private const val POWER_SAVE_MODE_SAMSUNG_NAME = "psm_switch"
        private const val POWER_SAVE_MODE_SAMSUNG_VALUE = "1"

        private const val POWER_SAVE_MODE_XIAOMI_NAME = "POWER_SAVE_MODE_OPEN"
        private const val POWER_SAVE_MODE_XIAOMI_VALUE = 1

        private const val POWER_SAVE_MODE_HUAWEI_NAME = "SmartModeStatus"
        private const val POWER_SAVE_MODE_HUAWEI_VALUE = 4
    }
}
