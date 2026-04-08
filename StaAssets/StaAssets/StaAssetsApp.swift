
import SwiftUI
import CoreData

@main
struct StaAssetsApp: App {
    
    let persistenceController = StorageManager.shared
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(\.managedObjectContext,
                              persistenceController.container.viewContext)
        }
    }
}
