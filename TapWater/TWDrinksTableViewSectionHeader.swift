import UIKit

class TWDrinkTableViewSectionHeader: TWTableViewSectionHeader {}

// MARK: Initialization

extension TWDrinkTableViewSectionHeader {
    convenience init(date: NSDate, volume: Int) {
        self.init()
        titleLabel.text = formattedDateLabelStringFromDate(date)
        detailLabel.text = formattedVolumeLabelStringFromVolume(volume)
    }
    
    private func formattedDateLabelStringFromDate(date: NSDate) -> String {
        if date.isToday() {
            return "Today"
        } else if date.isYesterday() {
            return "Yesterday"
        } else {
            return date.formatWithTimeStyle(
                .NoStyle,
                dateStyle: .MediumStyle
            )
        }
    }
    
    private func formattedVolumeLabelStringFromVolume(volume: Int) -> String {
        return "\(volume)oz"
    }
}
