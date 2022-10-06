#include "include/sensers_plus2/sensers_plus2_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "sensers_plus2_plugin.h"

void SensersPlus2PluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  sensers_plus2::SensersPlus2Plugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
