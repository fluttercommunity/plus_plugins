#import "FPPHotspotNetworkInfoProvider.h"
#import <NetworkExtension/NetworkExtension.h>

@implementation FPPHotspotNetworkInfoProvider

- (void)fetchNetworkInfoWithCompletionHandler:
    (void (^)(FPPNetworkInfo *network))completionHandler
    API_AVAILABLE(ios(14)) {
  [NEHotspotNetwork fetchCurrentWithCompletionHandler:^(
                        NEHotspotNetwork *network) {
    dispatch_async(dispatch_get_main_queue(), ^{
      if (network) {
        completionHandler([[FPPNetworkInfo alloc] initWithSSID:network.SSID
                                                         BSSID:network.BSSID]);
        return;
      }
      completionHandler(nil);
    });
  }];
}

@end
