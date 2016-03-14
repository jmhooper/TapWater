import Foundation

extension NSDate {
    func formatWithTimeStyle(
        timeStyle: NSDateFormatterStyle,
        dateStyle: NSDateFormatterStyle)
    -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = timeStyle
        dateFormatter.dateStyle = dateStyle
        return dateFormatter.stringFromDate(self)
    }
}