/// The Windows implementation of `network_info_plus`.
// ignore_for_file: constant_identifier_names

library network_info_plus_windows;

import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:win32/win32.dart';
import 'package:network_info_plus_platform_interface/network_info_plus_platform_interface.dart';
import 'package:win32/winsock2.dart';

typedef WlanQuery = String? Function(
    Pointer<GUID> pGuid, Pointer<WLAN_CONNECTION_ATTRIBUTES> pAttributes);

class NetworkInfoPlusWindowsPlugin extends NetworkInfoPlatform {
  int clientHandle = NULL;

  static void registerWith() {
    NetworkInfoPlatform.instance = NetworkInfoPlusWindowsPlugin();
  }

  void openHandle() {
    if (clientHandle != NULL) return;

    const WLAN_API_VERSION_2_0 = 0x00000002;
    final phClientHandle = calloc<HANDLE>();
    final pdwNegotiatedVersion = calloc<DWORD>();

    try {
      final hr = WlanOpenHandle(
          WLAN_API_VERSION_2_0, nullptr, pdwNegotiatedVersion, phClientHandle);
      if (hr == ERROR_SERVICE_NOT_ACTIVE) return;
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
      if (hr != ERROR_SUCCESS) return null; // no wifi interface available

      for (var i = 0; i < ppInterfaceList.value.ref.dwNumberOfItems; i++) {
        final pInterfaceGuid = calloc<GUID>()
          ..ref.setGUID(ppInterfaceList.value.ref.InterfaceInfo[i].InterfaceGuid
              .toString());

        const opCode = 7; // wlan_intf_opcode_current_connection
        final pdwDataSize = calloc<DWORD>();
        final pAttributes = calloc<WLAN_CONNECTION_ATTRIBUTES>();

        try {
          hr = WlanQueryInterface(clientHandle, pInterfaceGuid, opCode, nullptr,
              pdwDataSize, pAttributes.cast(), nullptr);
          if (hr != ERROR_SUCCESS) break;
          if (pAttributes.ref.isState != 0) {
            return query(pInterfaceGuid, pAttributes);
          }
        } finally {
          free(pInterfaceGuid);
          free(pdwDataSize);
          free(pAttributes);
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

  String formatIPAddress(Pointer<IP_ADAPTER_ADDRESSES_LH> pIpAdapterAddress) {
    var pAddr = pIpAdapterAddress.ref.FirstUnicastAddress;

    while (pAddr.ref.Next != nullptr) {
      pAddr = pAddr.ref.Next;
    }

    final buffer = calloc<BYTE>(64).cast<Utf8>();
    try {
      // Rather messy way to find the right pointer for the IP Address
      final sinAddr = pAddr.ref.Address.lpSockaddr.cast<BYTE>().elementAt(4);

      inet_ntop(AF_INET, sinAddr, buffer, 64);
      return buffer.cast<Utf8>().toDartString();
    } finally {
      free(buffer);
    }
  }

  String? getAdapterAddress(Pointer<GUID> pGuid,
      Pointer<IP_ADAPTER_ADDRESSES_LH> pIpAdapterAddresses) {
    final ifLuid = calloc<NET_LUID_LH>();
    try {
      if (ConvertInterfaceGuidToLuid(pGuid, ifLuid) != NO_ERROR) {
        return null;
      }

      var pCurrent = pIpAdapterAddresses;
      while (pCurrent.address != 0) {
        if (pCurrent.ref.Luid.Value == ifLuid.ref.Value) {
          return formatIPAddress(pCurrent);
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

  /// Obtains the IP v4 address of the connected wifi network
  @override
  Future<String?> getWifiIP() {
    return Future<String?>.value(query((pGuid, pAttributes) {
      final ulSize = calloc<ULONG>();
      Pointer<IP_ADAPTER_ADDRESSES_LH> pIpAdapterAddress = nullptr;
      try {
        GetAdaptersAddresses(AF_INET, 0, nullptr, nullptr, ulSize);
        pIpAdapterAddress = HeapAlloc(GetProcessHeap(), 0, ulSize.value).cast();
        GetAdaptersAddresses(AF_INET, 0, nullptr, pIpAdapterAddress, ulSize);
        return getAdapterAddress(pGuid, pIpAdapterAddress);
      } finally {
        free(ulSize);
        if (pIpAdapterAddress != nullptr) free(pIpAdapterAddress);
      }
    }));
  }
}
