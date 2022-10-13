#ifndef NETWORK_MANAGER_H
#define NETWORK_MANAGER_H

// clang-format off
#include <winsock2.h>
// clang-format on
#include <windows.h>

#include <functional>
#include <string>

enum class ConnectivityType { None, Ethernet, WiFi };

class NetworkListener;
struct IConnectionPoint;
struct IConnectionPointContainer;
struct INetworkListManager;
struct IUnknown;

typedef std::function<void()> NetworkCallback;

class NetworkManager {
public:
  NetworkManager();
  ~NetworkManager();

  bool Init();
  void Cleanup();

  ConnectivityType GetConnectivityType() const;

  bool StartListen(NetworkCallback pCallback);
  void StopListen();

  bool HasError() const;
  int GetError() const;

private:
  std::vector<GUID> GetConnectedAdapterIds() const;

  DWORD dwCookie = 0;
  IUnknown *pUnknown = NULL;
  INetworkListManager *pNetworkListManager = NULL;
  IConnectionPointContainer *pCPContainer = NULL;
  IConnectionPoint *pConnectPoint = NULL;
  NetworkListener *pListener = NULL;
};

#endif // NETWORK_MANAGER_H
