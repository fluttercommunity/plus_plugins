package dev.fluttercommunity.plus.device_info

import android.content.Context
import android.content.pm.PackageManager
import android.view.WindowManager
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel

/** DeviceInfoPlusPlugin  */
class DeviceInfoPlusPlugin : FlutterPlugin, ActivityAware {

    private lateinit var methodChannel: MethodChannel

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        setupMethodChannel(binding.binaryMessenger)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        methodChannel.setMethodCallHandler(null)
    }

    private fun setupMethodChannel(messenger: BinaryMessenger) {
        methodChannel = MethodChannel(messenger, "dev.fluttercommunity.plus/device_info")
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        configureMethodCallHandler(binding)
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        configureMethodCallHandler(binding)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        methodChannel.setMethodCallHandler(null)
    }

    override fun onDetachedFromActivity() {
        methodChannel.setMethodCallHandler(null)
    }

    private fun configureMethodCallHandler(binding: ActivityPluginBinding) {
        val context = binding.activity as Context
        val packageManager: PackageManager = context.packageManager
        // WindowManager must be obtained from Activity Context
        val windowManager: WindowManager =
            context.getSystemService(Context.WINDOW_SERVICE) as WindowManager
        val handler = MethodCallHandlerImpl(packageManager, windowManager)
        methodChannel.setMethodCallHandler(handler)
    }

}
