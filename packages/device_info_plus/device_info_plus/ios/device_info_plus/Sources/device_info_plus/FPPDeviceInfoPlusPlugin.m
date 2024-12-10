// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "./include/device_info_plus/FPPDeviceInfoPlusPlugin.h"
#import "./include/device_info_plus/DeviceIdentifiers.h"
#import <sys/utsname.h>

@implementation FPPDeviceInfoPlusPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
  FlutterMethodChannel *channel = [FlutterMethodChannel
      methodChannelWithName:@"dev.fluttercommunity.plus/device_info"
            binaryMessenger:[registrar messenger]];
  FPPDeviceInfoPlusPlugin *instance = [[FPPDeviceInfoPlusPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall *)call
                  result:(FlutterResult)result {
  if ([@"getDeviceInfo" isEqualToString:call.method]) {
    UIDevice *device = [UIDevice currentDevice];
    struct utsname un;
    uname(&un);

    NSNumber *isPhysicalNumber =
        [NSNumber numberWithBool:[self isDevicePhysical]];
    NSProcessInfo *info = [NSProcessInfo processInfo];
    NSNumber *isiOSAppOnMac = [NSNumber numberWithBool:NO];
    if (@available(iOS 14.0, *)) {
      isiOSAppOnMac = [NSNumber numberWithBool:[info isiOSAppOnMac]];
    }
    NSString *machine;
    NSString *deviceName;
    if ([self isDevicePhysical]) {
      machine = @(un.machine);
    } else {
      machine = [info environment][@"SIMULATOR_MODEL_IDENTIFIER"];
    }
    deviceName = [DeviceIdentifiers userKnownDeviceModel:machine];

    result(@{
      @"name" : [device name],
      @"systemName" : [device systemName],
      @"systemVersion" : [device systemVersion],
      @"model" : [device model],
      @"localizedModel" : [device localizedModel],
      @"modelName" : deviceName,
      @"identifierForVendor" : [[device identifierForVendor] UUIDString]
          ?: [NSNull null],
      @"isPhysicalDevice" : isPhysicalNumber,
      @"isiOSAppOnMac" : isiOSAppOnMac,
      @"utsname" : @{
        @"sysname" : @(un.sysname),
        @"nodename" : @(un.nodename),
        @"release" : @(un.release),
        @"version" : @(un.version),
        @"machine" : machine,
      }
    });
  } else {
    result(FlutterMethodNotImplemented);
  }
}

// return value is false if code is run on a simulator
- (BOOL)isDevicePhysical {
  BOOL isPhysicalDevice = NO;
#if TARGET_OS_SIMULATOR
  isPhysicalDevice = NO;
#else
  isPhysicalDevice = YES;
#endif

  return isPhysicalDevice;
}

@end
