// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "./include/package_info_plus/FPPPackageInfoPlusPlugin.h"

@implementation FPPPackageInfoPlusPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
  FlutterMethodChannel *channel = [FlutterMethodChannel
      methodChannelWithName:@"dev.fluttercommunity.plus/package_info"
            binaryMessenger:[registrar messenger]];
  FPPPackageInfoPlusPlugin *instance = [[FPPPackageInfoPlusPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall *)call
                  result:(FlutterResult)result {
  if ([call.method isEqualToString:@"getAll"]) {
    NSString *appStoreReceipt =
        [[[NSBundle mainBundle] appStoreReceiptURL] path];

    NSString *installerStore =
        [appStoreReceipt containsString:@"CoreSimulator"]
            ? @"com.apple.simulator"
        : [appStoreReceipt containsString:@"sandboxReceipt"]
            ? @"com.apple.testflight"
            : @"com.apple";

    NSDate *installDate = [self getInstallDate];
    NSDate *updateDate = [self getUpdateDate];

    result(@{
      @"appName" : [[NSBundle mainBundle]
          objectForInfoDictionaryKey:@"CFBundleDisplayName"]
          ?: [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"]
                 ?: [NSNull null],
      @"packageName" : [[NSBundle mainBundle] bundleIdentifier]
          ?: [NSNull null],
      @"version" : [[NSBundle mainBundle]
          objectForInfoDictionaryKey:@"CFBundleShortVersionString"]
          ?: [NSNull null],
      @"buildNumber" : [[NSBundle mainBundle]
          objectForInfoDictionaryKey:@"CFBundleVersion"]
          ?: [NSNull null],
      @"installerStore" : installerStore,
      @"installTime" : [self getTimeMillisStringFromDate:installDate] ?: [NSNull null],
      @"updateTime" : [self getTimeMillisStringFromDate:updateDate] ?: [NSNull null]
    });

  } else {
    result(FlutterMethodNotImplemented);
  }
}

- (NSDate *)getInstallDate {
    NSURL* urlToDocumentsFolder = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    __autoreleasing NSError *error;
    NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:urlToDocumentsFolder.path error:&error];

    if (error) {
        return nil;
    }

    return [attributes objectForKey:NSFileCreationDate];
}

- (NSDate *)getUpdateDate {
    __autoreleasing NSError *error;
    NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:[[NSBundle mainBundle] bundlePath] error:&error];
    NSDate *updateDate = [attributes fileModificationDate];

    if (error) {
        return nil;
    }

    return updateDate;
}

- (NSString *)getTimeMillisStringFromDate:(NSDate *)date {
    if (!date) {
        return nil;
    }

    NSNumber *timeMillis = @((long long)([date timeIntervalSince1970] * 1000));
    return [timeMillis stringValue];
}

@end
