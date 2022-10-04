package dev.fluttercommunity.plus.network_info

import android.content.Context
import android.net.ConnectivityManager
import android.net.wifi.WifiManager
import android.os.Build
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel

/** NetworkInfoPlusPlugin  */
class NetworkInfoPlusPlugin : FlutterPlugin {

    private lateinit var methodChannel: MethodChannel

    override fun onAttachedToEngine(binding: FlutterPluginBinding) {
        setupChannels(binding.binaryMessenger, binding.applicationContext)
    }

    override fun onDetachedFromEngine(binding: FlutterPluginBinding) {
        methodChannel.setMethodCallHandler(null)
    }

    private fun setupChannels(messenger: BinaryMessenger, context: Context) {
        methodChannel = MethodChannel(messenger, CHANNEL)
        val wifiManager =
            context.applicationContext.getSystemService(Context.WIFI_SERVICE) as WifiManager

        var connectivityManager: ConnectivityManager? = null
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            connectivityManager = context.applicationContext.getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
        }

        val networkInfo = NetworkInfo(wifiManager, connectivityManager)
        val methodChannelHandler = NetworkInfoMethodChannelHandler(networkInfo)
        methodChannel.setMethodCallHandler(methodChannelHandler)
    }

    companion object {
        private const val CHANNEL = "dev.fluttercommunity.plus/network_info"
    }
}
