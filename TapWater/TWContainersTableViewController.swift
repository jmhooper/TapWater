import UIKit
import Async

class TWContainersTableViewController: UITableViewController {
    // Contants
    let CONATINER_TABLE_VIEW_CEKK_IDENTIFIER = "TWContainerTableViewCell"
    
    // Data
    var containers = [TWContainer]()
    
    // Deinit
    deinit {
        unsubscribeFromNotifications()
    }
}

// MARK: View Lifecycle

extension TWContainersTableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        styleView()
        loadContainerData()
        subscribeToContainerNotifications()
    }
}

// MARK: Stylization

extension TWContainersTableViewController {
    private func styleView() {
        tableView.tableFooterView = UIView(frame: CGRectZero)
    }
}

// MARK: Container Data

extension TWContainersTableViewController {
    func loadContainerData() {
        TWContainer.fetchAll { containers in
            self.containers = containers
            self.tableView.reloadData()
        }
    }
    
    private func indexPathForContainer(container: TWContainer) -> NSIndexPath? {
        if let containerIndex = containers.indexOf(container) {
            return NSIndexPath(forRow: containerIndex, inSection: 0)
        } else {
            return nil
        }
    }
}

// MARK: Container Insertion

extension TWContainersTableViewController {
    private func containerWasCreated(container: TWContainer) {
        insertContainerData(container)
        if let indexPath = indexPathForContainer(container) {
            tableView.insertRowsAtIndexPaths(
                [indexPath],
                withRowAnimation: .Top
            )
        }
    }
    
    private func insertContainerData(container: TWContainer) {
        containers = ([container] + containers).sort({
            if $0.volume == $1.volume {
                return $0.name < $1.name
            } else {
                return $0.volume < $1.volume
            }
        })
    }
}

// MARK: Container Removal

extension TWContainersTableViewController {
    func removeContainerWithAction(
        action: UITableViewRowAction,
        atIndexPath indexPath: NSIndexPath
    ) {
        let container = containers[indexPath.row]
        container.remove()
    }
    
    private func containerWasRemoved(container: TWContainer) {
        if let indexPath = indexPathForContainer(container) {
            containers.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths(
                [indexPath],
                withRowAnimation: .Left
            )
        }
    }
}

// MARK: Notifications

extension TWContainersTableViewController {
    private func subscribeToContainerNotifications() {
        NSNotificationCenter.defaultCenter().addObserverForName(
            TWContainer.CreatedNotificationName,
            object: nil,
            queue: nil,
            usingBlock: recievedContianersCreatedNotification
        )
        NSNotificationCenter.defaultCenter().addObserverForName(
            TWContainer.RemovedNotificationName,
            object: nil,
            queue: nil,
            usingBlock: recievedContianersRemovedNotification
        )
    }
    
    private func unsubscribeFromNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    private func recievedContianersCreatedNotification(
        notification: NSNotification
    ) {
        if let container = notification.object as? TWContainer {
            Async.main {
                self.containerWasCreated(container)
            }
        }
    }
    
    private func recievedContianersRemovedNotification(
        notification: NSNotification
    ) {
        if let container = notification.object as? TWContainer {
            Async.main {
                self.containerWasRemoved(container)
            }
        }
    }
}

// MARK: UITableViewDataSource & UITableViewDelegate

extension TWContainersTableViewController {
    override func tableView(
        tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return containers.count
    }
    
    override func tableView(
        tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(
            CONATINER_TABLE_VIEW_CEKK_IDENTIFIER,
            forIndexPath: indexPath
        ) as! TWContainerTableViewCell
        cell.container = containers[indexPath.row]
        return cell
    }
    
    override func tableView(
        tableView: UITableView,
        editActionsForRowAtIndexPath indexPath: NSIndexPath
    ) -> [UITableViewRowAction]? {
        let action = UITableViewRowAction(
            style: .Default,
            title: "Delete",
            handler: removeContainerWithAction
        )
        action.backgroundColor = UIColor.tapWaterRedColor()
        return [action]
    }
}