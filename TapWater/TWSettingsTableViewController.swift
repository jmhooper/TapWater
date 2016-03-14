import UIKit

class TWSettingsTableViewController: UITableViewController {
    // Contants
    
    let SETTINGS_TABLE_VIEW_CELL_IDENTIFIER = "TWSettingsTableViewCell"
    let GOAL_SETTINGS_TABLE_VIEW_CELL_IDENTIFIER = "TWGoalSettingsTableViewCell"
    
    let ABOUT_VIEW_CONTROLLER_SEGUE_IDENTIFIER = "TWAboutViewController"
    let CONTAINERS_TABLE_VIEW_CONTROLLER_SEGUE_IDENTIFIER = "TWContainersTableViewController"
    
    // Data
    
    let sectionTitles = [
        "About",
        "User",
    ]
    let settings = [
        [Setting.About, Setting.Contact],
        [Setting.Goal, Setting.Containers],
    ]
}

// MARK: View Lifecycle

extension TWSettingsTableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        styleView()
        addDismissGoalKeyboardGestureRecognizer()
    }
}

// MARK: Stylization

extension TWSettingsTableViewController {
    private func styleView() {
        tableView.tableFooterView = UIView(frame: CGRectZero)
    }
}

// MARK: Settings

extension TWSettingsTableViewController {
    enum Setting {
        case About, Contact, Goal, Containers
        
        func title() -> String {
            switch self {
            case .About:
                return "About"
            case .Contact:
                return "Contact"
            case .Goal:
                return "Goal"
            case .Containers:
                return "Containers"
            }
        }
        
        func detail() -> String? {
            switch self {
            case .Goal:
                return "\(TWUser.currentUser().volumeGoal)oz"
            default:
                return nil
            }
        }
    }
    
    func settingForIndexPath(indexPath: NSIndexPath) -> Setting {
        return settings[indexPath.section][indexPath.row]
    }
}

// MARK: About Setting

extension TWSettingsTableViewController {
    func aboutSettingSelected() {
        performSegueWithIdentifier(
            ABOUT_VIEW_CONTROLLER_SEGUE_IDENTIFIER,
            sender: nil
        )
    }
}

// MARK: Contact Setting

extension TWSettingsTableViewController {
    func contactSettingSelected() {
        let controller = contactActionSheetController()
        presentViewController(
            controller,
            animated: true,
            completion: {
                controller.view.tintColor = UIColor.tapWaterBlueColor()
            }
        )
    }
    
    private func contactActionSheetController() -> UIAlertController {
        let controller = UIAlertController(
            title: "Contact",
            message: nil,
            preferredStyle: .ActionSheet
        )
        controller.addAction(contactActionSheetTwitterAction())
        controller.addAction(contactActionSheetEmailAction())
        controller.addAction(contactActionSheetCancelAction(controller))
        controller.view.tintColor = UIColor.tapWaterBlueColor()
        return controller
    }
    
    private func contactActionSheetTwitterAction() -> UIAlertAction {
        return UIAlertAction(
            title: "Twitter",
            style: .Default,
            handler: { _ in
                let url = NSURL(
                    string: "https://twitter.com/jonathan_hooper"
                )!
                UIApplication.sharedApplication().openURL(url)
            }
        )
    }
    
    private func contactActionSheetEmailAction() -> UIAlertAction {
        return UIAlertAction(
            title: "Email",
            style: .Default,
            handler: { _ in
                let url = NSURL(
                    string: "mailto:jon@jonathanhooper.net?subject=TapWater"
                )!
                UIApplication.sharedApplication().openURL(url)
            }
        )
    }
    
    private func contactActionSheetCancelAction(
        controller: UIAlertController
    ) -> UIAlertAction {
        return UIAlertAction(
            title: "Cancel",
            style: .Cancel,
            handler: { _ in
                controller.dismissViewControllerAnimated(true, completion: nil)
            }
        )
    }
}

// MARK: Goal Setting

extension TWSettingsTableViewController {
    func goalSettingSelected() {
        goalSettingCell()?.beginEditingTextField()
    }
    
    func dismissGoalKeyboard() {
        goalSettingCell()?.endEditingTextField()
    }
    
    private func goalSettingCell() -> TWSettingsTableViewCell? {
        let goalIndexPath = NSIndexPath(forRow: 0, inSection: 1)
        return tableView.cellForRowAtIndexPath(
            goalIndexPath
        ) as? TWSettingsTableViewCell
    }
    
    private func addDismissGoalKeyboardGestureRecognizer() {
        let recognizer = UITapGestureRecognizer(target: self, action: "dismissGoalKeyboard")
        recognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(recognizer)
    }
}

// MARK: Containers Settings

extension TWSettingsTableViewController {
    func conatainersSettingSelected() {
        performSegueWithIdentifier(
            CONTAINERS_TABLE_VIEW_CONTROLLER_SEGUE_IDENTIFIER,
            sender: nil
        )
    }
}

// MARK: UITableViewDataSource & UITableViewDelegate

extension TWSettingsTableViewController {
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return settings.count
    }
    
    override func tableView(
        tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return settings[section].count
    }
    
    override func tableView(
        tableView: UITableView,
        heightForHeaderInSection section: Int
    ) -> CGFloat {
        return 23.0
    }
    
    override func tableView(
        tableView: UITableView,
        viewForHeaderInSection section: Int
    ) -> UIView? {
        let view = TWTableViewSectionHeader()
        view.titleLabel.text = sectionTitles[section]
        return view
    }
    
    override func tableView(
        tableView: UITableView,
        didSelectRowAtIndexPath indexPath: NSIndexPath
    ) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        switch settingForIndexPath(indexPath) {
        case .About:
            aboutSettingSelected()
        case .Contact:
            contactSettingSelected()
        case .Goal:
            goalSettingSelected()
        case .Containers:
            conatainersSettingSelected()
        }
    }
    
    override func tableView(
        tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath
    ) -> UITableViewCell {
        let setting = settingForIndexPath(indexPath)
        let cell = tableView.dequeueReusableCellWithIdentifier(
            tableViewCellIdentifierForSetting(setting),
            forIndexPath: indexPath
        ) as! TWSettingsTableViewCell
        cell.setting = setting
        cell.setSelectionColor(UIColor.tapWaterBlueColor())
        return cell
    }
    
    private func tableViewCellIdentifierForSetting(setting: Setting) -> String {
        if setting == .Goal {
            return GOAL_SETTINGS_TABLE_VIEW_CELL_IDENTIFIER
        } else {
            return SETTINGS_TABLE_VIEW_CELL_IDENTIFIER
        }
    }
}

