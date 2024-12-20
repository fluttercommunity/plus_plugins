// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "./include/network_info_plus/FPPNetworkInfoPlusPlugin.h"

#import "./include/network_info_plus/FPPCaptiveNetworkInfoProvider.h"
#import "./include/network_info_plus/FPPHotspotNetworkInfoProvider.h"
#import "./include/network_info_plus/FPPNetworkInfo.h"
#import "./include/network_info_plus/FPPNetworkInfoProvider.h"
#import "SystemConfiguration/CaptiveNetwork.h"
#import "./include/network_info_plus/getgateway.h"
#import <CoreLocation/CoreLocation.h>

#include <ifaddrs.h>

#include <arpa/inet.h>
#include <netdb.h>

@interface FPPNetworkInfoPlusPlugin () <CLLocationManagerDelegate>

@property(strong, nonatomic) id<FPPNetworkInfoProvider> networkInfoProvider;

- (instancetype)initWithNetworkInfoProvider:
    (id<FPPNetworkInfoProvider>)networkInfoProvider;

@end

@implementation FPPNetworkInfoPlusPlugin {
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
  id<FPPNetworkInfoProvider> networkInfoProvider;
  if (@available(iOS 14, *)) {
    networkInfoProvider = [[FPPHotspotNetworkInfoProvider alloc] init];
  } else {
    networkInfoProvider = [[FPPCaptiveNetworkInfoProvider alloc] init];
  }
  FPPNetworkInfoPlusPlugin *instance = [[FPPNetworkInfoPlusPlugin alloc]
      initWithNetworkInfoProvider:networkInfoProvider];

  FlutterMethodChannel *channel = [FlutterMethodChannel
      methodChannelWithName:@"dev.fluttercommunity.plus/network_info"
            binaryMessenger:[registrar messenger]];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (instancetype)initWithNetworkInfoProvider:
    (id<FPPNetworkInfoProvider>)networkInfoProvider {
  if ((self = [super init])) {
    self.networkInfoProvider = networkInfoProvider;
  }
  return self;
}

#pragma mark - Callbacks

- (NSString *)getGatewayIP {
  struct in_addr gatewayAddr;
  int gatewayAdressResult = getdefaultgateway(&(gatewayAddr.s_addr));
  if (gatewayAdressResult >= 0) {
    return [NSString stringWithFormat:@"%s", inet_ntoa(gatewayAddr)];
  } else {
    return nil;
  }
}

- (NSString *)getWifiIP {
  __block NSString *addr = nil;
  [self enumerateWifiAddresses:AF_INET
                    usingBlock:^(struct ifaddrs *ifaddr) {
                      if (addr) return;
                      addr = [self descriptionForAddress:ifaddr->ifa_addr];
                    }];
  return addr;
}

- (NSString *)getWifiIPv6 {
  __block NSString *addr = nil;
  [self enumerateWifiAddresses:AF_INET6
                    usingBlock:^(struct ifaddrs *ifaddr) {
                      if (addr) return;
                      addr = [self descriptionForAddress:ifaddr->ifa_addr];
                    }];
  return addr;
}

- (NSString *)getWifiSubmask {
  __block NSString *addr = nil;
  [self enumerateWifiAddresses:AF_INET
                    usingBlock:^(struct ifaddrs *ifaddr) {
                      if (addr) return;
                      addr = [self descriptionForAddress:ifaddr->ifa_netmask];
                    }];
  return addr;
}

- (NSString *)getWifiBroadcast {
  __block NSString *addr = nil;
  [self enumerateWifiAddresses:AF_INET
                    usingBlock:^(struct ifaddrs *ifaddr) {
                      if (addr) return;
                      addr = [self descriptionForAddress:ifaddr->ifa_dstaddr];
                    }];
  return addr;
}

- (void)handleMethodCall:(FlutterMethodCall *)call
                  result:(FlutterResult)result {
  if ([call.method isEqualToString:@"wifiName"]) {
    [self.networkInfoProvider
        fetchNetworkInfoWithCompletionHandler:^(FPPNetworkInfo *networkInfo) {
          result(networkInfo.SSID);
        }];
  } else if ([call.method isEqualToString:@"wifiBSSID"]) {
    [self.networkInfoProvider
        fetchNetworkInfoWithCompletionHandler:^(FPPNetworkInfo *networkInfo) {
          result(networkInfo.BSSID);
        }];
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
  } else {
    result(FlutterMethodNotImplemented);
  }
}

#pragma mark - Utils

- (void)enumerateWifiAddresses:(NSInteger)family
                    usingBlock:(void (^)(struct ifaddrs *))block {
  struct ifaddrs *interfaces = NULL;
  struct ifaddrs *temp_addr = NULL;
  int success = 0;

  // retrieve the current interfaces - returns 0 on success
  success = getifaddrs(&interfaces);
  if (success != 0) {
      NSLog(@"Error: getifaddrs() failed with error code: %d", success);
      return;
  }

  // Loop through linked list of interfaces
  temp_addr = interfaces;
  while (temp_addr != NULL) {
      if (temp_addr->ifa_addr->sa_family == family) {
          // One of `en` interfaces should be WiFi interface
          if (strncmp(temp_addr->ifa_name, "en", 2) == 0) {
              block(temp_addr);
          }
      }

      temp_addr = temp_addr->ifa_next;
  }

  // Free memory
  freeifaddrs(interfaces);
}

- (NSString *)descriptionForAddress:(struct sockaddr *)addr {
  char hostname[NI_MAXHOST];
  getnameinfo(addr, addr->sa_len, hostname, NI_MAXHOST, NULL, 0,
              NI_NUMERICHOST);
  return [NSString stringWithUTF8String:hostname];
}

@end
