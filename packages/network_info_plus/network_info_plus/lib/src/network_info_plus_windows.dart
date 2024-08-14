/// The Windows implementation of `network_info_plus`.
library network_info_plus_windows;

import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:network_info_plus/src/windows_structs.dart';
import 'package:win32/win32.dart';
import 'package:network_info_plus_platform_interface/network_info_plus_platform_interface.dart';
import 'package:win32/winsock2.dart';

typedef WlanQuery = String? Function(
  Pointer<GUID> pGuid,
  Pointer<WLAN_CONNECTION_ATTRIBUTES> pAttributes,
);

class NetworkInfoPlusWindowsPlugin extends NetworkInfoPlatform {
  int clientHandle = NULL;

  static void registerWith() {
    NetworkInfoPlatform.instance = NetworkInfoPlusWindowsPlugin();
  }

  void openHandle() {
    if (clientHandle != NULL) return;

    // ignore: constant_identifier_names
    const WLAN_API_VERSION_2_0 = 0x00000002;
    final phClientHandle = calloc<HANDLE>();
    final pdwNegotiatedVersion = calloc<DWORD>();

    try {
      final hr = WlanOpenHandle(
        WLAN_API_VERSION_2_0,
        nullptr,
        pdwNegotiatedVersion,
        phClientHandle,
      );
      if (hr == WIN32_ERROR.ERROR_SERVICE_NOT_ACTIVE) return;
      clientHandle = phClientHandle.value;
    } finally {
      free(pdwNegotiatedVersion);
      free(phClientHandle);
    }
  }

  void closeHandle() {
    if (clientHandle != NULL) {
      WlanCloseHandle(clientHandle, nullptr);

      clientHandle = NULL;
    }
  }

  String? query(WlanQuery query) {
    openHandle();
    final ppInterfaceList = calloc<Pointer<WLAN_INTERFACE_INFO_LIST>>();

    try {
      var hr = WlanEnumInterfaces(clientHandle, nullptr, ppInterfaceList);
      if (hr != WIN32_ERROR.ERROR_SUCCESS) {
        return null; // no wifi interface available
      }

      for (var i = 0; i < ppInterfaceList.value.ref.dwNumberOfItems; i++) {
        final pInterfaceGuid = calloc<GUID>()
          ..ref.setGUID(ppInterfaceList.value.ref.InterfaceInfo[i].InterfaceGuid
              .toString());

        const opCode = 7; // wlan_intf_opcode_current_connection
        final pdwDataSize = calloc<DWORD>();
        final ppAttributes = calloc<Pointer<WLAN_CONNECTION_ATTRIBUTES>>();

        try {
          hr = WlanQueryInterface(
            clientHandle,
            pInterfaceGuid,
            opCode,
            nullptr,
            pdwDataSize,
            ppAttributes.cast(),
            nullptr,
          );
          if (hr != WIN32_ERROR.ERROR_SUCCESS) break;
          if (ppAttributes.value.ref.isState != 0) {
            return query(pInterfaceGuid, ppAttributes.value);
          }
        } finally {
          free(pInterfaceGuid);
          free(pdwDataSize);
          if (ppAttributes.value != nullptr) {
            WlanFreeMemory(ppAttributes.value);
          }
          free(ppAttributes);
        }
      }
      return null;
    } finally {
      WlanFreeMemory(ppInterfaceList);
      closeHandle();
    }
  }

  String formatBssid(List<int> bssid) =>
      bssid.map((e) => e.toRadixString(16).padLeft(2, '0')).join(':');

