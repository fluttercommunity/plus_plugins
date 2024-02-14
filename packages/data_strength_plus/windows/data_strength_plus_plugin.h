#ifndef FLUTTER_PLUGIN_DATA_STRENGTH_PLUS_PLUGIN_H_
#define FLUTTER_PLUGIN_DATA_STRENGTH_PLUS_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace data_strength_plus {

class DataStrengthPlusPlugin : public flutter::Plugin {
public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  DataStrengthPlusPlugin();

  virtual ~DataStrengthPlusPlugin();

  // Disallow copy and assign.
  DataStrengthPlusPlugin(const DataStrengthPlusPlugin &) = delete;
  DataStrengthPlusPlugin &operator=(const DataStrengthPlusPlugin &) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

} // namespace data_strength_plus

#endif // FLUTTER_PLUGIN_DATA_STRENGTH_PLUS_PLUGIN_H_
