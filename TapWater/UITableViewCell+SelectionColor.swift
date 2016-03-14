import UIKit

extension UITableViewCell {
    func setSelectionColor(color: UIColor) {
        let view = UIView()
        view.backgroundColor = color
        selectedBackgroundView = view
    }
}