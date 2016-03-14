import UIKit

class TWTableViewSectionHeader: UIView {
    // Constants
    
    let NIB_NAME = "TWTableViewSectionHeader"
    
    // IBOutlets
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var detailLabel: UILabel!
    
    // Inititialization
    
    init() {
        super.init(frame: CGRectZero)
        loadFromNib()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

// MARK: Initialization

extension TWTableViewSectionHeader {
    private func loadFromNib() {
        let view = NSBundle.mainBundle().loadNibNamed(
            NIB_NAME,
            owner: self,
            options: nil
        ).last as! UIView
        view.frame = frame
        addSubview(view)
    }
}
