#import "FLTNetworkInfo.h"

@implementation FLTNetworkInfo

- (instancetype)initWithSSID:(NSString *)SSID BSSID:(NSString *)BSSID {
  if ((self = [super init])) {
    _SSID = [SSID copy];
    _BSSID = [BSSID copy];
  }
  return self;
}

@end
