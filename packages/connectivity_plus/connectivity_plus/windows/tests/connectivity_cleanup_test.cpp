// Include the actual plugin class, which is private to this translation unit.
#include "../connectivity_plus_plugin.cpp"

#include <iostream>

int main() {
  if (FAILED(CoInitializeEx(nullptr, COINIT_APARTMENTTHREADED))) {
    std::cerr << "Could not initialize the caller's COM apartment."
              << std::endl;
    return 10;
  }

  auto plugin = std::make_unique<ConnectivityPlusWindowsPlugin>();
  // The event-channel handler retains this owner until channel teardown.
  auto stream_owner = plugin->GetManager();
  if (!stream_owner->StartListen([] {})) {
    std::cerr << "Could not start the initial listener." << std::endl;
    return 11;
  }

  plugin.reset();
  // Teardown must unregister the old listener without invalidating the shared
  // manager. Starting another listener checks both conditions.
  const bool listener_stopped = stream_owner->StartListen([] {});
  if (listener_stopped) {
    stream_owner->StopListen();
  }
  stream_owner.reset();

  APTTYPE type;
  APTTYPEQUALIFIER qualifier;
  const HRESULT apartment = CoGetApartmentType(&type, &qualifier);
  std::cout << "listener_stopped=" << std::boolalpha << listener_stopped
            << " caller_apartment_hresult=0x" << std::hex
            << static_cast<unsigned long>(apartment) << std::endl;
  if (SUCCEEDED(apartment)) {
    CoUninitialize();
  }

  return listener_stopped && apartment == S_OK ? 0 : 1;
}
