// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "FLTSensorsPlusPlugin.h"
#import <CoreMotion/CoreMotion.h>

@implementation FLTSensorsPlusPlugin

NSMutableDictionary<NSString *, FlutterEventChannel *> *_eventChannels;
NSMutableDictionary<NSString *, NSObject<FlutterStreamHandler> *> *_streamHandlers;


+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
    //alloc channels names
    _eventChannels = [NSMutableDictionary dictionary];
    _streamHandlers = [NSMutableDictionary dictionary];
    
    //Accelerometer init
    //
    FLTAccelerometerStreamHandlerPlus *accelerometerStreamHandler =
    [[FLTAccelerometerStreamHandlerPlus alloc] init];
    NSString *accelerometerStreamHandlerName =
    @"dev.fluttercommunity.plus/sensors/accelerometer";
    FlutterEventChannel *accelerometerChannel = [FlutterEventChannel
                                                 eventChannelWithName:accelerometerStreamHandlerName
                                                 binaryMessenger:[registrar messenger]];
    [accelerometerChannel setStreamHandler:accelerometerStreamHandler];
    [_eventChannels setObject:accelerometerChannel forKey:accelerometerStreamHandlerName];
    [_streamHandlers setObject:accelerometerStreamHandler forKey:accelerometerStreamHandlerName];
    
    FLTUserAccelStreamHandlerPlus *userAccelerometerStreamHandler =
    [[FLTUserAccelStreamHandlerPlus alloc] init];
    NSString *userAccelerometerStreamHandlerName =
    @"dev.fluttercommunity.plus/sensors/user_accel";
    FlutterEventChannel *userAccelerometerChannel = [FlutterEventChannel
                                                     eventChannelWithName:userAccelerometerStreamHandlerName
                                                     binaryMessenger:[registrar messenger]];
    [userAccelerometerChannel setStreamHandler:userAccelerometerStreamHandler];
    [_eventChannels setObject:userAccelerometerChannel forKey:userAccelerometerStreamHandlerName];
    [_streamHandlers setObject:userAccelerometerStreamHandler forKey:accelerometerStreamHandlerName];
    
    //Gyroscopee init
    //
    FLTGyroscopeStreamHandlerPlus *gyroscopeStreamHandler =
    [[FLTGyroscopeStreamHandlerPlus alloc] init];
    NSString *gyroscopeStreamHandlerName =
    @"dev.fluttercommunity.plus/sensors/gyroscope";
    FlutterEventChannel *gyroscopeChannel = [FlutterEventChannel
                                             eventChannelWithName:gyroscopeStreamHandlerName
                                             binaryMessenger:[registrar messenger]];
    [gyroscopeChannel setStreamHandler:gyroscopeStreamHandler];
    [_eventChannels setObject:gyroscopeChannel forKey:gyroscopeStreamHandlerName];
    [_streamHandlers setObject:gyroscopeStreamHandler forKey:accelerometerStreamHandlerName];
    
    //Magnerometer init
    //
    FLTMagnetometerStreamHandlerPlus *magnetometerStreamHandler =
    [[FLTMagnetometerStreamHandlerPlus alloc] init];
    NSString *magnetometerStreamHandlerName =
    @"dev.fluttercommunity.plus/sensors/magnetometer";
    FlutterEventChannel *magnetometerChannel = [FlutterEventChannel
                                                eventChannelWithName:magnetometerStreamHandlerName
                                                binaryMessenger:[registrar messenger]];
    [magnetometerChannel setStreamHandler:magnetometerStreamHandler];
    [_eventChannels setObject:magnetometerChannel forKey:magnetometerStreamHandlerName];
    [_streamHandlers setObject:magnetometerStreamHandler forKey:accelerometerStreamHandlerName];
    
}

- (void)detachFromEngineForRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar{
    _cleanUp();
}

