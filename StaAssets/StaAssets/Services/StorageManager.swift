
import CoreData

final class StorageManager {
    
    static let shared = StorageManager()
    
    let container: NSPersistentContainer
    
    private init() {
        container = NSPersistentContainer(name: "StaAssets")
        
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Core Data failed: \(error.localizedDescription)")
            }
        }
    }
    
    var context: NSManagedObjectContext {
        container.viewContext
    }
}
