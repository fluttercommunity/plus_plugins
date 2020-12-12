// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "FLTSensorsPlusPlugin.h"
#import <CoreMotion/CoreMotion.h>

@implementation FLTSensorsPlusPlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FLTAccelerometerStreamHandlerPlus* accelerometerStreamHandler =
      [[FLTAccelerometerStreamHandlerPlus alloc] init];
  FlutterEventChannel* accelerometerChannel =
      [FlutterEventChannel eventChannelWithName:@"dev.fluttercommunity.plus/sensors/accelerometer"
                                binaryMessenger:[registrar messenger]];
  [accelerometerChannel setStreamHandler:accelerometerStreamHandler];

  FLTUserAccelStreamHandlerPlus* userAccelerometerStreamHandler =
      [[FLTUserAccelStreamHandlerPlus alloc] init];
  FlutterEventChannel* userAccelerometerChannel =
      [FlutterEventChannel eventChannelWithName:@"dev.fluttercommunity.plus/sensors/user_accel"
                                binaryMessenger:[registrar messenger]];
  [userAccelerometerChannel setStreamHandler:userAccelerometerStreamHandler];

  FLTGyroscopeStreamHandlerPlus* gyroscopeStreamHandler =
      [[FLTGyroscopeStreamHandlerPlus alloc] init];
  FlutterEventChannel* gyroscopeChannel =
      [FlutterEventChannel eventChannelWithName:@"dev.fluttercommunity.plus/sensors/gyroscope"
                                binaryMessenger:[registrar messenger]];
  [gyroscopeChannel setStreamHandler:gyroscopeStreamHandler];
}

@end

const double GRAVITY = 9.8;
CMMotionManager* _motionManager;

void _initMotionManager() {
  if (!_motionManager) {
    _motionManager = [[CMMotionManager alloc] init];
  }
}

static void sendTriplet(Float64 x, Float64 y, Float64 z, FlutterEventSink sink) {
  NSMutableData* event = [NSMutableData dataWithCapacity:3 * sizeof(Float64)];
  [event appendBytes:&x length:sizeof(Float64)];
  [event appendBytes:&y length:sizeof(Float64)];
  [event appendBytes:&z length:sizeof(Float64)];
  sink([FlutterStandardTypedData typedDataWithFloat64:event]);
}

@implementation FLTAccelerometerStreamHandlerPlus

- (FlutterError*)onListenWithArguments:(id)arguments eventSink:(FlutterEventSink)eventSink {
  _initMotionManager();
  [_motionManager
      startAccelerometerUpdatesToQueue:[[NSOperationQueue alloc] init]
                           withHandler:^(CMAccelerometerData* accelerometerData, NSError* error) {
                             CMAcceleration acceleration = accelerometerData.acceleration;
                             // Multiply by gravity, and adjust sign values to
                             // align with Android.
                             sendTriplet(-acceleration.x * GRAVITY, -acceleration.y * GRAVITY,
                                         -acceleration.z * GRAVITY, eventSink);
                           }];
  return nil;
}

- (FlutterError*)onCancelWithArguments:(id)arguments {
  [_motionManager stopAccelerometerUpdates];
  return nil;
}

@end

@implementation FLTUserAccelStreamHandlerPlus

- (FlutterError*)onListenWithArguments:(id)arguments eventSink:(FlutterEventSink)eventSink {
  _initMotionManager();
  [_motionManager
      startDeviceMotionUpdatesToQueue:[[NSOperationQueue alloc] init]
                          withHandler:^(CMDeviceMotion* data, NSError* error) {
                            CMAcceleration acceleration = data.userAcceleration;
                            // Multiply by gravity, and adjust sign values to align with Android.
                            sendTriplet(-acceleration.x * GRAVITY, -acceleration.y * GRAVITY,
                                        -acceleration.z * GRAVITY, eventSink);
                          }];
  return nil;
}

- (FlutterError*)onCancelWithArguments:(id)arguments {
  [_motionManager stopDeviceMotionUpdates];
  return nil;
}

@end

@implementation FLTGyroscopeStreamHandlerPlus

- (FlutterError*)onListenWithArguments:(id)arguments eventSink:(FlutterEventSink)eventSink {
  _initMotionManager();
  [_motionManager
      startGyroUpdatesToQueue:[[NSOperationQueue alloc] init]
                  withHandler:^(CMGyroData* gyroData, NSError* error) {
                    CMRotationRate rotationRate = gyroData.rotationRate;
                    sendTriplet(rotationRate.x, rotationRate.y, rotationRate.z, eventSink);
                  }];
  return nil;
}

- (FlutterError*)onCancelWithArguments:(id)arguments {
  [_motionManager stopGyroUpdates];
  return nil;
}

@end
