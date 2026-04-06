
import SwiftUI

struct NotificationPreviewSheet: View {
    
    @EnvironmentObject var vm: TransactionViewModel
    @State private var showAll = false
    
    var body: some View {
        
        NavigationStack {
            
            VStack(spacing: 16) {
                
                Text("Notifications")
                    .font(.title2.bold())
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                if vm.notifications.isEmpty {
                    Text("No notifications")
                        .foregroundStyle(.secondary)
                } else {
                    
                    ForEach(vm.notifications.prefix(5), id: \.self) { note in
                        notificationRow(note)
                    }
                    
                    if vm.notifications.count > 5 {
                        Button("Show All") {
                            showAll = true
                        }
                        .font(.headline)
                        .padding(.top, 10)
                    }
                }
                
                Spacer()
            }
            .padding()
            .navigationDestination(isPresented: $showAll) {
                NotificationListView()
                    .environmentObject(vm)
            }
        }
    }
}
