import Cocoa
import FlutterMacOS
import IOKit.ps

public class BatteryPlusMacosPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "dev.fluttercommunity.plus/battery", binaryMessenger: registrar.messenger)
        
        let eventChannel = FlutterEventChannel(name: "dev.fluttercommunity.plus/charging", binaryMessenger: registrar.messenger)
        
        let instance = BatteryPlusMacosPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        
        eventChannel.setStreamHandler(BatteryPlusChargingHandler())
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getBatteryLevel":
            handleGetBatteryMethodCall(result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func handleGetBatteryMethodCall(_ result: FlutterResult){
        let level = getBatteryLevel()
        if(level != -1){
            result(level)
            
        } else {
            result("UNAVAILABLE")
        }
        
    }
    
    private func getBatteryLevel()-> Int {
        let powerSourceSnapshot = IOPSCopyPowerSourcesInfo().takeRetainedValue()
        let sources = IOPSCopyPowerSourcesList(powerSourceSnapshot).takeRetainedValue() as Array
        let description = IOPSGetPowerSourceDescription(powerSourceSnapshot, sources[0]).takeUnretainedValue() as! [String: AnyObject]
        if let currentCapacity = description[kIOPSCurrentCapacityKey] as? Int {
            return currentCapacity;
        }
        return -1
    }
}
