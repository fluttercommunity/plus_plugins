#include "include/data_strength_plus/data_strength_plus_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "data_strength_plus_plugin.h"

void DataStrengthPlusPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  data_strength_plus::DataStrengthPlusPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
