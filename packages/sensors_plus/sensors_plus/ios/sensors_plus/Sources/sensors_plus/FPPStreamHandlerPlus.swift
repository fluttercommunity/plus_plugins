// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import CoreMotion
import Flutter
import Foundation

let GRAVITY = 9.81
let timestampMicroAtBoot = (Date().timeIntervalSince1970 - ProcessInfo.processInfo.systemUptime) * 1000000

public protocol MotionStreamHandler: NSObjectProtocol, FlutterStreamHandler {
    var samplingPeriod: Int { get set }
}

private class FPPStreamHandlerBase: NSObject, MotionStreamHandler {
    var samplingPeriod = 200000
    var eventSink: FlutterEventSink?

    func onListen(withArguments arguments: Any?, eventSink sink: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = sink
        return nil
    }

    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        eventSink = nil
        return nil
    }

    func sendError(_ error: Error, to sink: @escaping FlutterEventSink) {
        DispatchQueue.main.async { [weak self] in
            guard self?.eventSink != nil else { return }
            sink(FlutterError(code: "UNAVAILABLE", message: error.localizedDescription, details: nil))
        }
    }

    func sendValues(_ values: [Double], timestamp: TimeInterval, to sink: @escaping FlutterEventSink) {
        DispatchQueue.main.async { [weak self] in
            guard self?.eventSink != nil else { return }
            let payload = values + [timestampMicroAtBoot + timestamp * 1000000]
            payload.withUnsafeBufferPointer { buffer in
                sink(FlutterStandardTypedData(float64: Data(buffer: buffer)))
            }
        }
    }
}

class FPPAccelerometerStreamHandlerPlus: FPPStreamHandlerBase {
    private let motionManager = CMMotionManager()

    override var samplingPeriod: Int {
        didSet { motionManager.accelerometerUpdateInterval = Double(samplingPeriod) * 0.000001 }
    }

    override func onListen(withArguments arguments: Any?, eventSink sink: @escaping FlutterEventSink) -> FlutterError? {
        super.onListen(withArguments: arguments, eventSink: sink)
        motionManager.accelerometerUpdateInterval = Double(samplingPeriod) * 0.000001
        motionManager.startAccelerometerUpdates(to: OperationQueue()) { [weak self] data, error in
            guard let self, let sink = self.eventSink else { return }
            if let error { self.sendError(error, to: sink); return }
            guard let data else { return }
            let acceleration = data.acceleration
            self.sendValues([-acceleration.x * GRAVITY, -acceleration.y * GRAVITY, -acceleration.z * GRAVITY], timestamp: data.timestamp, to: sink)
        }
        return nil
    }

    override func onCancel(withArguments arguments: Any?) -> FlutterError? {
        motionManager.stopAccelerometerUpdates()
        return super.onCancel(withArguments: arguments)
    }
}

class FPPUserAccelStreamHandlerPlus: FPPStreamHandlerBase {
    private let motionManager = CMMotionManager()

    override var samplingPeriod: Int {
        didSet { motionManager.deviceMotionUpdateInterval = Double(samplingPeriod) * 0.000001 }
    }

    override func onListen(withArguments arguments: Any?, eventSink sink: @escaping FlutterEventSink) -> FlutterError? {
        super.onListen(withArguments: arguments, eventSink: sink)
        motionManager.deviceMotionUpdateInterval = Double(samplingPeriod) * 0.000001
        motionManager.startDeviceMotionUpdates(to: OperationQueue()) { [weak self] data, error in
            guard let self, let sink = self.eventSink else { return }
            if let error { self.sendError(error, to: sink); return }
            guard let data else { return }
            let acceleration = data.userAcceleration
            self.sendValues([-acceleration.x * GRAVITY, -acceleration.y * GRAVITY, -acceleration.z * GRAVITY], timestamp: data.timestamp, to: sink)
        }
        return nil
    }

    override func onCancel(withArguments arguments: Any?) -> FlutterError? {
        motionManager.stopDeviceMotionUpdates()
        return super.onCancel(withArguments: arguments)
    }
}

class FPPGyroscopeStreamHandlerPlus: FPPStreamHandlerBase {
    private let motionManager = CMMotionManager()

    override var samplingPeriod: Int {
        didSet { motionManager.gyroUpdateInterval = Double(samplingPeriod) * 0.000001 }
    }

    override func onListen(withArguments arguments: Any?, eventSink sink: @escaping FlutterEventSink) -> FlutterError? {
        super.onListen(withArguments: arguments, eventSink: sink)
        motionManager.gyroUpdateInterval = Double(samplingPeriod) * 0.000001
        motionManager.startGyroUpdates(to: OperationQueue()) { [weak self] data, error in
            guard let self, let sink = self.eventSink else { return }
            if let error { self.sendError(error, to: sink); return }
            guard let data else { return }
            let rotation = data.rotationRate
            self.sendValues([rotation.x, rotation.y, rotation.z], timestamp: data.timestamp, to: sink)
        }
        return nil
    }

    override func onCancel(withArguments arguments: Any?) -> FlutterError? {
        motionManager.stopGyroUpdates()
        return super.onCancel(withArguments: arguments)
    }
}

class FPPMagnetometerStreamHandlerPlus: FPPStreamHandlerBase {
    private let motionManager = CMMotionManager()

    override var samplingPeriod: Int {
        didSet { motionManager.magnetometerUpdateInterval = Double(samplingPeriod) * 0.000001 }
    }

    override func onListen(withArguments arguments: Any?, eventSink sink: @escaping FlutterEventSink) -> FlutterError? {
        super.onListen(withArguments: arguments, eventSink: sink)
        motionManager.magnetometerUpdateInterval = Double(samplingPeriod) * 0.000001
        motionManager.startMagnetometerUpdates(to: OperationQueue()) { [weak self] data, error in
            guard let self, let sink = self.eventSink else { return }
            if let error { self.sendError(error, to: sink); return }
            guard let data else { return }
            let field = data.magneticField
            self.sendValues([field.x, field.y, field.z], timestamp: data.timestamp, to: sink)
        }
        return nil
    }

    override func onCancel(withArguments arguments: Any?) -> FlutterError? {
        motionManager.stopMagnetometerUpdates()
        return super.onCancel(withArguments: arguments)
    }
}

class FPPBarometerStreamHandlerPlus: FPPStreamHandlerBase {
    private let altimeter = CMAltimeter()

    override func onListen(withArguments arguments: Any?, eventSink sink: @escaping FlutterEventSink) -> FlutterError? {
        super.onListen(withArguments: arguments, eventSink: sink)
        guard CMAltimeter.isRelativeAltitudeAvailable() else {
            return FlutterError(code: "UNAVAILABLE", message: "Barometer is not available on this device", details: nil)
        }
        altimeter.startRelativeAltitudeUpdates(to: OperationQueue()) { [weak self] data, error in
            guard let self, let sink = self.eventSink else { return }
            if let error { self.sendError(error, to: sink); return }
            guard let data else { return }
            self.sendValues([data.pressure.doubleValue * 10.0], timestamp: data.timestamp, to: sink)
        }
        return nil
    }

    override func onCancel(withArguments arguments: Any?) -> FlutterError? {
        altimeter.stopRelativeAltitudeUpdates()
        return super.onCancel(withArguments: arguments)
    }
}
