// based on
// https://github.com/PurpleI2P/i2pd/blob/master/Win32/Win32NetState.cpp

/*
 * Copyright (c) 2013-2020, The PurpleI2P Project
 *
 * This file is part of Purple i2pd project and licensed under BSD3
 *
 * See full license text in LICENSE file at top of project tree
 */

#include "include/connectivity_plus/network_manager.h"

#include <iphlpapi.h>
#include <netlistmgr.h>
#include <ocidl.h>

#include <cassert>
#include <set>

class NetworkListener final : public INetworkListManagerEvents {
public:
  NetworkListener(NetworkCallback pCb) : pCallback(pCb) {}

  HRESULT STDMETHODCALLTYPE QueryInterface(REFIID riid, void **ppvObject) {
    if (!ppvObject) {
      return E_POINTER;
    }

    if (IsEqualIID(riid, IID_IUnknown)) {
      *ppvObject = static_cast<IUnknown *>(this);
    } else if (IsEqualIID(riid, IID_INetworkListManagerEvents)) {
      *ppvObject = static_cast<INetworkListManagerEvents *>(this);
    } else {
      *ppvObject = nullptr;
      return E_NOINTERFACE;
    }

    AddRef();
    return S_OK;
  }

  ULONG STDMETHODCALLTYPE AddRef() { return InterlockedIncrement(&lRef); }

  ULONG STDMETHODCALLTYPE Release() {
    LONG lAddend = InterlockedDecrement(&lRef);
    if (lRef == 0) {
      delete this;
    }
    return lAddend;
  }

  HRESULT STDMETHODCALLTYPE ConnectivityChanged(NLM_CONNECTIVITY) {
    Callback();
    return S_OK;
  }

  void Callback() {
    assert(pCallback);
    pCallback();
  }

private:
  volatile LONG lRef = 1;
  NetworkCallback pCallback = nullptr;
};

NetworkManager::NetworkManager() {}

NetworkManager::~NetworkManager() {
  StopListen();
  Cleanup();
}

bool NetworkManager::Init() {
  CoInitialize(NULL);

  HRESULT hr = CoCreateInstance(CLSID_NetworkListManager, NULL, CLSCTX_ALL,
                                IID_IUnknown, (void **)&pUnknown);
  if (SUCCEEDED(hr)) {
    hr = pUnknown->QueryInterface(IID_INetworkListManager,
                                  (void **)&pNetworkListManager);
  }
  return SUCCEEDED(hr);
}

void NetworkManager::Cleanup() {
  if (pNetworkListManager) {
    pNetworkListManager->Release();
    pNetworkListManager = NULL;
  }

  if (pUnknown) {
    pUnknown->Release();
    pUnknown = NULL;
  }

  CoUninitialize();
}

std::vector<GUID> NetworkManager::GetConnectedAdapterIds() const {
  std::vector<GUID> adapterIds;

  IEnumNetworkConnections *connections = NULL;
  HRESULT hr = pNetworkListManager->GetNetworkConnections(&connections);
  if (hr == S_OK) {
    while (true) {
      INetworkConnection *connection = NULL;
      hr = connections->Next(1, &connection, NULL);
      if (hr != S_OK) {
        break;
      }

      VARIANT_BOOL isConnected = VARIANT_FALSE;
      hr = connection->get_IsConnectedToInternet(&isConnected);
      if (hr == S_OK && isConnected == VARIANT_TRUE) {
        GUID guid;
        hr = connection->GetAdapterId(&guid);
        if (hr == S_OK) {
          adapterIds.push_back(std::move(guid));
        }
      }
      connection->Release();
    }
    connections->Release();
  }

  return adapterIds;
}

