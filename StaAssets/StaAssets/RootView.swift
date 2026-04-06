//
//  ContentView.swift
//  StaAssets
//
//  Created by Nupur on 06/04/26.
//

import SwiftUI

struct RootView: View {
    
    @State private var isLoggedIn = false
    
    var body: some View {
        if isLoggedIn {
            MainTabView()
        } else {
            AuthView(isLoggedIn: $isLoggedIn)
        }
    }
}

//#Preview {
//    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//}
