#import <Foundation/Foundation.h>
#import "FLTNetworkInfo.h"

@protocol FLTNetworkInfoProvider <NSObject>

- (void)fetchNetworkInfoWithCompletionHandler:
    (void (^)(FLTNetworkInfo *networkInfo))completionHandler;

@end
