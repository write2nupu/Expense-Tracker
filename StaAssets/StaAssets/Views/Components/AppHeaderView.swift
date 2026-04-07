
import SwiftUI

struct AppHeaderView: View {
    
    @EnvironmentObject var vm: TransactionViewModel
    
    var showFilter: Bool = false
    var onFilterTap: (() -> Void)?
    
    var body: some View {
        
        HStack {
            
            // LOGO + TITLE
            HStack(spacing: 10) {
                
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(.secondarySystemBackground)) // ✅ adaptive
                    .frame(width: 35, height: 35)
                    .overlay(
                        Text("P")
                            .font(.headline)
                            .foregroundStyle(.primary)
                    )
                
                Text("StaAssets")
                    .font(.headline)
                    .foregroundStyle(.primary)
            }
            
            Spacer()
            
            HStack(spacing: 18) {
                
                // 🔔 NOTIFICATIONS (Menu)
                Menu {
                    
                    if vm.notifications.isEmpty {
                        Label("No notifications", systemImage: "bell.slash")
                    } else {
                        
                        ForEach(vm.notifications.prefix(3), id: \.self) { note in
                            Label(note, systemImage: "bell")
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
                            .foregroundStyle(.primary)
                        
                        if !vm.notifications.isEmpty {
                            Circle()
                                .fill(Color.red) // ✅ keep red (system alert color)
                                .frame(width: 8, height: 8)
                                .offset(x: 6, y: -6)
                        }
                    }
                }
                
                // 🔍 FILTER (only when needed)
                if showFilter, let onFilterTap {
                    Button(action: onFilterTap) {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                            .foregroundStyle(.primary)
                    }
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(
            Color(.systemBackground)
        )
    }
}
