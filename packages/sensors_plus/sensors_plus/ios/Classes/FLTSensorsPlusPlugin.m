// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "FLTSensorsPlusPlugin.h"
#import <CoreMotion/CoreMotion.h>

@implementation FLTSensorsPlusPlugin

NSMutableDictionary<NSString *, FlutterEventChannel *> *_eventChannels;
NSMutableDictionary<NSString *, NSObject<FlutterStreamHandler> *>
    *_streamHandlers;
BOOL _isCleanUp = NO;

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
  _eventChannels = [NSMutableDictionary dictionary];
  _streamHandlers = [NSMutableDictionary dictionary];

  FLTAccelerometerStreamHandlerPlus *accelerometerStreamHandler =
      [[FLTAccelerometerStreamHandlerPlus alloc] init];
  NSString *accelerometerStreamHandlerName =
      @"dev.fluttercommunity.plus/sensors/accelerometer";
  FlutterEventChannel *accelerometerChannel =
      [FlutterEventChannel eventChannelWithName:accelerometerStreamHandlerName
                                binaryMessenger:[registrar messenger]];
  [accelerometerChannel setStreamHandler:accelerometerStreamHandler];
  [_eventChannels setObject:accelerometerChannel
                     forKey:accelerometerStreamHandlerName];
  [_streamHandlers setObject:accelerometerStreamHandler
                      forKey:accelerometerStreamHandlerName];

  FLTUserAccelStreamHandlerPlus *userAccelerometerStreamHandler =
      [[FLTUserAccelStreamHandlerPlus alloc] init];
  NSString *userAccelerometerStreamHandlerName =
      @"dev.fluttercommunity.plus/sensors/user_accel";
  FlutterEventChannel *userAccelerometerChannel = [FlutterEventChannel
      eventChannelWithName:userAccelerometerStreamHandlerName
           binaryMessenger:[registrar messenger]];
  [userAccelerometerChannel setStreamHandler:userAccelerometerStreamHandler];
  [_eventChannels setObject:userAccelerometerChannel
                     forKey:userAccelerometerStreamHandlerName];
  [_streamHandlers setObject:userAccelerometerStreamHandler
                      forKey:accelerometerStreamHandlerName];

  FLTGyroscopeStreamHandlerPlus *gyroscopeStreamHandler =
      [[FLTGyroscopeStreamHandlerPlus alloc] init];
  NSString *gyroscopeStreamHandlerName =
      @"dev.fluttercommunity.plus/sensors/gyroscope";
  FlutterEventChannel *gyroscopeChannel =
      [FlutterEventChannel eventChannelWithName:gyroscopeStreamHandlerName
                                binaryMessenger:[registrar messenger]];
  [gyroscopeChannel setStreamHandler:gyroscopeStreamHandler];
  [_eventChannels setObject:gyroscopeChannel forKey:gyroscopeStreamHandlerName];
  [_streamHandlers setObject:gyroscopeStreamHandler
                      forKey:accelerometerStreamHandlerName];

  FLTMagnetometerStreamHandlerPlus *magnetometerStreamHandler =
      [[FLTMagnetometerStreamHandlerPlus alloc] init];
  NSString *magnetometerStreamHandlerName =
      @"dev.fluttercommunity.plus/sensors/magnetometer";
  FlutterEventChannel *magnetometerChannel =
      [FlutterEventChannel eventChannelWithName:magnetometerStreamHandlerName
                                binaryMessenger:[registrar messenger]];
  [magnetometerChannel setStreamHandler:magnetometerStreamHandler];
  [_eventChannels setObject:magnetometerChannel
                     forKey:magnetometerStreamHandlerName];
  [_streamHandlers setObject:magnetometerStreamHandler
                      forKey:accelerometerStreamHandlerName];

  _isCleanUp = NO;
}

- (void)detachFromEngineForRegistrar:
    (NSObject<FlutterPluginRegistrar> *)registrar {
  _cleanUp();
}

static void _cleanUp() {
  _isCleanUp = YES;
  for (FlutterEventChannel *channel in _eventChannels.allValues) {
    [channel setStreamHandler:nil];
  }
  [_eventChannels removeAllObjects];
  for (NSObject<FlutterStreamHandler> *handler in _streamHandlers.allValues) {
    [handler onCancelWithArguments:nil];
  }
  [_streamHandlers removeAllObjects];
}

@end

const double GRAVITY = 9.8;
CMMotionManager *_motionManager;

void _initMotionManager(void) {
  if (!_motionManager) {
    _motionManager = [[CMMotionManager alloc] init];
  }
}

static void sendTriplet(Float64 x, Float64 y, Float64 z,
                        FlutterEventSink sink) {
  if (_isCleanUp) {
    return;
  }
  // Even after [detachFromEngineForRegistrar] some events may still be received
  // and fired until fully detached.
  @try {
    NSMutableData *event = [NSMutableData dataWithCapacity:3 * sizeof(Float64)];
    [event appendBytes:&x length:sizeof(Float64)];
    [event appendBytes:&y length:sizeof(Float64)];
    [event appendBytes:&z length:sizeof(Float64)];

    sink([FlutterStandardTypedData typedDataWithFloat64:event]);
  } @catch (NSException *e) {
    NSLog(@"Error: %@ %@", e, [e userInfo]);
  } @finally {
  }
}

@implementation FLTAccelerometerStreamHandlerPlus

