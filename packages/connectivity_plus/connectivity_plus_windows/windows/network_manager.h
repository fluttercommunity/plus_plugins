#ifndef NETWORK_MANAGER_H
#define NETWORK_MANAGER_H

#include <windows.h>

#include <functional>
#include <string>

class NetworkListener;
struct IConnectionPoint;
struct IConnectionPointContainer;
struct INetworkListManager;
struct IUnknown;

typedef std::function<void(bool)> NetworkCallback;

class NetworkManager {
 public:
  NetworkManager();
  ~NetworkManager();

  bool Init();
  void Cleanup();

  bool IsConnected();

  bool StartListen(NetworkCallback pCallback);
  void StopListen();

  bool HasError() const;
  int GetError() const;

 private:
  DWORD dwCookie = 0;
  IUnknown *pUnknown = NULL;
  INetworkListManager *pNetworkListManager = NULL;
  IConnectionPointContainer *pCPContainer = NULL;
  IConnectionPoint *pConnectPoint = NULL;
  NetworkListener *pListener = NULL;
};

#endif  // NETWORK_MANAGER_H
