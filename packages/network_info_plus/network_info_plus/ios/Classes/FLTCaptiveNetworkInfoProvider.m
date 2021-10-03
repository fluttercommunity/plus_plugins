#import "FLTCaptiveNetworkInfoProvider.h"
#import <SystemConfiguration/CaptiveNetwork.h>

@implementation FLTCaptiveNetworkInfoProvider

- (void)fetchNetworkInfoWithCompletionHandler:(void (^)(FLTNetworkInfo *network))completionHandler {
  dispatch_async(dispatch_get_main_queue(), ^{
    NSArray *interfaceNames = (__bridge_transfer id)CNCopySupportedInterfaces();
    for (NSString *interfaceName in interfaceNames) {
      NSDictionary *networkInfo =
          (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)interfaceName);
      if (networkInfo) {
        NSString *ssid = networkInfo[(NSString *)kCNNetworkInfoKeySSID];
        NSString *bssid = networkInfo[(NSString *)kCNNetworkInfoKeyBSSID];
        completionHandler([[FLTNetworkInfo alloc] initWithSSID:ssid BSSID:bssid]);
        return;
      }
    }
    completionHandler(nil);
  });
}

@end
