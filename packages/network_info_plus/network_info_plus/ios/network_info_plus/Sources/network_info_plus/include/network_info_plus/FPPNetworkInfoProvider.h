#import "FPPNetworkInfo.h"
#import <Foundation/Foundation.h>

@protocol FPPNetworkInfoProvider <NSObject>

- (void)fetchNetworkInfoWithCompletionHandler:
    (void (^)(FPPNetworkInfo *networkInfo))completionHandler;

@end
