// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import Flutter

var _eventChannels: [String: FlutterEventChannel] = [:]
var _streamHandlers: [String: MotionStreamHandler] = [:]
var _isCleanUp = false

public class FPPSensorsPlusPlugin: NSObject, FlutterPlugin {

    public static func register(with registrar: FlutterPluginRegistrar) {
        let accelerometerStreamHandler = FPPAccelerometerStreamHandlerPlus()
        let accelerometerStreamHandlerName = "dev.fluttercommunity.plus/sensors/accelerometer"
        let accelerometerChannel = FlutterEventChannel(
                name: accelerometerStreamHandlerName,
                binaryMessenger: registrar.messenger()
        )
        accelerometerChannel.setStreamHandler(accelerometerStreamHandler)
        _eventChannels[accelerometerStreamHandlerName] = accelerometerChannel
        _streamHandlers[accelerometerStreamHandlerName] = accelerometerStreamHandler

        let userAccelerometerStreamHandler = FPPUserAccelStreamHandlerPlus()
        let userAccelerometerStreamHandlerName = "dev.fluttercommunity.plus/sensors/user_accel"
        let userAccelerometerChannel = FlutterEventChannel(
                name: userAccelerometerStreamHandlerName,
                binaryMessenger: registrar.messenger()
        )
        userAccelerometerChannel.setStreamHandler(userAccelerometerStreamHandler)
        _eventChannels[userAccelerometerStreamHandlerName] = userAccelerometerChannel
        _streamHandlers[userAccelerometerStreamHandlerName] = userAccelerometerStreamHandler

        let gyroscopeStreamHandler = FPPGyroscopeStreamHandlerPlus()
        let gyroscopeStreamHandlerName = "dev.fluttercommunity.plus/sensors/gyroscope"
        let gyroscopeChannel = FlutterEventChannel(
                name: gyroscopeStreamHandlerName,
                binaryMessenger: registrar.messenger()
        )
        gyroscopeChannel.setStreamHandler(gyroscopeStreamHandler)
        _eventChannels[gyroscopeStreamHandlerName] = gyroscopeChannel
        _streamHandlers[gyroscopeStreamHandlerName] = gyroscopeStreamHandler

        let magnetometerStreamHandler = FPPMagnetometerStreamHandlerPlus()
        let magnetometerStreamHandlerName = "dev.fluttercommunity.plus/sensors/magnetometer"
        let magnetometerChannel = FlutterEventChannel(
                name: magnetometerStreamHandlerName,
                binaryMessenger: registrar.messenger()
        )
        magnetometerChannel.setStreamHandler(magnetometerStreamHandler)
        _eventChannels[magnetometerStreamHandlerName] = magnetometerChannel
        _streamHandlers[magnetometerStreamHandlerName] = magnetometerStreamHandler

        let methodChannel = FlutterMethodChannel(
                name: "dev.fluttercommunity.plus/sensors/method",
                binaryMessenger: registrar.messenger()
        )
        methodChannel.setMethodCallHandler { call, result in
            let streamHandler: MotionStreamHandler!;
            switch (call.method) {
            case "setAccelerationSamplingPeriod":
                streamHandler = _streamHandlers[accelerometerStreamHandlerName]
            case "setUserAccelerometerSamplingPeriod":
                streamHandler = _streamHandlers[userAccelerometerStreamHandlerName]
            case "setGyroscopeSamplingPeriod":
                streamHandler = _streamHandlers[gyroscopeStreamHandlerName]
            case "setMagnetometerSamplingPeriod":
                streamHandler = _streamHandlers[magnetometerStreamHandlerName]
            default:
                return result(FlutterMethodNotImplemented)
            }
            streamHandler.samplingPeriod = call.arguments as! Int
            result(nil)
        }

        _isCleanUp = false
    }

    func detachFromEngineForRegistrar(registrar: NSObject!) {
        FPPSensorsPlusPlugin._cleanUp()
    }

    static func _cleanUp() {
        _isCleanUp = true
        for channel in _eventChannels.values {
            channel.setStreamHandler(nil)
        }
        _eventChannels.removeAll()
        for handler in _streamHandlers.values {
            handler.onCancel(withArguments: nil)
        }
        _streamHandlers.removeAll()
    }
}
