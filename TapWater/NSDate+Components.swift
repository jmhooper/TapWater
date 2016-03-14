import Foundation

extension NSDate {
    func month() -> Int {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.componentsInTimeZone(
            NSTimeZone.localTimeZone(),
            fromDate: self
        )
        return components.month
    }
    
    func year() -> Int {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.componentsInTimeZone(
            NSTimeZone.localTimeZone(),
            fromDate: self
        )
        return components.year
    }
    
    func day() -> Int {
        let calendar = NSCalendar(
            identifier: NSCalendarIdentifierGregorian
        )!
        let components = calendar.componentsInTimeZone(
            NSTimeZone.localTimeZone(),
            fromDate: self
        )
        return components.day
    }
    
    static func fromComponents(year year: Int, month: Int, day: Int) -> NSDate {
        let components = NSDateComponents()
        components.calendar = NSCalendar(
            identifier: NSCalendarIdentifierGregorian
        )
        components.year = year
        components.month = month
        components.day = day
        components.hour = 12 + NSTimeZone.localTimeZone().secondsFromGMT / 3600
        return components.date!
    }
    
    func isToday() -> Bool {
        let today = NSDate()
        return year() == today.year()
            && month() == today.month()
            && day() == today.day()
    }
    
    func isYesterday() -> Bool {
        let today = NSDate()
        return year() == today.year()
            && month() == today.month()
            && day() == today.day() - 1
    }
}