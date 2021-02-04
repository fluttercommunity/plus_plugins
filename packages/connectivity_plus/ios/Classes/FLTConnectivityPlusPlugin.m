// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "FLTConnectivityPlusPlugin.h"

#import "Reachability/Reachability.h"

@interface FLTConnectivityPlusPlugin () <FlutterStreamHandler>

@end

@implementation FLTConnectivityPlusPlugin {
  FlutterEventSink _eventSink;
  Reachability* _reachabilityForInternetConnection;
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FLTConnectivityPlusPlugin* instance = [[FLTConnectivityPlusPlugin alloc] init];

  FlutterMethodChannel* channel =
      [FlutterMethodChannel methodChannelWithName:@"dev.fluttercommunity.plus/connectivity"
                                  binaryMessenger:[registrar messenger]];
  [registrar addMethodCallDelegate:instance channel:channel];

  FlutterEventChannel* streamChannel =
      [FlutterEventChannel eventChannelWithName:@"dev.fluttercommunity.plus/connectivity_status"
                                binaryMessenger:[registrar messenger]];
  [streamChannel setStreamHandler:instance];
}

- (NSString*)statusFromReachability:(Reachability*)reachability {
  NetworkStatus status = [reachability currentReachabilityStatus];
  switch (status) {
    case NotReachable:
      return @"none";
    case ReachableViaWiFi:
      return @"wifi";
    case ReachableViaWWAN:
      return @"mobile";
  }
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([call.method isEqualToString:@"check"]) {
    // This is supposed to be quick. Another way of doing this would be to
    // signup for network
    // connectivity changes. However that depends on the app being in background
    // and the code
    // gets more involved. So for now, this will do.
    result([self statusFromReachability:[Reachability reachabilityForInternetConnection]]);
  } else {
    result(FlutterMethodNotImplemented);
  }
}

- (void)onReachabilityDidChange:(NSNotification*)notification {
  Reachability* curReach = [notification object];
  _eventSink([self statusFromReachability:curReach]);
}

#pragma mark FlutterStreamHandler impl

- (FlutterError*)onListenWithArguments:(id)arguments eventSink:(FlutterEventSink)eventSink {
  _eventSink = eventSink;
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(onReachabilityDidChange:)
                                               name:kReachabilityChangedNotification
                                             object:nil];
  _reachabilityForInternetConnection = [Reachability reachabilityForInternetConnection];
  [_reachabilityForInternetConnection startNotifier];
  return nil;
}

- (FlutterError*)onCancelWithArguments:(id)arguments {
  if (_reachabilityForInternetConnection) {
    [_reachabilityForInternetConnection stopNotifier];
    _reachabilityForInternetConnection = nil;
  }
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  _eventSink = nil;
  return nil;
}

@end
