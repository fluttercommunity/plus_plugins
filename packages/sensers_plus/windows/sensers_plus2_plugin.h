#ifndef FLUTTER_PLUGIN_SENSERS_PLUS2_PLUGIN_H_
#define FLUTTER_PLUGIN_SENSERS_PLUS2_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace sensers_plus2 {

class SensersPlus2Plugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  SensersPlus2Plugin();

  virtual ~SensersPlus2Plugin();

  // Disallow copy and assign.
  SensersPlus2Plugin(const SensersPlus2Plugin&) = delete;
  SensersPlus2Plugin& operator=(const SensersPlus2Plugin&) = delete;

 private:
  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace sensers_plus2

#endif  // FLUTTER_PLUGIN_SENSERS_PLUS2_PLUGIN_H_
