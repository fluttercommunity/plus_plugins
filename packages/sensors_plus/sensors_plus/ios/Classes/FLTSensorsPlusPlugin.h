// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import <Flutter/Flutter.h>

@interface FLTSensorsPlusPlugin : NSObject <FlutterPlugin>
@end

@interface FLTAccelerometerStreamHandlerPlus : NSObject <FlutterStreamHandler>
@property(readonly, nonatomic, getter=isAccelerometerAvailable) BOOL accelerometerAvailable;
@end

@interface FLTUserAccelStreamHandlerPlus : NSObject <FlutterStreamHandler>
@property(readonly, nonatomic, getter=isDeviceMotionAvailable) BOOL deviceMotionAvailable;
@end

@interface FLTGyroscopeStreamHandlerPlus : NSObject <FlutterStreamHandler>
@property(readonly, nonatomic, getter=isGyroAvailable) BOOL gyroAvailable;
@end

@interface FLTMagnetometerStreamHandlerPlus : NSObject <FlutterStreamHandler>
@property(readonly, nonatomic, getter=isMagnetometerAvailable) BOOL magnetometerAvailable;
@end
