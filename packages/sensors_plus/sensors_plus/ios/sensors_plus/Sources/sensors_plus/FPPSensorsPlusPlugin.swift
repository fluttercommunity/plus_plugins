// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import Flutter

public class FPPSensorsPlusPlugin: NSObject, FlutterPlugin {
    private var methodChannel: FlutterMethodChannel?
    private var eventChannels: [String: FlutterEventChannel] = [:]
    private var streamHandlers: [String: MotionStreamHandler] = [:]

    public static func register(with registrar: FlutterPluginRegistrar) {
        let instance = FPPSensorsPlusPlugin()
        instance.setUpChannels(registrar: registrar)
        registrar.publish(instance)
    }

    public func detachFromEngine(for registrar: FlutterPluginRegistrar) {
        cleanUp()
    }

    private func setUpChannels(registrar: FlutterPluginRegistrar) {
        let sensorConfigurations: [(String, MotionStreamHandler)] = [
            ("dev.fluttercommunity.plus/sensors/accelerometer", FPPAccelerometerStreamHandlerPlus()),
            ("dev.fluttercommunity.plus/sensors/user_accel", FPPUserAccelStreamHandlerPlus()),
            ("dev.fluttercommunity.plus/sensors/gyroscope", FPPGyroscopeStreamHandlerPlus()),
            ("dev.fluttercommunity.plus/sensors/magnetometer", FPPMagnetometerStreamHandlerPlus()),
            ("dev.fluttercommunity.plus/sensors/barometer", FPPBarometerStreamHandlerPlus()),
        ]

        for (name, handler) in sensorConfigurations {
            let channel = FlutterEventChannel(name: name, binaryMessenger: registrar.messenger())
            channel.setStreamHandler(handler)
            eventChannels[name] = channel
            streamHandlers[name] = handler
        }

        methodChannel = FlutterMethodChannel(
            name: "dev.fluttercommunity.plus/sensors/method",
            binaryMessenger: registrar.messenger()
        )
        methodChannel?.setMethodCallHandler { [weak self] call, result in
            guard let self, let handler = self.handler(for: call.method) else {
                result(FlutterMethodNotImplemented)
                return
            }
            handler.samplingPeriod = call.arguments as! Int
            result(nil)
        }
    }

    private func handler(for method: String) -> MotionStreamHandler? {
        let names = [
            "setAccelerationSamplingPeriod": "dev.fluttercommunity.plus/sensors/accelerometer",
            "setUserAccelerometerSamplingPeriod": "dev.fluttercommunity.plus/sensors/user_accel",
            "setGyroscopeSamplingPeriod": "dev.fluttercommunity.plus/sensors/gyroscope",
            "setMagnetometerSamplingPeriod": "dev.fluttercommunity.plus/sensors/magnetometer",
            "setBarometerSamplingPeriod": "dev.fluttercommunity.plus/sensors/barometer",
        ]
        return names[method].flatMap { streamHandlers[$0] }
    }

    private func cleanUp() {
        methodChannel?.setMethodCallHandler(nil)
        methodChannel = nil
        for handler in streamHandlers.values {
            handler.onCancel(withArguments: nil)
        }
        for channel in eventChannels.values {
            channel.setStreamHandler(nil)
        }
        streamHandlers.removeAll()
        eventChannels.removeAll()
    }
}
