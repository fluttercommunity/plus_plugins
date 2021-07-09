// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package dev.fluttercommunity.plus.network_info;

import android.net.DhcpInfo;
import android.net.wifi.WifiInfo;
import android.net.wifi.WifiManager;

import java.net.Inet4Address;
import java.net.Inet6Address;
import java.net.InetAddress;
import java.net.InterfaceAddress;
import java.net.NetworkInterface;
import java.net.UnknownHostException;
import java.util.Enumeration;
import java.util.List;

/**
 * Reports network info such as wifi name and address.
 */
class NetworkInfo {
  private WifiManager wifiManager;

  NetworkInfo(WifiManager wifiManager) {
    this.wifiManager = wifiManager;
  }

  String getWifiName() {
    WifiInfo wifiInfo = getWifiInfo();
    String ssid = null;
    if (wifiInfo != null) ssid = wifiInfo.getSSID();
    if (ssid != null) ssid = ssid.replaceAll("\"", ""); // Android returns "SSID"
    return ssid;
  }

  String getWifiBSSID() {
    WifiInfo wifiInfo = getWifiInfo();
    String bssid = null;
    if (wifiInfo != null) {
      bssid = wifiInfo.getBSSID();
    }
    return bssid;
  }

  String getWifiIPAddress() {
    WifiInfo wifiInfo = null;
    if (wifiManager != null) wifiInfo = wifiManager.getConnectionInfo();
    String ip = null;
    int i_ip = 0;
    if (wifiInfo != null) i_ip = wifiInfo.getIpAddress();

    if (i_ip != 0)
      ip =
        String.format(
          "%d.%d.%d.%d",
          (i_ip & 0xff), (i_ip >> 8 & 0xff), (i_ip >> 16 & 0xff), (i_ip >> 24 & 0xff));

    return ip;
  }

  String getWifiSubnetMask() {
    String ip = this.getWifiIPAddress();
    String subnet = "";
    try {
      InetAddress inetAddress = InetAddress.getByName(ip);
      subnet = getIPv4Subnet(inetAddress);
    } catch (Exception e) {
    }
    return subnet;
  }

  String getBroadcast() {
    String broadcastIP = null;
    String ip = this.getWifiIPAddress();
    try {
      NetworkInterface ni = NetworkInterface.getByInetAddress(InetAddress.getByName(ip));
      for (InterfaceAddress address : ni.getInterfaceAddresses()) {
        if (!address.getAddress().isLoopbackAddress()) {
          InetAddress broadCast = address.getBroadcast();
          if (broadCast != null) {
            broadcastIP = broadCast.toString();
          }
        }
      }
    } catch (Exception e) {
    }
    return broadcastIP;
  }

  public String getIpV6() {
    try {
      String ip = this.getWifiIPAddress();
      NetworkInterface ni = NetworkInterface.getByInetAddress(InetAddress.getByName(ip));
      for (InterfaceAddress interfaceAddress : ni.getInterfaceAddresses()) {
        InetAddress address = interfaceAddress.getAddress();
        if (!address.isLoopbackAddress() && address instanceof Inet6Address) {
          String ipaddress = address.getHostAddress().split("%")[0];
          return ipaddress;
        }
      }
    } catch (Exception ex) {
    }
    return null;
  }

  String getGatewayIpAdress() {
    DhcpInfo dhcpInfo = this.wifiManager.getDhcpInfo();
    int gatewayIPInt = dhcpInfo.gateway;
    String gatewayIP = String.format(
      "%d.%d.%d.%d",
      ((gatewayIPInt) & 0xFF),
      ((gatewayIPInt >> 8) & 0xFF),
      ((gatewayIPInt >> 16) & 0xFF),
      ((gatewayIPInt >> 24) & 0xFF)
    );
    return gatewayIP;
  }


  private WifiInfo getWifiInfo() {
    return wifiManager == null ? null : wifiManager.getConnectionInfo();
  }

  private String getIPv4Subnet(InetAddress inetAddress) {
    try {
      NetworkInterface ni = NetworkInterface.getByInetAddress(inetAddress);
      List<InterfaceAddress> intAddrs = ni.getInterfaceAddresses();
      for (InterfaceAddress ia : intAddrs) {
        if (!ia.getAddress().isLoopbackAddress() && ia.getAddress() instanceof Inet4Address) {
          return getIPv4SubnetFromNetPrefixLength(ia.getNetworkPrefixLength()).getHostAddress();
        }
      }
    } catch (Exception e) {
    }
    return "";
  }


  private InetAddress getIPv4SubnetFromNetPrefixLength(int netPrefixLength) {
    try {
      int shift = (1 << 31);
      for (int i = netPrefixLength - 1; i > 0; i--) {
        shift = (shift >> 1);
      }
      String subnet = ((shift >> 24) & 255) + "." + ((shift >> 16) & 255) + "." + ((shift >> 8) & 255) + "." + (shift & 255);
      return InetAddress.getByName(subnet);
    } catch (Exception e) {
    }
    return null;
  }

}
