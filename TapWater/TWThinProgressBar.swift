import UIKit

@IBDesignable class TWThinProgressBar: UIView {
    var progress: Float {
        get {
            return _progress
        } set (newValue) {
            _progress = newValue
            setNeedsDisplay()
        }
    }
    var _progress: Float = 0.0
}

// MARK: Drawing code

extension TWThinProgressBar {
    override func drawRect(rect: CGRect) {
        drawBackgroundInRect(rect)
        drawProgressInRect(rect)
    }
    
    private func drawBackgroundInRect(rect: CGRect) {
        let path = UIBezierPath(rect: rect)
        UIColor.tapWaterYellowColor().setFill()
        path.fill()
    }
    
    private func drawProgressInRect(rect: CGRect) {
        let width = rect.width * CGFloat(progress)
        let progressRect = CGRectMake(0, 0, width, rect.height)
        let path = UIBezierPath(rect: progressRect)
        UIColor.tapWaterBlueColor().setFill()
        path.fill()
    }
}
