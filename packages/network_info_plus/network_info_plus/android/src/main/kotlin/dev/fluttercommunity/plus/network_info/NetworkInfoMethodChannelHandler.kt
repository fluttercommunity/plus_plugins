package dev.fluttercommunity.plus.network_info

import android.app.Activity
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler

/**
 * The handler receives [MethodCall]s from the UIThread, gets the related information from
 * a [NetworkInfo], and then send the result back to the UIThread through the [MethodChannel.Result].
 */
internal class NetworkInfoMethodChannelHandler(private val networkInfo: NetworkInfo) :
    MethodCallHandler {

    var activity: Activity? = null

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "wifiName" -> result.success(networkInfo.getWifiName())
            "wifiBSSID" -> result.success(networkInfo.getWifiBSSID())
            "wifiIPAddress" -> result.success(networkInfo.getWifiIPAddress())
            "wifiBroadcast" -> result.success(networkInfo.getBroadcastIP())
            "wifiSubmask" -> result.success(networkInfo.getWifiSubnetMask())
            "wifiGatewayAddress" -> result.success(networkInfo.getGatewayIPAddress())
            "wifiIPv6Address" -> result.success(networkInfo.getIpV6())
            "getLocationServiceAuthorization" -> networkInfo.getLocationServiceAuthorizationWithResult(
                activity, result
            )
            "requestLocationServiceAuthorization" -> networkInfo.requestLocationServiceAuthorization(
                activity, result
            )
            else -> result.notImplemented()
        }
    }
}
