import Foundation

public struct SystemUUID {
    
    public static func getSystemUUID() -> String? {
        let dev = IOServiceMatching("IOPlatformExpertDevice")
        
        var platformExpert: io_service_t
        #if MACOS12_OR_LATER
            print("Running on macOS 12 or newer")
            platformExpert = IOServiceGetMatchingService(kIOMainPortDefault, dev)
        #else
            print("Running on an older version of macOS")
            platformExpert = IOServiceGetMatchingService(kIOMasterPortDefault, dev)
        #endif
        
        let serialNumberAsCFString = IORegistryEntryCreateCFProperty(platformExpert, kIOPlatformUUIDKey as CFString, kCFAllocatorDefault, 0)
        IOObjectRelease(platformExpert)
        let ser: CFTypeRef? = serialNumberAsCFString?.takeUnretainedValue()
        if let result = ser as? String {
            return result
        }
        return nil
    }
}
