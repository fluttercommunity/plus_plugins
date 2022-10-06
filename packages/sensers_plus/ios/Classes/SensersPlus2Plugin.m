#import "SensersPlus2Plugin.h"
#if __has_include(<sensers_plus2/sensers_plus2-Swift.h>)
#import <sensers_plus2/sensers_plus2-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "sensers_plus2-Swift.h"
#endif

@implementation SensersPlus2Plugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftSensersPlus2Plugin registerWithRegistrar:registrar];
}
@end
