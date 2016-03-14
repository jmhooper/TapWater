import Foundation
import CoreData

/**
 The model that represents a drink
*/
class TWDrink: TWManagedObject {
    // NSManaged Properties
    @NSManaged var drinkDate: NSDate?
    @NSManaged var container: TWContainer?
    
    // Notification Names
    static let CreatedNotificationName = "com.JonathanHooper.TapWater.Notification.Drink.Created"
    static let RemovedNotificationName = "com.JonathanHooper.TapWater.Notification.Drink.Removed"
}

// MARK: Fetch Methods

extension TWDrink {
    class func fetchAll(completion: (drinks: [TWDrink]) -> Void) {
        fetchAllWithPredicate(
            nil,
            sortDescriptors: [createdAtSortDescriptor()]
        ) { objects in
            if let drinks = objects as? [TWDrink] {
                completion(drinks: drinks)
            }
        }
    }
    
    private class func createdAtSortDescriptor() -> NSSortDescriptor {
        return NSSortDescriptor(key: "createdAt", ascending: false)
    }
}

// MARK: Create methods

extension TWDrink {
    class func create(
        container container: TWContainer,
        completion: (drink: TWDrink) -> Void
    ) {
        let context = NSManagedObjectContext.sharedContext()
        insert { (object) -> Void in
            if let drink = object as? TWDrink {
                drink.container = container
                drink.drinkDate = NSDate()
                try! context.save()
                drink.sendCreatedNotification()
                completion(drink: drink)
            }
        }
    }
    
    class func create(
        container container: TWContainer
    ) {
        create(container: container, completion: {_ in })
    }
}

// MARK: Removal methods

extension TWDrink {
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

extension TWDrink {
    private func sendCreatedNotification() {
        NSNotificationCenter.defaultCenter().postNotificationName(
            TWDrink.CreatedNotificationName,
            object: self
        )
    }
    
    private func sendRemovedNotification() {
        NSNotificationCenter.defaultCenter().postNotificationName(
            TWDrink.RemovedNotificationName,
            object: self
        )
    }
}