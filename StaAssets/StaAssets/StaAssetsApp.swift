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
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
