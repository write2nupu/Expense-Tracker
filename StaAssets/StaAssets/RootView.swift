
import SwiftUI
import Combine

struct RootView: View {
    
    @State private var isLoggedIn = false
    @StateObject private var userVM = UserViewModel()
    
    var body: some View {
        if isLoggedIn {
            MainTabView()
                .environmentObject(userVM)
        } else {
            AuthView(isLoggedIn: $isLoggedIn)
                .environmentObject(userVM)
        }
    }
}