  String formatIPAddress(Pointer<SOCKADDR> addr) {
    final buffer = calloc<BYTE>(64).cast<Utf8>();
    try {
      if (addr.ref.sa_family == ADDRESS_FAMILY.AF_INET) {
        final sinAddr = addr.cast<SOCKADDR_IN>().ref.sin_addr;
        final sinAddrPtr = calloc<Int32>();
        sinAddrPtr.value = sinAddr;
        inet_ntop(ADDRESS_FAMILY.AF_INET, sinAddrPtr, buffer, 64);
        free(sinAddrPtr);
      } else if (addr.ref.sa_family == ADDRESS_FAMILY.AF_INET6) {
        final sinAddr = addr.cast<SOCKADDR_IN6>().ref.sin6_addr;
        final sinAddrPtr = calloc<Uint8>(16);
        for (var i = 0; i < 16; i++) {
          sinAddrPtr[i] = sinAddr[i];
        }
        inet_ntop(ADDRESS_FAMILY.AF_INET6, sinAddrPtr, buffer, 64);
        free(sinAddrPtr);
      }
      return buffer.cast<Utf8>().toDartString();
    } finally {
      free(buffer);
    }
  }

  Pointer<IP_ADAPTER_ADDRESSES_LH>? getAdapterAddress(Pointer<GUID> pGuid,
      Pointer<IP_ADAPTER_ADDRESSES_LH> pIpAdapterAddresses) {
    final ifLuid = calloc<NET_LUID_LH>();
    try {
      if (ConvertInterfaceGuidToLuid(pGuid, ifLuid) != NO_ERROR) {
        return null;
      }

      var pCurrent = pIpAdapterAddresses;
      while (pCurrent.address != 0) {
        if (pCurrent.ref.Luid.Value == ifLuid.ref.Value) {
          return pCurrent;
        }
        pCurrent = pCurrent.ref.Next;
      }
      return null;
    } finally {
      free(ifLuid);
    }
  }

  @override
  Future<String?> getWifiName() {
    return Future<String?>.value(query((pGuid, pAttributes) {
      final DOT11_SSID ssid =
          pAttributes.ref.wlanAssociationAttributes.dot11Ssid;
      final charCodes = <int>[];
      for (var i = 0; i < ssid.uSSIDLength; i++) {
        if (ssid.ucSSID[i] == 0x00) break;
        charCodes.add(ssid.ucSSID[i]);
      }
      return String.fromCharCodes(charCodes);
    }));
  }

  /// Obtains the wifi BSSID of the connected network.
  @override
  Future<String?> getWifiBSSID() {
    return Future<String?>.value(query((pGuid, pAttributes) {
      return formatBssid([
        pAttributes.ref.wlanAssociationAttributes.dot11Bssid[0],
        pAttributes.ref.wlanAssociationAttributes.dot11Bssid[1],
        pAttributes.ref.wlanAssociationAttributes.dot11Bssid[2],
        pAttributes.ref.wlanAssociationAttributes.dot11Bssid[3],
        pAttributes.ref.wlanAssociationAttributes.dot11Bssid[4],
        pAttributes.ref.wlanAssociationAttributes.dot11Bssid[5],
      ]);
    }));
  }

  Future<String?> getIPAddr(int family) {
    return Future<String?>.value(query((pGuid, pAttributes) {
      final ulSize = calloc<ULONG>();
      Pointer<IP_ADAPTER_ADDRESSES_LH> pIpAdapterAddress = nullptr;
      try {
        GetAdaptersAddresses(family, 0, nullptr, nullptr, ulSize);
        pIpAdapterAddress = HeapAlloc(GetProcessHeap(), 0, ulSize.value).cast();
        GetAdaptersAddresses(family, 0, nullptr, pIpAdapterAddress, ulSize);
        final pAddr = getAdapterAddress(pGuid, pIpAdapterAddress);
        if (pAddr == null) return null;
        if (pAddr.ref.FirstUnicastAddress == nullptr) return null;
        return formatIPAddress(
            pAddr.ref.FirstUnicastAddress.ref.Address.lpSockaddr);
      } finally {
        free(ulSize);
        if (pIpAdapterAddress != nullptr) free(pIpAdapterAddress);
      }
    }));
  }

  /// Obtains the IP v4 address of the connected wifi network
  @override
  Future<String?> getWifiIP() {
    return getIPAddr(ADDRESS_FAMILY.AF_INET);
  }

  /// Obtains the IP v6 address of the connected wifi network
  @override
  Future<String?> getWifiIPv6() {
    return getIPAddr(ADDRESS_FAMILY.AF_INET6);
  }

