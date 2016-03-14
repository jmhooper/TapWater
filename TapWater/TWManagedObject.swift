import Foundation
import CoreData

class TWManagedObject: NSManagedObject {
    @NSManaged var uid: String?
    @NSManaged var createdAt: NSDate?
    @NSManaged var updatedAt: NSDate?
    @NSManaged var removed: Bool
}

// MARK: Computed Properties

extension TWManagedObject {
    override func awakeFromInsert() {
        willChangeValueForKey("uid")
        setPrimitiveValue(NSUUID().UUIDString, forKey: "uid")
        didChangeValueForKey("uid")
    }
    
    override func willSave() {
        super.willSave()
        setCreatedAtTimestamp()
        setUpdatedAtTimestamp()
    }
    
    private func setCreatedAtTimestamp() {
        if createdAt == nil {
            createdAt = NSDate()
        }
    }
    
    private func setUpdatedAtTimestamp() {
        if shouldSetUpdatedAt() {
            updatedAt = NSDate()
        }
    }
    
    private func shouldSetUpdatedAt() -> Bool {
        return updatedAt == nil || NSDate().timeIntervalSinceDate(updatedAt!) > 1.0
    }
}

// MARK: NSEntityDescription helpers

extension TWManagedObject {
    class func entityName() -> String {
        return NSStringFromClass(self).stringByReplacingOccurrencesOfString(
            "TapWater.",
            withString: ""
        )
    }
}

// MARK: Inserting records

extension TWManagedObject {
    class func insert(completion: (object: TWManagedObject) -> Void) {
        let context = NSManagedObjectContext.sharedContext()
        context.performBlock {
            completion(
                object: NSEntityDescription.insertNewObjectForEntityForName(
                    entityName(),
                    inManagedObjectContext: context
                ) as! TWManagedObject
            )
        }
    }
}

// MARK: Querying records

extension TWManagedObject {
    class func fetchAllWithPredicate(
        predicate: NSPredicate?,
        sortDescriptors: [NSSortDescriptor]?,
        completion: (objects: [TWManagedObject]) -> Void
    ) {
        let context = NSManagedObjectContext.sharedContext()
        context.performBlock {
            let fetchRequest = NSFetchRequest(entityName: entityName())
            if let predicate = predicate {
                fetchRequest.predicate = addNotRemovedToPredicate(predicate)
            } else {
                fetchRequest.predicate = NSPredicate(format: "removed == false")
            }
            fetchRequest.fetchLimit = 200
            if let sortDescriptors = sortDescriptors {
                fetchRequest.sortDescriptors = sortDescriptors
            }
            completion(
                objects: try! context.executeFetchRequest(
                    fetchRequest
                ) as! [TWManagedObject]
            )
        }
    }
    
    class func fetchFirstWithPredicate(
        predicate: NSPredicate?,
        sortDescriptors: [NSSortDescriptor]?,
        completion: (object: TWManagedObject?) -> Void
    ) {
         fetchAllWithPredicate(
            predicate,
            sortDescriptors: sortDescriptors
        ) { (objects) in
            completion(object: objects.first)
        }
    }
    
    class func find(
        uid: String,
        completion: (object: TWManagedObject?) -> Void
    ) {
        let context = NSManagedObjectContext.sharedContext()
        context.performBlock { () -> Void in
            let fetchRequest = NSFetchRequest(entityName: entityName())
            fetchRequest.predicate = NSPredicate(
                format: "uid = %@",
                argumentArray: [uid]
            )
            let results = try! context.executeFetchRequest(
                fetchRequest
            ) as! [TWManagedObject]
            completion(object: results.first)
        }
    }
    
    private class func addNotRemovedToPredicate(
        predicate: NSPredicate
    ) -> NSPredicate {
        return NSPredicate(
            format: "removed == false && (%@)",
            argumentArray: [predicate.predicateFormat]
        )
    }
}

// MARK: Removing records

extension TWManagedObject {
    func remove(completion completion: () -> Void) {
        let context = NSManagedObjectContext.sharedContext()
        context.performBlock {
            self.removed = true
            try! context.save()
            completion()
        }
    }
}