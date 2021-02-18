// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "FLTBatteryPlusPlugin.h"

@interface FLTBatteryPlusPlugin () <FlutterStreamHandler>
@end

@implementation FLTBatteryPlusPlugin {
  FlutterEventSink _eventSink;
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FLTBatteryPlusPlugin* instance = [[FLTBatteryPlusPlugin alloc] init];

  FlutterMethodChannel* channel =
      [FlutterMethodChannel methodChannelWithName:@"dev.fluttercommunity.plus/battery"
                                  binaryMessenger:[registrar messenger]];

  [registrar addMethodCallDelegate:instance channel:channel];
  FlutterEventChannel* chargingChannel =
      [FlutterEventChannel eventChannelWithName:@"dev.fluttercommunity.plus/charging"
                                binaryMessenger:[registrar messenger]];
  [chargingChannel setStreamHandler:instance];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getBatteryLevel" isEqualToString:call.method]) {
    int batteryLevel = [self getBatteryLevel];
    if (batteryLevel == -1) {
      result([FlutterError errorWithCode:@"UNAVAILABLE"
                                 message:@"Battery info unavailable"
                                 details:nil]);
    } else {
      result(@(batteryLevel));
    }
  } else {
    result(FlutterMethodNotImplemented);
  }
}

- (void)onBatteryStateDidChange:(NSNotification*)notification {
  [self sendBatteryStateEvent];
}

- (void)sendBatteryStateEvent {
  if (!_eventSink) return;
  UIDeviceBatteryState state = [[UIDevice currentDevice] batteryState];
  switch (state) {
    case UIDeviceBatteryStateUnknown:
      _eventSink(@"unknown");
    case UIDeviceBatteryStateFull:
      _eventSink(@"full");
    case UIDeviceBatteryStateCharging:
      _eventSink(@"charging");
      break;
    case UIDeviceBatteryStateUnplugged:
      _eventSink(@"discharging");
      break;
    default:
      _eventSink([FlutterError errorWithCode:@"UNAVAILABLE"
                                     message:@"Charging status unavailable"
                                     details:nil]);
      break;
  }
}

- (int)getBatteryLevel {
  UIDevice* device = UIDevice.currentDevice;
  device.batteryMonitoringEnabled = YES;
  if (device.batteryState == UIDeviceBatteryStateUnknown) {
    return -1;
  } else {
    return ((int)(device.batteryLevel * 100));
  }
}

#pragma mark FlutterStreamHandler impl

- (FlutterError*)onListenWithArguments:(id)arguments eventSink:(FlutterEventSink)eventSink {
  _eventSink = eventSink;
  [[UIDevice currentDevice] setBatteryMonitoringEnabled:YES];
  [self sendBatteryStateEvent];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(onBatteryStateDidChange:)
                                               name:UIDeviceBatteryStateDidChangeNotification
                                             object:nil];
  return nil;
}

- (FlutterError*)onCancelWithArguments:(id)arguments {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  _eventSink = nil;
  return nil;
}

@end
