package dev.fluttercommunity.plus.network_info

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler

/**
 * The handler receives [MethodCall]s from the UIThread, gets the related information from
 * a [NetworkInfo], and then send the result back to the UIThread through the [MethodChannel.Result].
 */
internal class NetworkInfoMethodChannelHandler(private val networkInfo: NetworkInfo) :
    MethodCallHandler {

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "wifiName" -> result.success(networkInfo.getWifiName())
            "wifiBSSID" -> result.success(networkInfo.getWifiBSSID())
            "wifiIPAddress" -> result.success(networkInfo.getWifiIPAddress())
            "wifiBroadcast" -> result.success(networkInfo.getBroadcastIP())
            "wifiSubmask" -> result.success(networkInfo.getWifiSubnetMask())
            "wifiGatewayAddress" -> result.success(networkInfo.getGatewayIPAddress())
            "wifiIPv6Address" -> result.success(networkInfo.getIpV6())
            else -> result.notImplemented()
        }
    }
}
