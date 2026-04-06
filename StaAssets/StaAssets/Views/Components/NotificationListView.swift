
import SwiftUI

struct NotificationListView: View {
    
    @EnvironmentObject var vm: TransactionViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        VStack {
            
            if vm.notifications.isEmpty {
                Text("No notifications")
                    .foregroundStyle(.secondary)
            } else {
                
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(vm.notifications, id: \.self) { note in
                            notificationRow(note)
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("All Notifications")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Back") {
                    dismiss()
                }
            }
        }
    }
}

