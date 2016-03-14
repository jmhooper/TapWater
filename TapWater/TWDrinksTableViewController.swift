import UIKit
import Async

class TWDrinksTableViewController: UITableViewController {
    // Constants
    let DRINKS_TABLE_VIEW_CELL_IDENTIFIER = "TWDrinksTableViewCell"
    
    // Drink Data
    var drinkDateCollection = TWDrinkDateCollection(drinkDates: [])
    
    // Outlets
    @IBOutlet var currentProgressLabel: UILabel!
    @IBOutlet var currentVolumeLabel: UILabel!
    @IBOutlet var volumeGoalLabel: UILabel!
    @IBOutlet var thinProgressBar: TWThinProgressBar!
    
    // Deinitialization
    deinit {
        unsubscribeFromNotifications()
    }
}

// MARK: View Lifecycle

extension TWDrinksTableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        styleView()
        subscribeToDrinksNotifications()
        loadDrinkDateCollection()
    }
}

// MARK: Stylization

extension TWDrinksTableViewController {
    private func styleView() {
        tableView.tableFooterView = UIView(frame: CGRectZero)
    }
}

// MARK: Drink Data Management

extension TWDrinksTableViewController {
    func loadDrinkDateCollection() {
        TWDrinkDateCollection.loadDrinkCollection { (collection) in
            Async.main {
                self.drinkDateCollection = collection
                self.tableView.reloadData()
                self.updateProgressViews()
            }
        }
    }
}

// MARK: Drink Creation
    
extension TWDrinksTableViewController {
    func drinkWasCreated(drink drink: TWDrink) {
        let numberOfSections = tableView.numberOfSections
        if let indexPath = drinkDateCollection.insertDrink(drink) {
            Async.main {
                if self.drinkDateCollection.drinkDates.count > numberOfSections {
                    self.insertDrinkSectionAtIndexPath(indexPath)
                } else {
                    self.insertDrinkRowAtIndexPath(indexPath)
                }
                self.updateProgressViews()
            }
        }
    }
    
    private func insertDrinkRowAtIndexPath(indexPath: NSIndexPath) {
        self.tableView.insertRowsAtIndexPaths(
            [indexPath],
            withRowAnimation: .Top
        )
    }
    
    private func insertDrinkSectionAtIndexPath(indexPath: NSIndexPath) {
        tableView.insertSections(
            NSIndexSet(index: indexPath.section),
            withRowAnimation: .Top
        )
    }
}

// MARK: Drink Removal

extension TWDrinksTableViewController {
    func removeDrinkAtIndexPath(indexPath: NSIndexPath) {
        let drink = drinkDateCollection.drinkDates[
            indexPath.section
        ].drinks[
            indexPath.row
        ]
        drink.remove()
    }
    
    func drinkWasRemoved(drink drink: TWDrink) {
        let numberOfSections = tableView.numberOfSections
        if let indexPath = drinkDateCollection.removeDrink(drink) {
            Async.main {
                if self.drinkDateCollection.drinkDates.count < numberOfSections {
                    self.removeDrinkSectionAtIndexPath(indexPath)
                } else {
                    self.removeDrinkRowAtIndexPath(indexPath)
                }
                self.updateProgressViews()
            }
        }
    }
    
    private func removeDrinkSectionAtIndexPath(indexPath: NSIndexPath) {
        tableView.deleteSections(
            NSIndexSet(index: indexPath.section),
            withRowAnimation: .Left
        )
    }
    
    private func removeDrinkRowAtIndexPath(indexPath: NSIndexPath) {
        tableView.deleteRowsAtIndexPaths(
            [indexPath],
            withRowAnimation: .Left
        )
    }
}

// MARK: Progress Data Management

extension TWDrinksTableViewController {
    private func updateProgressViews() {
        if let index = drinkDateCollection.drinkDateIndexForDate(NSDate()) {
            let drinkDate = drinkDateCollection.drinkDates[index]
            updateCurrentProgressLabelWithDrinkDate(drinkDate)
            updateCurrentVolumeLabelWithDrinkDate(drinkDate)
            updateThinProgressBarWithDrinkDate(drinkDate)
        } else {
            currentProgressLabel.text = "Current Progress: 0%"
            currentVolumeLabel.text = "Today: 0oz"
            thinProgressBar.progress = 0.0
        }
        updateVolumeGoalLabel()
    }
    
