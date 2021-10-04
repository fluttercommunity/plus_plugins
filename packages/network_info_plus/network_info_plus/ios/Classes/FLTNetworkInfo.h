#import <Foundation/Foundation.h>

@interface FLTNetworkInfo : NSObject

@property(nonatomic, readonly) NSString *SSID;
@property(nonatomic, readonly) NSString *BSSID;

- (instancetype)initWithSSID:(NSString *)SSID BSSID:(NSString *)BSSID;

@end
