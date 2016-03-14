import Foundation
import CoreData

class TWContainer: TWManagedObject {
    // NSManaged Properties
    @NSManaged var name: String?
    @NSManaged var volume: Int64
    @NSManaged var drinks: NSSet?
    // Notification Names
    static let CreatedNotificationName = "com.JonathanHooper.TapWater.Notification.Container.Created"
    static let RemovedNotificationName = "com.JonathanHooper.TapWater.Notification.Container.Removed"
}

// MARK: Fetch Methods

extension TWContainer {
    class func fetchAll(completion: (containers: [TWContainer]) -> Void) {
        fetchAllWithPredicate(
            nil,
            sortDescriptors: [volumeSortDescriptor(), nameSortDescriptor()]
        ) { objects in
            if let containers = objects as? [TWContainer] {
                completion(containers: containers)
            }
        }
    }
    
    private class func nameSortDescriptor() -> NSSortDescriptor {
        return NSSortDescriptor(key: "name", ascending: true)
    }
    
    private class func volumeSortDescriptor() -> NSSortDescriptor {
        return NSSortDescriptor(key: "volume", ascending: true)
    }
}

// MARK: Create methods

extension TWContainer {
    class func create(
        name name: String,
        volume: Int64,
        completion: (container: TWContainer) -> Void
    ) {
        let context = NSManagedObjectContext.sharedContext()
        insert { (object) -> Void in
            if let container = object as? TWContainer {
                container.name = name
                container.volume = volume
                try! context.save()
                container.sendCreatedNotification()
                completion(container: container)
            }
        }
    }
    
    class func create(
        name name: String,
        volume: Int64
    ) {
        create(name: name, volume: volume, completion: {_ in })
    }
}

// MARK: Removal methods

extension TWContainer {
    override func remove(completion completion: () -> Void) {
        super.remove {
            self.sendRemovedNotification()
            completion()
        }
    }
    
    func remove() {
        remove(completion: {_ in })
    }
}

// MARK: Notifications

extension TWContainer {
    private func sendCreatedNotification() {
        NSNotificationCenter.defaultCenter().postNotificationName(
            TWContainer.CreatedNotificationName,
            object: self
        )
    }
    
    private func sendRemovedNotification() {
        NSNotificationCenter.defaultCenter().postNotificationName(
            TWContainer.RemovedNotificationName,
            object: self
        )
    }
}

// MARK: Initial Data

extension TWContainer {
    class func createInitialData() {
        if shouldCreateInitialData() {
            create(name: "Cup", volume: 8)
            create(name :"Bottle", volume: 16)
            create(name: "Liter", volume: 32)
            toggleInitialDataCreatedUserDefault()
        }
    }
    
    private static let INITIAL_CONTAINERS_CREATED_DEFAULT_KEY = "com.JonathanHooper.TapWater.UserDefault.InitialContainersCreated"
    
    private class func shouldCreateInitialData() -> Bool {
        return !NSUserDefaults.standardUserDefaults().boolForKey(
            INITIAL_CONTAINERS_CREATED_DEFAULT_KEY
        )
    }
    
    private class func toggleInitialDataCreatedUserDefault() {
        NSUserDefaults.standardUserDefaults().setBool(
            true,
            forKey: INITIAL_CONTAINERS_CREATED_DEFAULT_KEY
        )
        NSUserDefaults.standardUserDefaults().synchronize()
    }
}
