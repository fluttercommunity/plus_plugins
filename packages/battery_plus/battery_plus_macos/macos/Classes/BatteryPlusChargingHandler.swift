//
//  BatteryPlusChargingHandler.swift
//  battery_plus_macos
//
//  Created by Neevash Ramdial on 08/09/2020.
//
import Foundation
import FlutterMacOS

class BatteryPlusChargingHandler: NSObject, FlutterStreamHandler {
    
    private var context: Int = 0
    
    private var source: CFRunLoopSource?
    private var runLoop: CFRunLoop?
    private var eventSink: FlutterEventSink?
    
    func onListen(withArguments arguments: Any?, eventSink event: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = event
        start()
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        stop()
        self.eventSink = nil
        return nil
    }
    
    func start() {
        // If there is an added loop, we remove it before adding a new one.
        stop()
        
        // Gets the initial battery status
        let initialStatus = getBatteryStatus()
        if let sink = self.eventSink {
            sink(initialStatus)
        }
        
        // Registers a run loop which is notified when the battery status changes
        let context = UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque())
        source = IOPSNotificationCreateRunLoopSource({ (context) in
            let _self = Unmanaged<BatteryPlusChargingHandler>.fromOpaque(UnsafeRawPointer(context!)).takeUnretainedValue()
            let status =  _self.getBatteryStatus()
            print(status)
            if let sink = _self.eventSink {
                sink(status)
            }
        }, context).takeUnretainedValue()
        
        // Adds loop to source
        runLoop = RunLoop.current.getCFRunLoop()
        CFRunLoopAddSource(runLoop, source, .defaultMode)
    }
    
    func stop() {
        guard let runLoop = runLoop, let source = source else {
            return
        }
        CFRunLoopRemoveSource(runLoop, source, .defaultMode)
    }
    
    func getBatteryStatus()-> String {
        let powerSourceSnapshot = IOPSCopyPowerSourcesInfo().takeRetainedValue()
        let sources = IOPSCopyPowerSourcesList(powerSourceSnapshot).takeRetainedValue() as [CFTypeRef]
        
        // Desktops do not have battery sources and are always charging.
        if sources.isEmpty {
            return "charging"
        }
        let description = IOPSGetPowerSourceDescription(powerSourceSnapshot, sources[0]).takeUnretainedValue() as! [String: AnyObject]
        
        if let currentCapacity = description[kIOPSCurrentCapacityKey] as? Int {
            if currentCapacity >= 95 {
                return "full"
            }
        }
        
        // Returns nil when battery is discharging
        if let isCharging = (description[kIOPSPowerSourceStateKey] as? String) {
            if isCharging == kIOPSACPowerValue {
                return "charging"
            } else if isCharging == kIOPSBatteryPowerValue {
                return "discharging"
            } else {
                return "unknown"
            }
        }
        return "UNAVAILABLE"
    }
}