- (FlutterError *)onListenWithArguments:(id)arguments
                              eventSink:(FlutterEventSink)eventSink {
  _initMotionManager();
  switch (_motionManager.isAccelerometerAvailable) {
  case true:
    [_motionManager
        startAccelerometerUpdatesToQueue:[[NSOperationQueue alloc] init]
                             withHandler:^(
                                 CMAccelerometerData *accelerometerData,
                                 NSError *error) {
                               CMAcceleration acceleration =
                                   accelerometerData.acceleration;
                               // Multiply by gravity, and adjust sign values to
                               // align with Android.
                               if (_isCleanUp) {
                                 return;
                               }
                               sendTriplet(-acceleration.x * GRAVITY,
                                           -acceleration.y * GRAVITY,
                                           -acceleration.z * GRAVITY,
                                           eventSink);
                             }];
    break;
  default:
    eventSink([FlutterError errorWithCode:@"INVALID_SENSOR"
                                  message:@"Sensor Not Found"
                                  details:@"It seems that your device doesn't "
                                          @"support Accelerometer Sensor"]);
    break;
  }
  return nil;
}

- (FlutterError *)onCancelWithArguments:(id)arguments {
  switch (_motionManager.isAccelerometerAvailable) {
  case true:
    [_motionManager stopAccelerometerUpdates];
    break;
  default:
    break;
  }
  return nil;
}

- (void)dealloc {
  _cleanUp();
}

@end

@implementation FLTUserAccelStreamHandlerPlus

- (FlutterError *)onListenWithArguments:(id)arguments
                              eventSink:(FlutterEventSink)eventSink {
  _initMotionManager();
  switch (_motionManager.isDeviceMotionAvailable) {
  case true: // todo error code here
    [_motionManager
        startDeviceMotionUpdatesToQueue:[[NSOperationQueue alloc] init]
                            withHandler:^(CMDeviceMotion *data,
                                          NSError *error) {
                              CMAcceleration acceleration =
                                  data.userAcceleration;
                              // Multiply by gravity, and adjust sign values to
                              // align with Android.
                              if (_isCleanUp) {
                                return;
                              }
                              sendTriplet(-acceleration.x * GRAVITY,
                                          -acceleration.y * GRAVITY,
                                          -acceleration.z * GRAVITY, eventSink);
                            }];
    break;
  default:

    eventSink([FlutterError errorWithCode:@"INVALID_SENSOR"
                                  message:@"Sensor Not Found"
                                  details:@"It seems that your device doesn't "
                                          @"support UserAccelerometer Sensor"]);
    break;
  }
  return nil;
}

- (FlutterError *)onCancelWithArguments:(id)arguments {
  switch (_motionManager.isDeviceMotionAvailable) {
  case true:
    [_motionManager stopDeviceMotionUpdates];
    break;
  default:
    break;
  }
  return nil;
}

- (void)dealloc {
  _cleanUp();
}

@end

@implementation FLTGyroscopeStreamHandlerPlus

- (FlutterError *)onListenWithArguments:(id)arguments
                              eventSink:(FlutterEventSink)eventSink {
  _initMotionManager();
  switch (_motionManager.isGyroAvailable) {
  case true: // todo error code here
    [_motionManager
        startGyroUpdatesToQueue:[[NSOperationQueue alloc] init]
                    withHandler:^(CMGyroData *gyroData, NSError *error) {
                      CMRotationRate rotationRate = gyroData.rotationRate;
                      if (_isCleanUp) {
                        return;
                      }
                      sendTriplet(rotationRate.x, rotationRate.y,
                                  rotationRate.z, eventSink);
                    }];
    break;
  default:

    eventSink([FlutterError errorWithCode:@"INVALID_SENSOR"
                                  message:@"Sensor Not Found"
                                  details:@"It seems that your device doesn't "
                                          @"support Gyroscope Sensor"]);
    break;
  }
  return nil;
}

- (FlutterError *)onCancelWithArguments:(id)arguments {
  switch (_motionManager.isGyroAvailable) {
  case true:
    [_motionManager stopGyroUpdates];
    break;
  default:
    break;
  }
  return nil;
}

- (void)dealloc {
  _cleanUp();
}

@end

@implementation FLTMagnetometerStreamHandlerPlus

- (FlutterError *)onListenWithArguments:(id)arguments
                              eventSink:(FlutterEventSink)eventSink {
  _initMotionManager();
  // Allow iOS to present calibration interaction.
  _motionManager.showsDeviceMovementDisplay = YES;
  switch (_motionManager.isMagnetometerAvailable) {
  case true: // todo error code here
    [_motionManager
        startDeviceMotionUpdatesUsingReferenceFrame:
            // https://developer.apple.com/documentation/coremotion/cmattitudereferenceframe?language=objc
            // "Using this reference frame may require device movement to
            // calibrate the magnetometer," which is desired to ensure the
            // DeviceMotion actually has updated, calibrated geomagnetic data.
            CMAttitudeReferenceFrameXMagneticNorthZVertical
                                            toQueue:[[NSOperationQueue alloc]
                                                        init]
                                        withHandler:^(
                                            CMDeviceMotion *motionData,
                                            NSError *error) {
                                          // The `magneticField` is a
                                          // CMCalibratedMagneticField.
                                          CMMagneticField b =
                                              motionData.magneticField.field;
                                          if (_isCleanUp) {
                                            return;
                                          }
                                          sendTriplet(b.x, b.y, b.z, eventSink);
                                        }];
    break;
  default:
    eventSink([FlutterError errorWithCode:@"INVALID_SENSOR"
                                  message:@"Sensor Not Found"
                                  details:@"It seems that your device doesn't "
                                          @"support Magnetometer Sensor"]);
    break;
  }
  return nil;
}

- (FlutterError *)onCancelWithArguments:(id)arguments {
  switch (_motionManager.magnetometerAvailable) {
  case true:
    [_motionManager stopDeviceMotionUpdates];
    break;
  default:
    break;
  }
  return nil;
}

- (void)dealloc {
  _cleanUp();
}

@end
