#import "ConnectivityPlusPlugin.h"
#if __has_include(<connectivity_plus/connectivity_plus-Swift.h>)
#import <connectivity_plus/connectivity_plus-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "connectivity_plus-Swift.h"
#endif

@implementation ConnectivityPlusPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
  [SwiftConnectivityPlusPlugin registerWithRegistrar:registrar];
}
@end
