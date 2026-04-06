
import SwiftUI

struct AppHeaderView: View {
    
    @EnvironmentObject var vm: TransactionViewModel
    @State private var showNotifications = false
    
    var showFilter: Bool = false
    var onFilterTap: (() -> Void)?
    
    var body: some View {
        
        ZStack(alignment: .topTrailing) {
            
            HStack {
                
                HStack(spacing: 10) {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.primary.opacity(0.1))
                        .frame(width: 35, height: 35)
                        .overlay(Text("P"))
                    
                    Text("StaAssets")
                        .font(.headline)
                }
                
                Spacer()
                
                HStack(spacing: 16) {
                    
                    Menu {
                        
                        if vm.notifications.isEmpty {
                            Text("No notifications")
                        } else {
                            
                            ForEach(vm.notifications.prefix(3), id: \.self) { note in
                                Text(note)
                            }
                            
                            if vm.notifications.count > 3 {
                                Divider()
                                
                                Button("Show All") {
                                    // navigate later
                                }
                            }
                        }
                        
                    } label: {
                        ZStack {
                            Image(systemName: "bell")
                            
                            if !vm.notifications.isEmpty {
                                Circle()
                                    .fill(Color.red)
                                    .frame(width: 8, height: 8)
                                    .offset(x: 6, y: -6)
                            }
                        }
                    }
                    
                    if showFilter, let onFilterTap {
                        Button(action: onFilterTap) {
                            Image(systemName: "line.3.horizontal.decrease.circle")
                        }
                    }
                }
            }
        }
    }
}
