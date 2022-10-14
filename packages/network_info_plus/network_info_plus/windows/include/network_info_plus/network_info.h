#ifndef FLUTTER_PLUGIN_NETWORK_INFO_PLUS_NETWORK_INFO_H_
#define FLUTTER_PLUGIN_NETWORK_INFO_PLUS_NETWORK_INFO_H_

// clang-format off
#include <winsock2.h>
// clang-format on
#include <windows.h>
#include <winerror.h>
#include <wlanapi.h>

#include <functional>
#include <string>

typedef std::function<std::string(LPGUID, PWLAN_CONNECTION_ATTRIBUTES)>
    WlanQuery;

class NetworkInfo {
public:
  NetworkInfo();
  ~NetworkInfo();

  BOOL HasError() const;
  DWORD GetError() const;
  std::string GetErrorString() const;

  std::string GetWifiName() const;
  std::string GetWifiBssid() const;
  std::string GetWifiIpAddress() const;

private:
  void Init();
  void Cleanup();
  std::string Query(WlanQuery query);

  DWORD _dwError = ERROR_SUCCESS;
  HANDLE _hClient = NULL;
};

#endif // FLUTTER_PLUGIN_NETWORK_INFO_PLUS_NETWORK_INFO_H_
