// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import Foundation
import Flutter
import UIKit
import CoreMotion

let GRAVITY = 9.81
var _motionManager: CMMotionManager!
var _altimeter: CMAltimeter!

public protocol MotionStreamHandler: FlutterStreamHandler {
    var samplingPeriod: Int { get set }
}

let timestampMicroAtBoot = (Date().timeIntervalSince1970 - ProcessInfo.processInfo.systemUptime) * 1000000

func _initMotionManager() {
    if (_motionManager == nil) {
        _motionManager = CMMotionManager()
        _motionManager.accelerometerUpdateInterval = 0.2
        _motionManager.deviceMotionUpdateInterval = 0.2
        _motionManager.gyroUpdateInterval = 0.2
        _motionManager.magnetometerUpdateInterval = 0.2
    }
}

func _initAltimeter() {
    if (_altimeter == nil) {
        _altimeter = CMAltimeter()
    }
}

func sendFlutter(x: Float64, y: Float64, z: Float64, timestamp: TimeInterval, sink: @escaping FlutterEventSink) {
    if _isCleanUp {
        return
    }
    // Even after [detachFromEngineForRegistrar] some events may still be received
    // and fired until fully detached.
    DispatchQueue.main.async {
        let timestampSince1970Micro = timestampMicroAtBoot + (timestamp * 1000000)
        let triplet = [x, y, z, timestampSince1970Micro]
        triplet.withUnsafeBufferPointer { buffer in
            sink(FlutterStandardTypedData.init(float64: Data(buffer: buffer)))
        }
    }
}

class FPPAccelerometerStreamHandlerPlus: NSObject, MotionStreamHandler {

    var samplingPeriod = 200000 {
        didSet {
            _initMotionManager()
            _motionManager.accelerometerUpdateInterval = Double(samplingPeriod) * 0.000001
        }
    }

    func onListen(
            withArguments arguments: Any?,
            eventSink sink: @escaping FlutterEventSink
    ) -> FlutterError? {
        _initMotionManager()
        _motionManager.startAccelerometerUpdates(to: OperationQueue()) { data, error in
            if _isCleanUp {
                return
            }
            if (error != nil) {
                sink(FlutterError.init(
                        code: "UNAVAILABLE",
                        message: error!.localizedDescription,
                        details: nil
                ))
                return
            }
            // Multiply by gravity, and adjust sign values to
            // align with Android.
            let acceleration = data!.acceleration
            sendFlutter(
                    x: -acceleration.x * GRAVITY,
                    y: -acceleration.y * GRAVITY,
                    z: -acceleration.z * GRAVITY,
                    timestamp: data!.timestamp,
                    sink: sink
            )
        }
        return nil
    }

    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        _motionManager.stopAccelerometerUpdates()
        return nil
    }

    func dealloc() {
        FPPSensorsPlusPlugin._cleanUp()
    }
}

class FPPUserAccelStreamHandlerPlus: NSObject, MotionStreamHandler {

    var samplingPeriod = 200000 {
        didSet {
            _initMotionManager()
            _motionManager.deviceMotionUpdateInterval = Double(samplingPeriod) * 0.000001
        }
    }

    func onListen(
            withArguments arguments: Any?,
            eventSink sink: @escaping FlutterEventSink
    ) -> FlutterError? {
        _initMotionManager()
        _motionManager.startDeviceMotionUpdates(to: OperationQueue()) { data, error in
            if _isCleanUp {
                return
            }
            if (error != nil) {
                sink(FlutterError.init(
                        code: "UNAVAILABLE",
                        message: error!.localizedDescription,
                        details: nil
                ))
                return
            }
            // Multiply by gravity, and adjust sign values to
            // align with Android.
            let acceleration = data!.userAcceleration
            sendFlutter(
                    x: -acceleration.x * GRAVITY,
                    y: -acceleration.y * GRAVITY,
                    z: -acceleration.z * GRAVITY,
                    timestamp: data!.timestamp,
                    sink: sink
            )
        }
        return nil
    }

    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        _motionManager.stopDeviceMotionUpdates()
        return nil
    }

    func dealloc() {
        FPPSensorsPlusPlugin._cleanUp()
    }
}

