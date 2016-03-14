import UIKit
import QuartzCore

class TWContainerButtonViewController: UIViewController {
    // Outlets
    @IBOutlet var newDrinkButton: UIButton!
    @IBOutlet var containerVolumeLabel: UILabel!
    @IBOutlet var containerNameLabel: UILabel!
    @IBOutlet var containerActivityIndicator: UIActivityIndicatorView!
    
    // Container
    var container: TWContainer? {
        get {
            return _container
        } set (newValue){
            _container = newValue
            updateContainerViews()
        }
    }
    private var _container: TWContainer?
}

// MARK: View Lifecycle

extension TWContainerButtonViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        styleView()
        updateContainerViews()
    }
}

// MARK: Stylization

extension TWContainerButtonViewController {
    private func styleView() {
        newDrinkButton.layer.cornerRadius = newDrinkButton.frame.height / 2.0
        newDrinkButton.layer.shadowColor = UIColor.blackColor().CGColor
        newDrinkButton.layer.shadowOpacity = 0.3
        newDrinkButton.layer.shadowOffset = CGSizeMake(0.5, 0.5)
        newDrinkButton.layer.shadowRadius = 2.0
        
        containerVolumeLabel.layer.shadowOpacity = 0.15
        containerVolumeLabel.layer.shadowOffset = CGSizeMake(0.5, 0.5)
        containerNameLabel.layer.shadowRadius = 0.25
        
        containerNameLabel.layer.shadowOpacity = 0.15
        containerNameLabel.layer.shadowOffset = CGSizeMake(0.5, 0.5)
        containerNameLabel.layer.shadowRadius = 0.25
    }
}

// MARK: Respond to ivar updates

extension TWContainerButtonViewController {
    private func updateContainerViews() {
        guard containerViewsLoaded() else {
            return
        }
        if let container = container,
            containerName = container.name
        {
            containerVolumeLabel.text = "\(container.volume)oz"
            containerNameLabel.text = containerName
            containerActivityIndicator.stopAnimating()
        } else {
            containerVolumeLabel.text = ""
            containerNameLabel.text = ""
            containerActivityIndicator.startAnimating()
        }
    }
    
    private func containerViewsLoaded() -> Bool {
        return containerNameLabel != nil
            && containerVolumeLabel != nil
            && containerActivityIndicator != nil
    }
}

// MARK: Action

extension TWContainerButtonViewController {
    @IBAction func newDrinkButtonPressed() {
        if let container = container {
            TWDrink.create(container: container) { drink in
                TWAudioPlayer.playChime()
            }
        }
    }
}

// MARK: Load from storyboard

extension TWContainerButtonViewController {
    private static let STORYBOARD_IDENTIFIER = "TWContainerButtonViewController"
    
    class func loadFromStoryboard() -> TWContainerButtonViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewControllerWithIdentifier(
            STORYBOARD_IDENTIFIER
        ) as! TWContainerButtonViewController
    }
    
    class func loadForContainer(
        container: TWContainer?
    ) -> TWContainerButtonViewController {
        let controller = loadFromStoryboard()
        controller.container = container
        return controller
    }
}