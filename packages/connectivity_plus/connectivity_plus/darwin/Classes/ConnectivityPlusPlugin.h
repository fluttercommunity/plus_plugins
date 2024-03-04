#if TARGET_OS_IOS
#import <Flutter/Flutter.h>
#elif TARGET_OS_OSX
#import <FlutterMacOS/FlutterMacOS.h>
#endif

@interface ConnectivityPlusPlugin : NSObject <FlutterPlugin>
@end
