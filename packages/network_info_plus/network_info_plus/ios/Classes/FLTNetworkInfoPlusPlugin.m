// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "FLTNetworkInfoPlusPlugin.h"

#import <CoreLocation/CoreLocation.h>
#import "FLTNetworkInfoLocationPlusHandler.h"
#import "SystemConfiguration/CaptiveNetwork.h"
#import "getgateway.h"

#include <ifaddrs.h>

#include <arpa/inet.h>

@interface FLTNetworkInfoPlusPlugin () <CLLocationManagerDelegate>

@property(strong, nonatomic) FLTNetworkInfoLocationPlusHandler* locationHandler;

@end

@implementation FLTNetworkInfoPlusPlugin {
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FLTNetworkInfoPlusPlugin* instance = [[FLTNetworkInfoPlusPlugin alloc] init];

  FlutterMethodChannel* channel =
      [FlutterMethodChannel methodChannelWithName:@"dev.fluttercommunity.plus/network_info"
                                  binaryMessenger:[registrar messenger]];
  [registrar addMethodCallDelegate:instance channel:channel];
}

#pragma mark - Callbacks

- (NSString*)getWifiName {
  return [self findNetworkInfo:@"SSID"];
}

- (NSString*)getBSSID {
  return [self findNetworkInfo:@"BSSID"];
}

- (NSString*)getGatewayIP {
  struct in_addr gatewayAddr;
  int gatewayAdressResult = getDefaultGateway(&(gatewayAddr.s_addr));
  if(gatewayAdressResult >= 0) {
      return [NSString stringWithFormat: @"%s",inet_ntoa(gatewayAddr)];
  } else {
    return @"error";
  }
}

- (NSString*)getWifiIP {
  struct ifaddrs* temp_addr = [self getWifiInterfaceIPv4];
  if (temp_addr) {
    return [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in*)temp_addr->ifa_addr)->sin_addr)];
  } else {
    return @"error";
  }
}

- (NSString*)getWifiIPv6 {
  struct ifaddrs* temp_addr = [self getWifiInterfaceIPv6];
  if (temp_addr) {
    char ipv6AddressBuffer[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)temp_addr->ifa_addr;
    return [NSString stringWithUTF8String:inet_ntop(AF_INET6, &addr6->sin6_addr, ipv6AddressBuffer, INET6_ADDRSTRLEN)];
  } else {
    return @"error";
  }
}

- (NSString*)getWifiSubmask {
  struct ifaddrs* temp_addr = [self getWifiInterfaceIPv4];
  if (temp_addr) {
    return [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_netmask)->sin_addr)];
  } else {
    return @"error";
  }
}

- (NSString*)getWifiBroadcast {
  struct ifaddrs* temp_addr = [self getWifiInterfaceIPv4];
  if (temp_addr) {
    return [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_dstaddr)->sin_addr)];
  } else {
    return @"error";
  }
}

- (NSString*)convertCLAuthorizationStatusToString:(CLAuthorizationStatus)status {
  switch (status) {
    case kCLAuthorizationStatusNotDetermined: {
      return @"notDetermined";
    }
    case kCLAuthorizationStatusRestricted: {
      return @"restricted";
    }
    case kCLAuthorizationStatusDenied: {
      return @"denied";
    }
    case kCLAuthorizationStatusAuthorizedAlways: {
      return @"authorizedAlways";
    }
    case kCLAuthorizationStatusAuthorizedWhenInUse: {
      return @"authorizedWhenInUse";
    }
    default: {
      return @"unknown";
    }
  }
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([call.method isEqualToString:@"wifiName"]) {
    result([self getWifiName]);
  } else if ([call.method isEqualToString:@"wifiBSSID"]) {
    result([self getBSSID]);
  } else if ([call.method isEqualToString:@"wifiIPAddress"]) {
    result([self getWifiIP]);
  } else if ([call.method isEqualToString:@"wifiIPv6Address"]) {
    result([self getWifiIPv6]);
  } else if ([call.method isEqualToString:@"wifiSubmask"]) {
    result([self getWifiSubmask]);
  } else if ([call.method isEqualToString:@"wifiBroadcast"]) {
    result([self getWifiBroadcast]);
  } else if ([call.method isEqualToString:@"wifiGatewayAddress"]) {
    result([self getGatewayIP]);
  } else if ([call.method isEqualToString:@"getLocationServiceAuthorization"]) {
    result([self convertCLAuthorizationStatusToString:[FLTNetworkInfoLocationPlusHandler
                                                          locationAuthorizationStatus]]);
  } else if ([call.method isEqualToString:@"requestLocationServiceAuthorization"]) {
    NSArray* arguments = call.arguments;
    BOOL always = [arguments.firstObject boolValue];
    __weak typeof(self) weakSelf = self;
    [self.locationHandler
        requestLocationAuthorization:always
                          completion:^(CLAuthorizationStatus status) {
                            result([weakSelf convertCLAuthorizationStatusToString:status]);
                          }];
  } else {
    result(FlutterMethodNotImplemented);
  }
}

- (FLTNetworkInfoLocationPlusHandler*)locationHandler {
  if (!_locationHandler) {
    _locationHandler = [FLTNetworkInfoLocationPlusHandler new];
  }
  return _locationHandler;
}

#pragma mark - Utils

- (NSString*)findNetworkInfo:(NSString*)key {
  NSString* info = nil;
  NSArray* interfaceNames = (__bridge_transfer id)CNCopySupportedInterfaces();
  for (NSString* interfaceName in interfaceNames) {
    NSDictionary* networkInfo =
        (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)interfaceName);
    if (networkInfo[key]) {
      info = networkInfo[key];
    }
  }
  return info;
}

- (struct ifaddrs*)getWifiInterfaceIPv4 {
  return [self getWifiInterface:AF_INET];
}

- (struct ifaddrs*)getWifiInterfaceIPv6 {
  return [self getWifiInterface:AF_INET6];
}

- (struct ifaddrs*)getWifiInterface:(NSInteger)family {
  struct ifaddrs* interfaces = NULL;
  struct ifaddrs* temp_addr = NULL;
  struct ifaddrs* wifi_addr = NULL;
  int success = 0;

  // retrieve the current interfaces - returns 0 on success
  success = getifaddrs(&interfaces);
  if (success == 0) {
    // Loop through linked list of interfaces
    temp_addr = interfaces;
    while (temp_addr != NULL) {
      if (temp_addr->ifa_addr->sa_family == AF_INET || temp_addr->ifa_addr->sa_family == AF_INET6) {
          // en0 is the wifi connection on iOS
          if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
            if (temp_addr->ifa_addr->sa_family == family) {
              wifi_addr = temp_addr;
            } else if (temp_addr->ifa_addr->sa_family == family) {
              wifi_addr = temp_addr;
            }
        }
      }

      temp_addr = temp_addr->ifa_next;
    }
  }

  // Free memory
  freeifaddrs(interfaces);

  return wifi_addr;
}

@end