class FPPGyroscopeStreamHandlerPlus: NSObject, MotionStreamHandler {

    var samplingPeriod = 200000 {
        didSet {
            _initMotionManager()
            _motionManager.gyroUpdateInterval = Double(samplingPeriod) * 0.000001
        }
    }

    func onListen(
            withArguments arguments: Any?,
            eventSink sink: @escaping FlutterEventSink
    ) -> FlutterError? {
        _initMotionManager()
        _motionManager.startGyroUpdates(to: OperationQueue()) { data, error in
            if _isCleanUp {
                return
            }
            if (error != nil) {
                sink(FlutterError(
                        code: "UNAVAILABLE",
                        message: error!.localizedDescription,
                        details: nil
                ))
                return
            }
            let rotationRate = data!.rotationRate
            sendFlutter(
                x: rotationRate.x,
                y: rotationRate.y,
                z: rotationRate.z,
                timestamp: data!.timestamp,
                sink: sink
            )
        }
        return nil
    }

    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        _motionManager.stopGyroUpdates()
        return nil
    }

    func dealloc() {
        FPPSensorsPlusPlugin._cleanUp()
    }
}

class FPPMagnetometerStreamHandlerPlus: NSObject, MotionStreamHandler {

    var samplingPeriod = 200000 {
        didSet {
            _initMotionManager()
            _motionManager.magnetometerUpdateInterval = Double(samplingPeriod) * 0.000001
        }
    }

    func onListen(
            withArguments arguments: Any?,
            eventSink sink: @escaping FlutterEventSink
    ) -> FlutterError? {
        _initMotionManager()
        _motionManager.startMagnetometerUpdates(to: OperationQueue()) { data, error in
            if _isCleanUp {
                return
            }
            if (error != nil) {
                sink(FlutterError(
                        code: "UNAVAILABLE",
                        message: error!.localizedDescription,
                        details: nil
                ))
                return
            }
            let magneticField = data!.magneticField
            sendFlutter(
                x: magneticField.x,
                y: magneticField.y,
                z: magneticField.z,
                timestamp: data!.timestamp,
                sink: sink
            )
        }
        return nil
    }

    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        _motionManager.stopDeviceMotionUpdates()
        return nil
    }

    func dealloc() {
        FPPSensorsPlusPlugin._cleanUp()
    }
}

class FPPBarometerStreamHandlerPlus: NSObject, MotionStreamHandler {

    var samplingPeriod = 200000 {
        didSet {
            _initAltimeter()
            // Note: CMAltimeter does not provide a way to set the sampling period directly.
            // The sampling period would typically be managed by starting/stopping the updates.
        }
    }

    func onListen(
            withArguments arguments: Any?,
            eventSink sink: @escaping FlutterEventSink
    ) -> FlutterError? {
        _initAltimeter()
        if CMAltimeter.isRelativeAltitudeAvailable() {
            _altimeter.startRelativeAltitudeUpdates(to: OperationQueue()) { data, error in
                if _isCleanUp {
                    return
                }
                if (error != nil) {
                    sink(FlutterError(
                            code: "UNAVAILABLE",
                            message: error!.localizedDescription,
                            details: nil
                    ))
                    return
                }
                let pressure = data!.pressure.doubleValue * 10.0 // kPa to hPa (hectopascals)
                DispatchQueue.main.async {
                let timestampSince1970Micro = timestampMicroAtBoot + (data!.timestamp * 1000000)
                let pressureArray: [Double] = [pressure, timestampSince1970Micro]
                pressureArray.withUnsafeBufferPointer { buffer in
                    sink(FlutterStandardTypedData.init(float64: Data(buffer: buffer)))
                    }
                }
            }
        } else {
            return FlutterError(
                code: "UNAVAILABLE",
                message: "Barometer is not available on this device",
                details: nil
            )
        }
        return nil
    }

    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        _altimeter.stopRelativeAltitudeUpdates()
        return nil
    }

    func dealloc() {
        FPPSensorsPlusPlugin._cleanUp()
    }
}
