import UIKit

class TWContainerTableViewCell: UITableViewCell {
    // Data
    var container: TWContainer? {
        get {
            return _container
        } set (newValue) {
            _container = newValue
            respondToContainerUpdate()
        }
    }
    var _container: TWContainer?
    
    // Outlets
    @IBOutlet var containerNameLabel: UILabel!
    @IBOutlet var containerVolumeLabel: UILabel!
}

// MARK: Respond to ivar updates

extension TWContainerTableViewCell {
    func respondToContainerUpdate() {
        if let container = container {
            containerNameLabel.text = container.name
            containerVolumeLabel.text = "\(container.volume)oz"
        } else {
            containerNameLabel.text = ""
            containerVolumeLabel.text = ""
        }
    }
}