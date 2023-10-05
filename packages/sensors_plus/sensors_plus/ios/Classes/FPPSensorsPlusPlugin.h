// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import <Flutter/Flutter.h>

@interface FPPSensorsPlusPlugin : NSObject <FlutterPlugin>
@end

@interface FPPUserAccelStreamHandlerPlus : NSObject <FlutterStreamHandler>
@end

@interface FPPAccelerometerStreamHandlerPlus : NSObject <FlutterStreamHandler>
@end

@interface FPPGyroscopeStreamHandlerPlus : NSObject <FlutterStreamHandler>
@end

@interface FPPMagnetometerStreamHandlerPlus : NSObject <FlutterStreamHandler>
@end