std::set<ConnectivityType> NetworkManager::GetConnectivityTypes() const {
  ULONG bufferSize = 15 * 1024;
  ULONG flags = GAA_FLAG_SKIP_UNICAST | GAA_FLAG_SKIP_ANYCAST |
                GAA_FLAG_SKIP_MULTICAST | GAA_FLAG_SKIP_DNS_SERVER |
                GAA_FLAG_SKIP_FRIENDLY_NAME;
  std::vector<unsigned char> buffer(bufferSize);
  PIP_ADAPTER_ADDRESSES addresses =
      reinterpret_cast<PIP_ADAPTER_ADDRESSES>(&buffer.front());
  DWORD rc = GetAdaptersAddresses(AF_UNSPEC, flags, 0, addresses, &bufferSize);
  if (rc == ERROR_BUFFER_OVERFLOW) {
    buffer.resize(bufferSize);
    addresses = reinterpret_cast<PIP_ADAPTER_ADDRESSES>(&buffer.front());
    rc = GetAdaptersAddresses(AF_UNSPEC, flags, 0, addresses, &bufferSize);
  }

  if (rc != NO_ERROR) {
    return {ConnectivityType::None};
  }

  std::vector<GUID> adapterIds = GetConnectedAdapterIds();
  if (adapterIds.empty()) {
    return {ConnectivityType::None};
  }

  std::set<ConnectivityType> connectivities;
  for (; addresses != NULL; addresses = addresses->Next) {
    NET_LUID luid;
    rc = ConvertInterfaceIndexToLuid(addresses->IfIndex, &luid);
    if (rc != NO_ERROR) {
      continue;
    }

    GUID guid;
    rc = ConvertInterfaceLuidToGuid(&luid, &guid);
    if (rc != NO_ERROR) {
      continue;
    }

    if (std::find(adapterIds.begin(), adapterIds.end(), guid) !=
        adapterIds.end()) {
      // Read more at
      // https://learn.microsoft.com/en-us/windows/win32/api/iptypes/ns-iptypes-ip_adapter_addresses_lh
      switch (addresses->IfType) {
      case IF_TYPE_ETHERNET_CSMACD:
      case IF_TYPE_IEEE1394:
        connectivities.insert(ConnectivityType::Ethernet);
        break;
      case IF_TYPE_IEEE80211:
        connectivities.insert(ConnectivityType::WiFi);
        break;
      case IF_TYPE_TUNNEL:
      case IF_TYPE_PPP:
        connectivities.insert(ConnectivityType::VPN);
        break;
      default:
        connectivities.insert(ConnectivityType::Other);
        break;
      }
    }
  }

  if (connectivities.empty()) {
    // If no specific connectivity types were found, return a set containing
    // only None
    return {ConnectivityType::None};
  }

  // Return the set of detected connectivity types
  return connectivities;
}

bool NetworkManager::StartListen(NetworkCallback pCallback) {
  lastError = S_OK;
  if (!pCallback) {
    lastError = E_INVALIDARG;
    return false;
  }
  if (pListener) {
    lastError = HRESULT_FROM_WIN32(ERROR_ALREADY_EXISTS);
    return false;
  }
  if (!pNetworkListManager) {
    lastError = E_POINTER;
    return false;
  }

  HRESULT hr = pNetworkListManager->QueryInterface(
      IID_IConnectionPointContainer, (void **)&pCPContainer);
  if (SUCCEEDED(hr)) {
    hr = pCPContainer->FindConnectionPoint(IID_INetworkListManagerEvents,
                                           &pConnectPoint);
    if (SUCCEEDED(hr)) {
      pListener = new NetworkListener(pCallback);
      hr = pConnectPoint->Advise((IUnknown *)pListener, &dwCookie);
      if (SUCCEEDED(hr)) {
        return true;
      }
    }
  }

  lastError = hr;
  if (pListener) {
    pListener->Release();
    pListener = NULL;
  }
  if (pConnectPoint) {
    pConnectPoint->Release();
    pConnectPoint = NULL;
  }
  if (pCPContainer) {
    pCPContainer->Release();
    pCPContainer = NULL;
  }
  dwCookie = 0;
  return false;
}

void NetworkManager::StopListen() {
  if (pConnectPoint) {
    if (dwCookie != 0) {
      pConnectPoint->Unadvise(dwCookie);
    }
    pConnectPoint->Release();
    pConnectPoint = NULL;
    dwCookie = 0;
  }

  if (pCPContainer) {
    pCPContainer->Release();
    pCPContainer = NULL;
  }

  if (pListener) {
    pListener->Release();
    pListener = NULL;
  }
}

bool NetworkManager::HasError() const { return FAILED(lastError); }

int NetworkManager::GetError() const { return static_cast<int>(lastError); }
