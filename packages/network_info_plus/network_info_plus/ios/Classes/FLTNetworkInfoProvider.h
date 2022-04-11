#import "FLTNetworkInfo.h"
#import <Foundation/Foundation.h>

@protocol FLTNetworkInfoProvider <NSObject>

- (void)fetchNetworkInfoWithCompletionHandler:
    (void (^)(FLTNetworkInfo *networkInfo))completionHandler;

@end
