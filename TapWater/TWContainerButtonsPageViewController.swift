import UIKit
import Async

class TWContainerButtonsPageViewController: UIPageViewController {
    // MARK: Child View Controller Management Vars
    var buttonViewControllers: [TWContainerButtonViewController] {
        get {
            return _buttonViewControllers
        } set (newValue) {
            _buttonViewControllers = newValue
            transitionToInitialViewController()
        }
    }
    var _buttonViewControllers: [TWContainerButtonViewController] = [
        TWContainerButtonViewController.loadFromStoryboard()
    ]
    var currentIndex = 0
    
    // MARK: Deinitialization
    deinit {
        unsubscribeFromNotifications()
    }
}

// MARK: View Lifecycle

extension TWContainerButtonsPageViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        transitionToInitialViewController()
        loadContainers()
        subscribeToContainerNotifications()
    }
}

// MARK: Container loading

extension TWContainerButtonsPageViewController {
    func loadContainers() {
        TWContainer.fetchAll { (containers) -> Void in
            Async.main {
                var controllers = [TWContainerButtonViewController]()
                for container in containers {
                    controllers.append(
                        TWContainerButtonViewController.loadForContainer(container)
                    )
                }
                self.buttonViewControllers = controllers
            }
        }
    }
}

// MARK: Notifications

extension TWContainerButtonsPageViewController {
    private func subscribeToContainerNotifications() {
        NSNotificationCenter.defaultCenter().addObserverForName(
            TWContainer.CreatedNotificationName,
            object: nil,
            queue: nil,
            usingBlock: recievedContianersChangedNotification
        )
        NSNotificationCenter.defaultCenter().addObserverForName(
            TWContainer.RemovedNotificationName,
            object: nil,
            queue: nil,
            usingBlock: recievedContianersChangedNotification
        )
    }
    
    private func unsubscribeFromNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    private func recievedContianersChangedNotification(
        notification: NSNotification
    ) {
        if  notification.object is TWContainer {
            loadContainers()
        }
    }
}

// MARK: View Controller Transition Management

extension TWContainerButtonsPageViewController {
    func transitionToInitialViewController() {
        if buttonViewControllers.count > 0 {
            currentIndex = 0
            setViewControllers(
                [buttonViewControllers[0]],
                direction: .Reverse,
                animated: false,
                completion: nil
            )
        } else {
            setViewControllers([UIViewController()],
                direction: .Forward,
                animated: false,
                completion: nil
            )
        }
    }
    
    func updateCurrentIndex() {
        if let currentButtonViewController = viewControllers?.first as? TWContainerButtonViewController
        {
            currentIndex = buttonViewControllers.indexOf(currentButtonViewController) ?? 0
        }
    }
}

// MARK: UIPageViewControllerDataSource

extension TWContainerButtonsPageViewController: UIPageViewControllerDataSource {
    func pageViewController(
        pageViewController: UIPageViewController,
        viewControllerAfterViewController viewController: UIViewController
    ) -> UIViewController? {
        if currentIndex < buttonViewControllers.count - 1 {
            return buttonViewControllers[currentIndex + 1]
        }
        return nil
    }
    
    func pageViewController(
        pageViewController: UIPageViewController,
        viewControllerBeforeViewController viewController: UIViewController
    ) -> UIViewController? {
        if currentIndex > 0 {
            return buttonViewControllers[currentIndex - 1]
        }
        return nil
    }
    
    func presentationCountForPageViewController(
        pageViewController: UIPageViewController
    ) -> Int {
        return buttonViewControllers.count
    }
    
    func presentationIndexForPageViewController(
        pageViewController: UIPageViewController
    ) -> Int {
        return currentIndex
    }
}

// MARK: UIPageViewControllerDelegate

extension TWContainerButtonsPageViewController: UIPageViewControllerDelegate {
    func pageViewController(
        pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        updateCurrentIndex()
    }
}
