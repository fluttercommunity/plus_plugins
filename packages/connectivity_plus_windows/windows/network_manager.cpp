// based on
// https://github.com/PurpleI2P/i2pd/blob/master/Win32/Win32NetState.cpp

/*
 * Copyright (c) 2013-2020, The PurpleI2P Project
 *
 * This file is part of Purple i2pd project and licensed under BSD3
 *
 * See full license text in LICENSE file at top of project tree
 */

#include "network_manager.h"

#include <netlistmgr.h>
#include <ocidl.h>

#include <cassert>

class NetworkListener final : public INetworkListManagerEvents {
 public:
  NetworkListener(NetworkCallback pCb) : pCallback(pCb) {}

  HRESULT STDMETHODCALLTYPE QueryInterface(REFIID riid, void **ppvObject) {
    AddRef();

    HRESULT hr = S_OK;
    if (IsEqualIID(riid, IID_IUnknown)) {
      *ppvObject = (IUnknown *)this;
    } else if (IsEqualIID(riid, IID_INetworkListManagerEvents)) {
      *ppvObject = (INetworkListManagerEvents *)this;
    } else {
      hr = E_NOINTERFACE;
    }
    return hr;
  }

  ULONG STDMETHODCALLTYPE AddRef() { return InterlockedIncrement(&lRef); }

  ULONG STDMETHODCALLTYPE Release() {
    LONG lAddend = InterlockedDecrement(&lRef);
    if (lRef == 0) {
      delete this;
    }
    return lAddend;
  }

  HRESULT STDMETHODCALLTYPE
  ConnectivityChanged(NLM_CONNECTIVITY fConnectivity) {
    Callback(fConnectivity &
             (NLM_CONNECTIVITY_IPV4_INTERNET | NLM_CONNECTIVITY_IPV6_INTERNET));
    return S_OK;
  }

  void Callback(bool bConnected) {
    assert(pCallback);
    pCallback(bConnected);
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

bool NetworkManager::IsConnected() {
  VARIANT_BOOL Connected = VARIANT_FALSE;
  HRESULT hr = pNetworkListManager->get_IsConnectedToInternet(&Connected);
  if (FAILED(hr)) {
    return false;
  }
  return Connected == VARIANT_TRUE;
}

bool NetworkManager::StartListen(NetworkCallback pCallback) {
  if (!pCallback || pListener) {
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
  return false;
}

void NetworkManager::StopListen() {
  if (pConnectPoint) {
    pConnectPoint->Unadvise(dwCookie);
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

bool NetworkManager::HasError() const { return GetLastError() != 0; }

int NetworkManager::GetError() const { return GetLastError(); }
