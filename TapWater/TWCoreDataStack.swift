import Foundation
import CoreData

private var TWSharedManagedObjectModel: NSManagedObjectModel?

extension NSManagedObjectModel {
    class func sharedModel() -> NSManagedObjectModel {
        if let model = TWSharedManagedObjectModel {
            return model
        }
        let url = NSBundle.mainBundle().URLForResource(
            "TapWater",
            withExtension: "momd"
        )!
        TWSharedManagedObjectModel = NSManagedObjectModel(contentsOfURL: url)
        return TWSharedManagedObjectModel!
    }
}

private var TWSharedPersistentStoreCoordinator: NSPersistentStoreCoordinator?

extension NSPersistentStoreCoordinator {
    class func sharedCoordinator() -> NSPersistentStoreCoordinator {
        if let coordinator = TWSharedPersistentStoreCoordinator {
            return coordinator
        }
        TWSharedPersistentStoreCoordinator = NSPersistentStoreCoordinator(
            managedObjectModel: NSManagedObjectModel.sharedModel()
        )
        do {
            try TWSharedPersistentStoreCoordinator!.addPersistentSore()
        } catch _ {
            resetApplicationStore()
            try! TWSharedPersistentStoreCoordinator!.addPersistentSore()
        }
        return TWSharedPersistentStoreCoordinator!
    }
    
    private func addPersistentSore() throws {
        try addPersistentStoreWithType(
            NSSQLiteStoreType,
            configuration: nil,
            URL: NSPersistentStoreCoordinator.applicationStoreURL(),
            options: nil
        )
    }
    
    private class func applicationStoreURL() -> NSURL {
        return NSFileManager.documentsDirectoryURL().URLByAppendingPathComponent(
            "TapWater.sqlite"
        )
    }
    
    private class func resetApplicationStore() {
        try! NSFileManager.defaultManager().removeItemAtURL(
            applicationStoreURL()
        )
    }
}

private var TWSharedManagedObjectContext: NSManagedObjectContext?

extension NSManagedObjectContext {
    class func sharedContext() -> NSManagedObjectContext {
        if let context = TWSharedManagedObjectContext {
            return context
        }
        TWSharedManagedObjectContext = NSManagedObjectContext(
            concurrencyType: .PrivateQueueConcurrencyType
        )
        TWSharedManagedObjectContext!.persistentStoreCoordinator = NSPersistentStoreCoordinator.sharedCoordinator()
        return TWSharedManagedObjectContext!
    }
}