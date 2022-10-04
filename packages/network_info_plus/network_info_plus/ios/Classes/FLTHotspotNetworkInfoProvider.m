#import "FLTHotspotNetworkInfoProvider.h"
#import <NetworkExtension/NetworkExtension.h>

@implementation FLTHotspotNetworkInfoProvider

- (void)fetchNetworkInfoWithCompletionHandler:
    (void (^)(FLTNetworkInfo *network))completionHandler
    API_AVAILABLE(ios(14)) {
  [NEHotspotNetwork fetchCurrentWithCompletionHandler:^(
                        NEHotspotNetwork *network) {
    dispatch_async(dispatch_get_main_queue(), ^{
      if (network) {
        completionHandler([[FLTNetworkInfo alloc] initWithSSID:network.SSID
                                                         BSSID:network.BSSID]);
        return;
      }
      completionHandler(nil);
    });
  }];
}

@end
