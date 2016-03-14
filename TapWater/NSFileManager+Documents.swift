import Foundation

extension NSFileManager {
    class func documentsDirectoryURL() -> NSURL {
        return defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).last!
    }
}