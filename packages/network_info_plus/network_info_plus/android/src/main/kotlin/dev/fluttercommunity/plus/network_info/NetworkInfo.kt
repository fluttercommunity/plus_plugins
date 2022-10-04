package dev.fluttercommunity.plus.network_info

import android.Manifest
import android.app.Activity
import android.content.pm.PackageManager
import android.net.wifi.WifiInfo
import android.net.wifi.WifiManager
import android.os.Build
import android.util.Log
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry
import java.net.*

private const val permissionRequestCode = 100

/** Reports network info such as wifi name and address. */
internal class NetworkInfo(private val wifiManager: WifiManager?) :
    PluginRegistry.RequestPermissionsResultListener {

    private val wifiInfo: WifiInfo?
        get() = wifiManager?.connectionInfo

    private var ongoingResult: MethodChannel.Result? = null

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ): Boolean {
        if (requestCode == permissionRequestCode) {
            val cachedResult = ongoingResult ?: return true
            cachedResult.success(parseAuthStatus(grantResults).platformName)
            ongoingResult = null
        }
        return true
    }

    // Android returns "SSID"
    fun getWifiName(): String? {
        var ssid: String? = null
        if (wifiInfo != null) ssid = wifiInfo!!.ssid
        return ssid
    }

    fun getWifiBSSID(): String? {
        return if (wifiInfo != null) {
            wifiInfo!!.bssid
        } else {
            null
        }
    }

    fun getWifiIPAddress(): String? {
        var wifiInfo: WifiInfo? = null
        if (wifiManager != null) wifiInfo = wifiManager.connectionInfo
        var ip: String? = null
        var interfaceIp = 0
        if (wifiInfo != null) interfaceIp = wifiInfo.ipAddress
        if (interfaceIp != 0) ip = formatIPAddress(interfaceIp)
        return ip
    }

    fun getWifiSubnetMask(): String {
        val ip = getWifiIPAddress()
        var subnet = ""
        try {
            val inetAddress = InetAddress.getByName(ip)
            subnet = getIPv4Subnet(inetAddress)
        } catch (ignored: Exception) {
        }
        return subnet
    }

    fun getBroadcastIP(): String? {
        var broadcastIP: String? = null
        val currentWifiIpAddress = getWifiIPAddress()
        val inetAddress = InetAddress.getByName(currentWifiIpAddress)
        try {
            val networkInterface = NetworkInterface.getByInetAddress(inetAddress)
            networkInterface.interfaceAddresses.forEach { interfaceAddress ->
                if (!interfaceAddress.address.isLoopbackAddress) {
                    if (interfaceAddress.broadcast != null) {
                        broadcastIP = interfaceAddress.broadcast.hostAddress
                    }
                }
            }
        } catch (ignored: Exception) {

        }
        return broadcastIP
    }

    fun getIpV6(): String? {
        try {
            val ip = getWifiIPAddress()
            val ni = NetworkInterface.getByInetAddress(InetAddress.getByName(ip))
            for (interfaceAddress in ni.interfaceAddresses) {
                val address = interfaceAddress.address
                if (!address.isLoopbackAddress && address is Inet6Address) {
                    val ipaddress = address.getHostAddress()
                    if (ipaddress != null) {
                        return ipaddress.split("%").toTypedArray()[0]
                    }
                }
            }
        } catch (_: SocketException) {

        }
        return null
    }

    fun getGatewayIPAddress(): String {
        val dhcpInfo = wifiManager!!.dhcpInfo
        val gatewayIPInt = dhcpInfo.gateway
        return formatIPAddress(gatewayIPInt)
    }

    fun getLocationServiceAuthorizationWithResult(
        activity: Activity?,
        result: MethodChannel.Result
    ) {
        try {
            result.success(getLocationServiceAuthorization(activity).platformName)
        } catch (e: IllegalStateException) {
            result.error("NetworkInfo", e.message, null)
        }
    }

    fun requestLocationServiceAuthorization(
        activity: Activity?,
        result: MethodChannel.Result
    ) {
        if (activity == null) {
            result.error(
                "NetworkInfo",
                "Non-null activity is required to request permissions",
                null
            )
            return
        } else if (ongoingResult != null) {
            result.error(
                "NetworkInfo",
                "Permission request is already in progress",
                null
            )
            return
        }

        lateinit var status: LocationAuthorizationStatus
        try {
            status = getLocationServiceAuthorization(activity)
        } catch (e: IllegalStateException) {
            result.error("NetworkInfo", e.message, null)
            return
        }

        if (status != LocationAuthorizationStatus.AUTHORIZED_ALWAYS) {
            ongoingResult = result
            ActivityCompat.requestPermissions(
                activity,
                arrayOf(getPermissionName()),
                permissionRequestCode
            )
        } else {
            ongoingResult = null
            result.success(LocationAuthorizationStatus.AUTHORIZED_ALWAYS.platformName)
        }

    }

    private fun formatIPAddress(intIP: Int): String =
        String.format(
            "%d.%d.%d.%d",
            intIP and 0xFF,
            intIP shr 8 and 0xFF,
            intIP shr 16 and 0xFF,
            intIP shr 24 and 0xFF
        )

    private fun getIPv4Subnet(inetAddress: InetAddress): String {
        try {
            val ni = NetworkInterface.getByInetAddress(inetAddress)
            val intAddresses = ni.interfaceAddresses
            for (ia in intAddresses) {
                if (!ia.address.isLoopbackAddress && ia.address is Inet4Address) {
                    val networkPrefix =
                        getIPv4SubnetFromNetPrefixLength(ia.networkPrefixLength.toInt())
                    if (networkPrefix != null) {
                        return networkPrefix.hostAddress!!
                    }
                }
            }
        } catch (ignored: Exception) {
        }
        return ""
    }

    private fun getIPv4SubnetFromNetPrefixLength(netPrefixLength: Int): InetAddress? {
        try {
            var shift = 1 shl 31
            for (i in netPrefixLength - 1 downTo 1) {
                shift = shift shr 1
            }
            val subnet = ((shift shr 24 and 255)
                .toString() + "."
                + (shift shr 16 and 255)
                + "."
                + (shift shr 8 and 255)
                + "."
                + (shift and 255))
            return InetAddress.getByName(subnet)
        } catch (ignored: Exception) {
        }
        return null
    }

    private fun getLocationServiceAuthorization(activity: Activity?): LocationAuthorizationStatus {
        if (activity == null) {
            throw IllegalStateException("Non-null activity is required to request permissions")
        }

        val permissionName = getPermissionName()

        // This call returns true when the user has denied the permission, but will return false
        // if the user has selected "Never ask again" after denying the permission.
        val isPermissionDeniedByUser =
            ActivityCompat.shouldShowRequestPermissionRationale(activity, permissionName)
        val permissionValue = ContextCompat.checkSelfPermission(activity, permissionName)

        return if (permissionValue == PackageManager.PERMISSION_GRANTED) {
            LocationAuthorizationStatus.AUTHORIZED_ALWAYS
        } else if (permissionValue == PackageManager.PERMISSION_DENIED && isPermissionDeniedByUser) {
            LocationAuthorizationStatus.DENIED
        } else {
            LocationAuthorizationStatus.NOT_DETERMINED
        }
    }

    private fun getPermissionName(): String {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            Manifest.permission.NEARBY_WIFI_DEVICES
        } else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            Manifest.permission.ACCESS_FINE_LOCATION
        } else {
            Manifest.permission.ACCESS_COARSE_LOCATION
        }
    }

    private fun parseAuthStatus(grantResults: IntArray): LocationAuthorizationStatus {
        return when (grantResults.firstOrNull()) {
            PackageManager.PERMISSION_GRANTED -> LocationAuthorizationStatus.AUTHORIZED_ALWAYS
            PackageManager.PERMISSION_DENIED -> LocationAuthorizationStatus.DENIED
            else -> LocationAuthorizationStatus.NOT_DETERMINED
        }
    }
}

internal enum class LocationAuthorizationStatus(val platformName: String) {
    NOT_DETERMINED("notDetermined"),
    DENIED("denied"),
    AUTHORIZED_ALWAYS("authorizedAlways"),
}