static void _cleanUp(){
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

void _initMotionManager() {
    if (!_motionManager) {
        _motionManager = [[CMMotionManager alloc] init];
    }
}

static void sendTriplet(Float64 x, Float64 y, Float64 z,
                        FlutterEventSink sink) {
    //even if we removed all with [detachFromEngineForRegistrar] we stull can receive and fire some events
    //from sensors til deataching
    @try {
        NSMutableData *event = [NSMutableData dataWithCapacity:3 * sizeof(Float64)];
        [event appendBytes:&x length:sizeof(Float64)];
        [event appendBytes:&y length:sizeof(Float64)];
        [event appendBytes:&z length:sizeof(Float64)];
        
        sink([FlutterStandardTypedData typedDataWithFloat64:event]);
    }
    @catch (NSException * e) {
        NSLog(@"Error: %@ %@", e, [e userInfo]);
    }
    @finally {}
}

@implementation FLTAccelerometerStreamHandlerPlus

- (FlutterError *)onListenWithArguments:(id)arguments
                              eventSink:(FlutterEventSink)eventSink {
    _initMotionManager();
    [_motionManager
     startAccelerometerUpdatesToQueue:[[NSOperationQueue alloc] init]
     withHandler:^(CMAccelerometerData *accelerometerData,
                   NSError *error) {
        CMAcceleration acceleration =
        accelerometerData.acceleration;
        // Multiply by gravity, and adjust sign values to
        // align with Android.
        sendTriplet(-acceleration.x * GRAVITY,
                    -acceleration.y * GRAVITY,
                    -acceleration.z * GRAVITY, eventSink);
    }];
    return nil;
}

- (FlutterError *)onCancelWithArguments:(id)arguments {
    [_motionManager stopAccelerometerUpdates];
    return nil;
}

- (void)dealloc{
    _cleanUp();
}

@end

@implementation FLTUserAccelStreamHandlerPlus

- (FlutterError *)onListenWithArguments:(id)arguments
                              eventSink:(FlutterEventSink)eventSink {
    _initMotionManager();
    [_motionManager
     startDeviceMotionUpdatesToQueue:[[NSOperationQueue alloc] init]
     withHandler:^(CMDeviceMotion *data, NSError *error) {
        CMAcceleration acceleration = data.userAcceleration;
        // Multiply by gravity, and adjust sign values to
        // align with Android.
        sendTriplet(-acceleration.x * GRAVITY,
                    -acceleration.y * GRAVITY,
                    -acceleration.z * GRAVITY, eventSink);
    }];
    return nil;
}

- (FlutterError *)onCancelWithArguments:(id)arguments {
    [_motionManager stopDeviceMotionUpdates];
    return nil;
}

- (void)dealloc{
    _cleanUp();
}

@end

@implementation FLTGyroscopeStreamHandlerPlus

- (FlutterError *)onListenWithArguments:(id)arguments
                              eventSink:(FlutterEventSink)eventSink {
    _initMotionManager();
    [_motionManager
     startGyroUpdatesToQueue:[[NSOperationQueue alloc] init]
     withHandler:^(CMGyroData *gyroData, NSError *error) {
        CMRotationRate rotationRate = gyroData.rotationRate;
        sendTriplet(rotationRate.x, rotationRate.y, rotationRate.z,
                    eventSink);
    }];
    return nil;
}

- (FlutterError *)onCancelWithArguments:(id)arguments {
    [_motionManager stopGyroUpdates];
    return nil;
}

- (void)dealloc{
    _cleanUp();
}

@end

@implementation FLTMagnetometerStreamHandlerPlus

- (FlutterError *)onListenWithArguments:(id)arguments
                              eventSink:(FlutterEventSink)eventSink {
    _initMotionManager();
    [_motionManager
     startMagnetometerUpdatesToQueue:[[NSOperationQueue alloc] init]
     withHandler:^(CMMagnetometerData *magData,
                   NSError *error) {
        CMMagneticField magneticField =
        magData.magneticField;
        sendTriplet(magneticField.x, magneticField.y,
                    magneticField.z, eventSink);
    }];
    return nil;
}

- (FlutterError *)onCancelWithArguments:(id)arguments {
    [_motionManager stopMagnetometerUpdates];
    return nil;
}

- (void)dealloc{
    _cleanUp();
}

@end
