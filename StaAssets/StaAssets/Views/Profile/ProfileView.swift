
import SwiftUI
import Combine

struct ProfileView: View {
    
    @State private var isEditing = false
    @State private var showAddSheet = false
    
    @State private var password = ""
    @State private var confirmPassword = ""
    @EnvironmentObject var vm: TransactionViewModel
    @EnvironmentObject var userVM: UserViewModel
    
    var body: some View {
        
        ZStack {
            
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                
                AppHeaderView {}
                    .padding(.horizontal)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        
                        profileHeader
                        
                        toggleControl
                        
                        if isEditing {
                            editView
                        } else {
                            previewView
                        }
                    }
                    .padding()
                    .padding(.bottom, 100)
                }
            }
            
            FloatingActionButton {
                showAddSheet = true
            }
        }
        .sheet(isPresented: $showAddSheet) {
            AddTransactionView { amount, category, note, isIncome in
                vm.addTransaction(
                    amount: amount,
                    category: category,
                    note: note,
                    isIncome: isIncome
                )
            }
        }
    }
}

extension ProfileView {
    
    var profileHeader: some View {
        HStack(spacing: 14) {
            
            Circle()
                .fill(Color.accentColor.opacity(0.15))
                .frame(width: 50, height: 50)
                .overlay(
                    Text(String(userVM.name.prefix(1)))
                        .font(.headline)
                        .foregroundColor(.accentColor)
                )
            
            VStack(alignment: .leading, spacing: 2) {
                Text(userVM.name)
                    .font(.headline)
                
                Text(userVM.email)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.secondarySystemBackground))
        )
    }
    
    var toggleControl: some View {
        Picker("", selection: Binding(
            get: { isEditing ? 1 : 0 },
            set: { isEditing = ($0 == 1) }
        )) {
            Text("Preview").tag(0)
            Text("Edit").tag(1)
        }
        .pickerStyle(.segmented)
        .padding(.horizontal, 4)
    }
    
    var previewView: some View {
        
        VStack(spacing: 16) {
            
            statCard(title: "Total Expenses", value: totalExpenses, color: .primary)
            statCard(title: "Total Income", value: totalIncome, color: .primary)
            statCard(title: "Balance", value: balance, color: .primary)
            
            infoRow(title: "Email", value: userVM.email)
        }
    }
    
    func statCard(title: String, value: Int, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            
            Text("₹\(value)")
                .font(.title3.bold())
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.secondarySystemBackground))
        )
    }
    
    func infoRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .foregroundStyle(.secondary)
            
            Spacer()
            
            Text(value)
                .fontWeight(.medium)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.secondarySystemBackground))
        )
    }
    
    var editView: some View {
        
        VStack(spacing: 16) {
            
            inputField("Full Name", text: $userVM.name)
            inputField("Email", text: $userVM.email)
            passwordField("Password", text: $password)
            passwordField("Confirm Password", text: $confirmPassword)
            
            Button {
                isEditing = false
            } label: {
                Text("Update Details")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(14)
            }
            .padding(.top, 10)
        }
    }
    
    var totalExpenses: Int {
        Int(vm.transactions
            .filter { !$0.isIncome }
            .reduce(0) { $0 + $1.amount })
    }

    var totalIncome: Int {
        Int(vm.transactions
            .filter { $0.isIncome }
            .reduce(0) { $0 + $1.amount })
    }

    var balance: Int {
        totalIncome - totalExpenses
    }
    
    func inputField(_ title: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            
            TextField("Enter \(title.lowercased())", text: text)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.secondarySystemBackground))
                )
        }
    }
    
    func passwordField(_ title: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            
            SecureField("Enter \(title.lowercased())", text: text)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.secondarySystemBackground))
                )
        }
    }
}

#Preview {
    ProfileView()
}
