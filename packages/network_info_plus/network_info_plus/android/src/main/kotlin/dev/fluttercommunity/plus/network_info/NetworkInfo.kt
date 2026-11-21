package dev.fluttercommunity.plus.network_info

import android.net.ConnectivityManager
import android.net.wifi.WifiInfo
import android.net.wifi.WifiManager
import android.os.Build
import java.net.*

/** Reports network info such as wifi name and address. */
internal class NetworkInfo(
    private val wifiManager: WifiManager,
    private val connectivityManager: ConnectivityManager? = null
) {

    // Using deprecated `connectionInfo` call here to be able to get info on demand
    @Suppress("DEPRECATION")
    private val wifiInfo: WifiInfo
        get() = wifiManager.connectionInfo

    // Android returns "SSID"
    fun getWifiName(): String? = wifiInfo.ssid

    fun getWifiBSSID(): String? = wifiInfo.bssid

    fun getWifiIPAddress(): String? {
        var ipAddress: String? = null

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            val linkAddresses =
                connectivityManager?.getLinkProperties(connectivityManager.activeNetwork)?.linkAddresses

            val ipV4Address = linkAddresses?.firstOrNull { linkAddress ->
                linkAddress.address.hostAddress?.contains('.')
                    ?: false
            }?.address?.hostAddress

            ipAddress = ipV4Address
        } else {
            @Suppress("DEPRECATION")
            val interfaceIp = wifiInfo.ipAddress
            if (interfaceIp != 0) ipAddress = formatIPAddress(interfaceIp)
        }
        return ipAddress
    }

    fun getWifiSubnetMask(): String {
        val ip = getWifiIPAddress()
        val inetAddress = InetAddress.getByName(ip)
        val subnet = getIPv4Subnet(inetAddress)
        return subnet
    }

    fun getBroadcastIP(): String? {
        val currentWifiIpAddress = getWifiIPAddress()
        val inetAddress = InetAddress.getByName(currentWifiIpAddress)
        val networkInterface = NetworkInterface.getByInetAddress(inetAddress)
        networkInterface.interfaceAddresses.forEach { interfaceAddress ->
            if (!interfaceAddress.address.isLoopbackAddress) {
                if (interfaceAddress.broadcast != null) {
                    return interfaceAddress.broadcast.hostAddress
                }
            }
        }
        return null
    }

    fun getIpV6(): String? {
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
        return null
    }

    fun getGatewayIPAddress(): String? {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            val gateways = connectivityManager
                ?.getLinkProperties(connectivityManager.activeNetwork)
                ?.routes
                ?.filter { it.isDefaultRoute }
                ?.mapNotNull { it.gateway }

            // The DHCP server is only the gateway by coincidence, so read the
            // next hop from the route table. Prefer the IPv4 hop, since a
            // dual-stack connection also carries an IPv6 default route.
            (gateways?.firstOrNull { it is Inet4Address } ?: gateways?.firstOrNull())
                ?.hostAddress
        } else {
            @Suppress("DEPRECATION")
            val dhcpInfo = wifiManager.dhcpInfo
            val gatewayIPInt = dhcpInfo?.gateway

            gatewayIPInt?.let { formatIPAddress(it) }
        }
    }

    fun getDhcpServerIPAddress(): String? {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            connectivityManager
                ?.getLinkProperties(connectivityManager.activeNetwork)
                ?.dhcpServerAddress
                ?.hostAddress
        } else {
            @Suppress("DEPRECATION")
            val serverAddressInt = wifiManager.dhcpInfo?.serverAddress

            serverAddressInt?.takeIf { it != 0 }?.let { formatIPAddress(it) }
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
        return ""
    }

    private fun getIPv4SubnetFromNetPrefixLength(netPrefixLength: Int): InetAddress? {
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
    }
}