    private func updateCurrentProgressLabelWithDrinkDate(
        drinkDate: TWDrinkDate
    ) {
        let progress = 100 * drinkDate.totalVolume() / TWUser.currentUser().volumeGoal
        let formattedProgress = currentProgressNumberFormatter().stringFromNumber(
            min(progress, 100)
        )!
        currentProgressLabel.text = "Current Progress: \(formattedProgress)%"
    }
    
    private func currentProgressNumberFormatter() -> NSNumberFormatter {
        let formatter = NSNumberFormatter()
        formatter.maximumFractionDigits = 0
        return formatter
    }
    
    private func updateCurrentVolumeLabelWithDrinkDate(drinkDate: TWDrinkDate) {
        currentVolumeLabel.text = "Today: \(drinkDate.totalVolume())oz"
    }
    
    private func updateVolumeGoalLabel() {
        volumeGoalLabel.text = "Goal: \(TWUser.currentUser().volumeGoal)oz"
    }
    
    private func updateThinProgressBarWithDrinkDate(drinkDate: TWDrinkDate) {
        let progress = Float(drinkDate.totalVolume()) / Float(TWUser.currentUser().volumeGoal)
        thinProgressBar.progress = min(1.0, progress)
    }
}

// MARK: Notifications

extension TWDrinksTableViewController {
    private func subscribeToDrinksNotifications() {
        NSNotificationCenter.defaultCenter().addObserverForName(
            TWDrink.CreatedNotificationName,
            object: nil,
            queue: nil,
            usingBlock: recievedDrinkCreatedNotification
        )
        NSNotificationCenter.defaultCenter().addObserverForName(
            TWDrink.RemovedNotificationName,
            object: nil,
            queue: nil,
            usingBlock: recievedDrinkRemovedNotification
        )
        NSNotificationCenter.defaultCenter().addObserverForName(
            TWUser.VolumeGoalUpdatedNotificationName,
            object: nil,
            queue: nil,
            usingBlock: recievedCurrentUserVolumeGoalUpdateNotification
        )
    }
    
    private func unsubscribeFromNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    private func recievedDrinkCreatedNotification(
        notification: NSNotification
    ) {
        if let drink = notification.object as? TWDrink {
            self.drinkWasCreated(drink: drink)
        }
    }
    
    private func recievedDrinkRemovedNotification(
        notification: NSNotification
    ) {
        if let drink = notification.object as? TWDrink {
            self.drinkWasRemoved(drink: drink)
        }
    }
    
    private func recievedCurrentUserVolumeGoalUpdateNotification(
        notification: NSNotification
    ) {
        Async.main {
            self.updateProgressViews()
        }
    }
}

// MARK: UITableViewDataSource methods

extension TWDrinksTableViewController {
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return drinkDateCollection.drinkDates.count
    }
    
    override func tableView(
        tableView: UITableView,
        heightForHeaderInSection section: Int
    ) -> CGFloat {
        let drinkDate = drinkDateCollection.drinkDates[section]
        if drinkDate.date().isToday() {
            return 0.0
        } else {
            return 23.0
        }
    }
    
    override func tableView(
        tableView: UITableView,
        viewForHeaderInSection section: Int
    ) -> UIView? {
        let drinkDate = drinkDateCollection.drinkDates[section]
        if drinkDate.date().isToday() {
            return nil
        } else {
            return TWDrinkTableViewSectionHeader(
                date: drinkDate.date(),
                volume: drinkDate.totalVolume()
            )
        }
    }
    
    override func tableView(
        tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return drinkDateCollection.drinkDates[section].drinks.count
    }
    
    override func tableView(
        tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(
            DRINKS_TABLE_VIEW_CELL_IDENTIFIER,
            forIndexPath: indexPath
        ) as! TWDrinksTableViewCell
        cell.drink = drinkDateCollection.drinkDates[
            indexPath.section
        ].drinks[
            indexPath.row
        ]
        return cell
    }
    
    override func tableView(
        tableView: UITableView,
        canEditRowAtIndexPath indexPath: NSIndexPath
    ) -> Bool {
        return drinkDateCollection.drinkDates[
            indexPath.section
        ].date().isToday()
    }
    
    override func tableView(
        tableView: UITableView,
        editActionsForRowAtIndexPath indexPath: NSIndexPath
    ) -> [UITableViewRowAction]? {
        let action = UITableViewRowAction(
            style: .Default,
            title: "Delete",
            handler: { (action, indexPath) in
                self.removeDrinkAtIndexPath(indexPath)
            }
        )
        action.backgroundColor = UIColor.tapWaterRedColor()
        return [action]
    }
}
