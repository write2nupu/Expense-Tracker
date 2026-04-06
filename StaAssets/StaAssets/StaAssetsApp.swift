//
//  StaAssetsApp.swift
//  StaAssets
//
//  Created by Nupur on 06/04/26.
//

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
