import Foundation

public struct SystemUUID {
    
    public static func getSystemUUID() -> String? {
        let dev = IOServiceMatching("IOPlatformExpertDevice")
        if #available(macOS 12, *) {
            let platformExpert: io_service_t = IOServiceGetMatchingService(kIOMainPortDefault, dev)
        } else {
            let platformExpert: io_service_t = IOServiceGetMatchingService(kIOMasterPortDefault, dev)
        }
        let serialNumberAsCFString = IORegistryEntryCreateCFProperty(platformExpert, kIOPlatformUUIDKey as CFString, kCFAllocatorDefault, 0)
        IOObjectRelease(platformExpert)
        let ser: CFTypeRef? = serialNumberAsCFString?.takeUnretainedValue()
        if let result = ser as? String {
            return result
        }
        return nil
    }
}