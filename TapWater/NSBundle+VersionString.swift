
import Foundation

public extension NSBundle {
    public func versionString() -> String {
        let majorVersion = infoDictionary!["CFBundleShortVersionString"] as! String
        let minorVersion = infoDictionary!["CFBundleVersion"] as! String
        return "\(majorVersion) (\(minorVersion))"
    }
}