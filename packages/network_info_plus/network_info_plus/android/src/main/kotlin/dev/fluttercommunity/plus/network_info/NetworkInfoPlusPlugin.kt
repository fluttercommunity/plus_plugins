package dev.fluttercommunity.plus.network_info

import android.app.Activity
import android.content.Context
import android.net.wifi.WifiManager
import android.util.Log
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel

/** NetworkInfoPlusPlugin  */
class NetworkInfoPlusPlugin : FlutterPlugin, ActivityAware {
    private lateinit var methodChannel: MethodChannel
    private lateinit var methodChannelHandler: NetworkInfoMethodChannelHandler
    private lateinit var networkInfo: NetworkInfo

    override fun onAttachedToEngine(binding: FlutterPluginBinding) {
        setupChannels(binding.binaryMessenger, binding.applicationContext)
    }

    override fun onDetachedFromEngine(binding: FlutterPluginBinding) {
        methodChannel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        setListenerActivity(binding.activity)
        binding.addRequestPermissionsResultListener(networkInfo)
    }

    override fun onDetachedFromActivity() {
        setListenerActivity(null)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        onDetachedFromActivity()
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        onAttachedToActivity(binding)
    }

    private fun setupChannels(messenger: BinaryMessenger, context: Context) {
        methodChannel = MethodChannel(messenger, CHANNEL)
        val wifiManager =
            context.applicationContext.getSystemService(Context.WIFI_SERVICE) as WifiManager
        networkInfo = NetworkInfo(wifiManager)
        methodChannelHandler = NetworkInfoMethodChannelHandler(networkInfo)
        methodChannel.setMethodCallHandler(methodChannelHandler)
    }

    private fun setListenerActivity(activity: Activity?) {
        if (::methodChannelHandler.isInitialized) {
            methodChannelHandler.activity = activity
        }
    }

    companion object {
        private const val CHANNEL = "dev.fluttercommunity.plus/network_info"
    }
}
