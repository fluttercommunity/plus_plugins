package dev.fluttercommunity.plus.network_info

import android.net.ConnectivityManager
import android.net.wifi.WifiInfo
import android.net.wifi.WifiManager
import android.os.Build
import java.net.*

/** Reports network info such as wifi name and address. */
internal class NetworkInfo(private val wifiManager: WifiManager?,
                           private val connectivityManager: ConnectivityManager? = null
) {

    private val wifiInfo: WifiInfo?
        get() =
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                val currentNetwork = connectivityManager?.activeNetwork
                connectivityManager?.getNetworkCapabilities(currentNetwork)?.transportInfo as WifiInfo?
            } else {
                @Suppress("DEPRECATION")
                wifiManager?.connectionInfo
            }

    // Android returns "SSID"
    fun getWifiName(): String? = wifiInfo?.ssid

    fun getWifiBSSID(): String? = wifiInfo?.bssid

    fun getWifiIPAddress(): String? {
        var ipAddress: String? = null

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            val linkAddresses = connectivityManager?.getLinkProperties(connectivityManager.activeNetwork)?.linkAddresses

            val ipV4Address = linkAddresses?.firstOrNull { linkAddress ->
                linkAddress.address.hostAddress?.contains('.')
                    ?: false
            }?.address?.hostAddress

            ipAddress = ipV4Address
        } else {
            @Suppress("DEPRECATION")
            val interfaceIp = wifiInfo!!.ipAddress
            if (interfaceIp != 0) ipAddress = formatIPAddress(interfaceIp)
        }
        return ipAddress
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
        } catch (socketException: SocketException) {

        }
        return null
    }

    fun getGatewayIPAddress(): String? {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            val linkAddresses = connectivityManager?.getLinkProperties(connectivityManager.activeNetwork)
            val dhcpServer = linkAddresses?.dhcpServerAddress?.hostAddress

            dhcpServer
        } else {
            @Suppress("DEPRECATION")
            val dhcpInfo = wifiManager?.dhcpInfo
            val gatewayIPInt = dhcpInfo?.gateway

            gatewayIPInt?.let { formatIPAddress(it) }
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
}