  /// Obtains the subnet mask of the connected wifi network
  @override
  Future<String?> getWifiSubmask() {
    return Future<String?>.value(query((pGuid, pAttributes) {
      final ulSize = calloc<ULONG>();
      Pointer<IP_ADAPTER_ADDRESSES_LH> pIpAdapterAddress = nullptr;
      try {
        GetAdaptersAddresses(
          ADDRESS_FAMILY.AF_INET,
          0,
          nullptr,
          nullptr,
          ulSize,
        );
        pIpAdapterAddress = HeapAlloc(GetProcessHeap(), 0, ulSize.value).cast();
        GetAdaptersAddresses(
          ADDRESS_FAMILY.AF_INET,
          0,
          nullptr,
          pIpAdapterAddress,
          ulSize,
        );
        final pAddr = getAdapterAddress(pGuid, pIpAdapterAddress);
        if (pAddr == null) return null;
        return extractSubnet(pAddr);
      } finally {
        free(ulSize);
        if (pIpAdapterAddress != nullptr) free(pIpAdapterAddress);
      }
    }));
  }

  String extractSubnet(Pointer<IP_ADAPTER_ADDRESSES_LH> pIpAdapterAddress) {
    var pAddr = pIpAdapterAddress.ref.FirstUnicastAddress;

    while (pAddr.ref.Next != nullptr) {
      pAddr = pAddr.ref.Next;
    }

    final prefixLength = pAddr.ref.OnLinkPrefixLength;
    String subnetBin = '';
    for (int i = 0; i < prefixLength; i++) {
      subnetBin += '1';
    }
    for (int i = 0; i < 32 - prefixLength; i++) {
      subnetBin += '0';
    }

    final String subnet =
        '${int.parse(subnetBin.substring(0, 8), radix: 2)}.${int.parse(subnetBin.substring(8, 16), radix: 2)}.${int.parse(subnetBin.substring(16, 24), radix: 2)}.${int.parse(subnetBin.substring(24, 32), radix: 2)}';

    return subnet;
  }

  /// Obtains the broadcast address of the connected wifi network
  @override
  Future<String?> getWifiBroadcast() async {
    final String? ip = await getWifiIP();
    final String? subnet = await getWifiSubmask();
    if (ip == null || subnet == null) return null;
    final List<String> ipParts = ip.split('.');
    final List<String> subnetParts = subnet.split('.');
    String broadcast = '';
    for (int i = 0; i < 4; i++) {
      broadcast += (int.parse(ipParts[i]) | (~int.parse(subnetParts[i]) & 0xff))
          .toString();
      if (i < 3) broadcast += '.';
    }
    return broadcast;
  }

  /// Obtains the gateway IP address of the connected wifi network
  /// This is the IP address of the router
  @override
  Future<String?> getWifiGatewayIP() {
    return Future<String?>.value(query((pGuid, pAttributes) {
      final ulSize = calloc<ULONG>();
      Pointer<IP_ADAPTER_ADDRESSES_LH> pIpAdapterAddress = nullptr;
      try {
        GetAdaptersAddresses(
          ADDRESS_FAMILY.AF_INET,
          0x80,
          nullptr,
          nullptr,
          ulSize,
        );
        pIpAdapterAddress = HeapAlloc(GetProcessHeap(), 0, ulSize.value).cast();
        GetAdaptersAddresses(
          ADDRESS_FAMILY.AF_INET,
          0x80,
          nullptr,
          pIpAdapterAddress,
          ulSize,
        );
        final pAddr = getAdapterAddress(pGuid, pIpAdapterAddress);
        if (pAddr == null) return null;
        if (pAddr.ref.FirstGatewayAddress == nullptr) return null;
        return formatIPAddress(
            pAddr.ref.FirstGatewayAddress.ref.Address.lpSockaddr);
      } finally {
        free(ulSize);
        if (pIpAdapterAddress != nullptr) free(pIpAdapterAddress);
      }
    }));
  }
}
