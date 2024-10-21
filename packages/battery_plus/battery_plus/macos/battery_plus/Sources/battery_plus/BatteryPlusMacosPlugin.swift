import Cocoa
import FlutterMacOS
import IOKit.ps

public class BatteryPlusMacosPlugin: NSObject, FlutterPlugin {
    private var chargingHandler: BatteryPlusChargingHandler

    init(chargingHandler: BatteryPlusChargingHandler) {
        self.chargingHandler = chargingHandler
        super.init()
    }

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "dev.fluttercommunity.plus/battery", binaryMessenger: registrar.messenger)

        let eventChannel = FlutterEventChannel(name: "dev.fluttercommunity.plus/charging", binaryMessenger: registrar.messenger)

        let chargingHandler = BatteryPlusChargingHandler()

        let instance = BatteryPlusMacosPlugin(chargingHandler: chargingHandler)
        registrar.addMethodCallDelegate(instance, channel: channel)

        eventChannel.setStreamHandler(chargingHandler)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getBatteryLevel":
            handleGetBatteryLevelMethodCall(result)
        case "getBatteryState":
            handleGetBatteryStateMethodCall(result)
        case "isInBatterySaveMode":
            handleIsBatterySaveMode(result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func handleGetBatteryLevelMethodCall(_ result: FlutterResult) {
        let level = getBatteryLevel()
        if (level != -1) {
            result(level)
        } else {
            result("UNAVAILABLE")
        }

    }

    private func getBatteryLevel()-> Int {
        let powerSourceSnapshot = IOPSCopyPowerSourcesInfo().takeRetainedValue()
        let sources = IOPSCopyPowerSourcesList(powerSourceSnapshot).takeRetainedValue() as Array
        if sources.isEmpty {
            return -1
        }
        let description = IOPSGetPowerSourceDescription(powerSourceSnapshot, sources[0]).takeUnretainedValue() as! [String: AnyObject]
        if let currentCapacity = description[kIOPSCurrentCapacityKey] as? Int {
            return currentCapacity;
        }
        return -1
    }

    private func handleGetBatteryStateMethodCall(_ result: FlutterResult) {
        let state = self.chargingHandler.getBatteryStatus()
        result(state);
    }

    private func handleIsBatterySaveMode(_ result: FlutterResult) {
        if #available(macOS 12.0, *) {
            result(ProcessInfo.processInfo.isLowPowerModeEnabled)
        } else {
            // Low Power Mode is not supported on macOS versions prior to 12.0
            result(false)
        }
    }
}
