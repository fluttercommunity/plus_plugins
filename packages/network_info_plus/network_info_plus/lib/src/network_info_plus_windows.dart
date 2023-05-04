/// The Windows implementation of `network_info_plus`.
// ignore_for_file: constant_identifier_names

library network_info_plus_windows;

import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:win32/win32.dart';
import 'package:network_info_plus_platform_interface/network_info_plus_platform_interface.dart';

typedef WlanQuery = String Function(
    Pointer<GUID> pGuid, Pointer<WLAN_CONNECTION_ATTRIBUTES> pAttributes);

class NetworkInfoPlusWindowsPlugin extends NetworkInfoPlatform {
  int clientHandle = NULL;

  static void registerWith() {
    NetworkInfoPlatform.instance = NetworkInfoPlusWindowsPlugin();
  }

  void init() {
    if (clientHandle != NULL) return;

    const WLAN_API_VERSION_2_0 = 0x00000002;
    final phClientHandle = calloc<HANDLE>();
    final pdwNegotiatedVersion = calloc<DWORD>();

    try {
      WlanOpenHandle(
          WLAN_API_VERSION_2_0, nullptr, pdwNegotiatedVersion, phClientHandle);
      clientHandle = phClientHandle.value;
    } finally {
      free(pdwNegotiatedVersion);
      free(phClientHandle);
    }
  }

  void closeHandle() {
    WlanCloseHandle(clientHandle, nullptr);

    clientHandle = NULL;
  }

  String query(WlanQuery query) {
    final ppInterfaceList = calloc<Pointer<WLAN_INTERFACE_INFO_LIST>>();
    var hr = WlanEnumInterfaces(clientHandle, nullptr, ppInterfaceList);
    if (hr != ERROR_SUCCESS) return '';

    for (var i = 0; i < ppInterfaceList.value.ref.dwNumberOfItems; i++) {
      // TODO: This is a hack. We should get the address of the actual GUID
      // here.
      final pInterfaceGuid = calloc<GUID>()
        ..ref.setGUID(ppInterfaceList.value.ref.InterfaceInfo[i].InterfaceGuid
            .toString());

      const opCode = 7; // wlan_intf_opcode_current_connection
      final pdwDataSize = calloc<DWORD>();
      final pAttributes = calloc<WLAN_CONNECTION_ATTRIBUTES>();

      hr = WlanQueryInterface(clientHandle, pInterfaceGuid, opCode, nullptr,
          pdwDataSize, pAttributes.cast(), nullptr);
      if (hr != ERROR_SUCCESS) break;
      if (pAttributes.ref.isState != 0) {
        return query(pInterfaceGuid, pAttributes);
      }
    }
    WlanFreeMemory(ppInterfaceList);
    return '';
  }

  String formatBssid(List<int> bssid) =>
      bssid.map((e) => e.toRadixString(16).padLeft(2, '0')).join(':');

  String formatIPAddress(Pointer<IP_ADAPTER_ADDRESSES_LH> pIpAdapterAddress) {
    return '';
    // PIP_ADAPTER_UNICAST_ADDRESS_LH pAddr = pIpAdapterAddress->FirstUnicastAddress;
    //       while (pAddr->Next != NULL) {
    //   pAddr = pAddr->Next;
    // }

    // CHAR buffer[64];
    // sockaddr_in *sa_in = (sockaddr_in *)pAddr->Address.lpSockaddr;
    // return std::string(inet_ntop(AF_INET, &(sa_in->sin_addr), buffer, 64));
  }

//   static std::string
// GetAdapterAddress(LPGUID pGuid, PIP_ADAPTER_ADDRESSES pIpAdapterAddresses) {
//   IF_LUID ifLuid;
//   if (ConvertInterfaceGuidToLuid(pGuid, &ifLuid) != NO_ERROR) {
//     return "";
//   }

//   PIP_ADAPTER_ADDRESSES pCurrent = pIpAdapterAddresses;
//   while (pCurrent) {
//     if (pCurrent->Luid.Value == ifLuid.Value) {
//       return FormatIpAddress(pCurrent);
//     }
//     pCurrent = pCurrent->Next;
//   }
//   return "";
// }

  @override
  Future<String> getWifiName() {
    return Future<String>.value(query((pGuid, pAttributes) {
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
  Future<String> getWifiBSSID() {
    return Future<String>.value(query((pGuid, pAttributes) {
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

  // std::string NetworkInfo::GetWifiIpAddress() const {
  // return const_cast<NetworkInfo *>(this)->Query(
  //     [&](LPGUID pGuid, PWLAN_CONNECTION_ATTRIBUTES pAttributes) {
  //       ULONG ulSize = 0;
  //       GetAdaptersAddresses(AF_INET, 0, NULL, NULL, &ulSize);
  //       PIP_ADAPTER_ADDRESSES pIpAdapterAddresses =
  //           (PIP_ADAPTER_ADDRESSES)HeapAlloc(GetProcessHeap(), 0, ulSize);

  //       std::string res;
  //       if (GetAdaptersAddresses(AF_UNSPEC, 0, NULL, pIpAdapterAddresses,
  //                                &ulSize) == 0) {
  //         res = GetAdapterAddress(pGuid, pIpAdapterAddresses);
  //       }

  //       HeapFree(GetProcessHeap(), 0, pIpAdapterAddresses);
  //       return res;
  //     });

  /// Obtains the IP v4 address of the connected wifi network
  @override
  Future<String?> getWifiIP() {
    throw UnimplementedError('getWifiIP() has not been implemented.');
  }

  /// Obtains the IP v6 address of the connected wifi network
  @override
  Future<String?> getWifiIPv6() {
    throw UnimplementedError('getWifiIPv6() has not been implemented.');
  }

  /// Obtains the submask of the connected wifi network
  @override
  Future<String?> getWifiSubmask() {
    throw UnimplementedError('getWifiSubmask() has not been implemented.');
  }

  /// Obtains the gateway IP address of the connected wifi network
  @override
  Future<String?> getWifiGatewayIP() {
    throw UnimplementedError('getWifiGatewayIP() has not been implemented.');
  }

  /// Obtains the broadcast of the connected wifi network
  @override
  Future<String?> getWifiBroadcast() {
    throw UnimplementedError('getWifiBroadcast() has not been implemented.');
  }
}
