#include "include/network_info_plus_windows/network_info.h"

#include <netioapi.h>
#include <iphlpapi.h>
#include <iptypes.h>
#include <windot11.h>
#include <ws2tcpip.h>

#include <memory>

NetworkInfo::NetworkInfo() {
  Init();
}

NetworkInfo::~NetworkInfo() {
  Cleanup();
}

BOOL NetworkInfo::HasError() const {
  return _dwError != ERROR_SUCCESS;
}

DWORD NetworkInfo::GetError() const {
    return _dwError;
}

std::string NetworkInfo::GetErrorString() const {
  // ### TODO: FormatMessage()
  return "";
}

std::string NetworkInfo::GetWifiName() const {
  return const_cast<NetworkInfo*>(this)->Query([&](LPGUID, PWLAN_CONNECTION_ATTRIBUTES pAttributes) {
    PDOT11_SSID ssid = &pAttributes->wlanAssociationAttributes.dot11Ssid;
    return std::string((const char*) ssid->ucSSID, ssid->uSSIDLength);
  });
}

static std::string FormatBssid(DOT11_MAC_ADDRESS ssid) {
  char str[18];
  sprintf_s(str, "%02x:%02x:%02x:%02x:%02x:%02x", ssid[0], ssid[1], ssid[2], ssid[3], ssid[4], ssid[5]);
  return std::string(str, 18);
}

std::string NetworkInfo::GetWifiBssid() const {
  return const_cast<NetworkInfo*>(this)->Query([&](LPGUID, PWLAN_CONNECTION_ATTRIBUTES pAttributes) {
    return FormatBssid(pAttributes->wlanAssociationAttributes.dot11Bssid);
  });
}

static std::string FormatIpAddress(PIP_ADAPTER_ADDRESSES pIpAdapterAddress) {
  PIP_ADAPTER_UNICAST_ADDRESS_LH pAddr = pIpAdapterAddress->FirstUnicastAddress;
  while(pAddr->Next != NULL) {
    pAddr = pAddr->Next;
  }

  CHAR buffer[64];
  sockaddr_in *sa_in = (sockaddr_in *) pAddr->Address.lpSockaddr;
  return std::string(inet_ntop(AF_INET, &(sa_in->sin_addr), buffer, 64));
}

static std::string GetAdapterAddress(LPGUID pGuid, PIP_ADAPTER_ADDRESSES pIpAdapterAddresses) {
  IF_LUID ifLuid;
  if (ConvertInterfaceGuidToLuid(pGuid, &ifLuid) != NO_ERROR) {
    return "";
  }

  PIP_ADAPTER_ADDRESSES pCurrent = pIpAdapterAddresses;
  while (pCurrent) {
    if (pCurrent->Luid.Value == ifLuid.Value) {
      return FormatIpAddress(pCurrent);
    }
    pCurrent = pCurrent->Next;
  }
  return "";
}

std::string NetworkInfo::GetWifiIpAddress() const {
  return const_cast<NetworkInfo*>(this)->Query([&](LPGUID pGuid, PWLAN_CONNECTION_ATTRIBUTES pAttributes) {
    ULONG ulSize = 0;
    GetAdaptersAddresses(AF_INET, 0, NULL, NULL, &ulSize);
    PIP_ADAPTER_ADDRESSES pIpAdapterAddresses = (PIP_ADAPTER_ADDRESSES)HeapAlloc(GetProcessHeap(), 0, ulSize);

    std::string res;
    if (GetAdaptersAddresses(AF_UNSPEC, 0, NULL, pIpAdapterAddresses, &ulSize) == 0) {
      res = GetAdapterAddress(pGuid, pIpAdapterAddresses);
    }

    HeapFree(GetProcessHeap(), 0, pIpAdapterAddresses);
    return res;
  });
}

void NetworkInfo::Init() {
  if (_hClient != NULL) {
    return;
  }
  DWORD version = WLAN_API_MAKE_VERSION(2, 0);
  _dwError = WlanOpenHandle(WLAN_API_VERSION, NULL, &version, &_hClient);
}

void NetworkInfo::Cleanup() {
  if (_hClient == NULL) {
    return;
  }
  WlanCloseHandle(_hClient, NULL);
  _hClient = NULL;
}

std::string NetworkInfo::Query(WlanQuery query) {
  PWLAN_INTERFACE_INFO_LIST pInterfaces = NULL;
  if (_dwError = WlanEnumInterfaces(_hClient, NULL, &pInterfaces); HasError()) {
    return "";
  }

  std::string res;
  for (DWORD i = 0; i < pInterfaces->dwNumberOfItems; ++i) {
    LPGUID pGuid = &pInterfaces->InterfaceInfo[i].InterfaceGuid;
    WLAN_INTF_OPCODE OpCode = wlan_intf_opcode_current_connection;
    DWORD dwDataSize = 0;

    PWLAN_CONNECTION_ATTRIBUTES pAttributes = NULL;
    if (_dwError = WlanQueryInterface(_hClient, pGuid, OpCode, NULL, &dwDataSize, (LPVOID*)&pAttributes, NULL); HasError()) {
      break;
    }

    std::unique_ptr<WLAN_CONNECTION_ATTRIBUTES, decltype(&WlanFreeMemory)> cleanup(pAttributes, WlanFreeMemory);
    if (pAttributes->isState) {
      res = query(pGuid, pAttributes);
      break;
    }
  }

  WlanFreeMemory(pInterfaces);
  return res;
}
