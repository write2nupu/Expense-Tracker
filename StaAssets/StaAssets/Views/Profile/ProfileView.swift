
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
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 20) {
                
                AppHeaderView {
                }
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 25) {
                        
                        profileHeader
                        
                        toggleControl
                        
                        if isEditing {
                            editView
                        } else {
                            previewView
                        }
                    }
                    .padding(.bottom, 100)
                }
            }
            .padding(.horizontal)
            
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
        HStack(spacing: 12) {
            
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white.opacity(0.9))
                .frame(width: 45, height: 45)
                .overlay(Text("P").foregroundColor(.black))
            
            Text(userVM.name)
                .foregroundColor(.white)
                .font(.headline)
            
            Spacer()
        }
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
    }
    
    var previewView: some View {
        
        VStack(alignment: .leading, spacing: 16) {
            
            Text("Total spendings: ₹\(totalExpenses)")
                .foregroundColor(.white)
            
            Text("Email : \(userVM.email)")
                .foregroundColor(.white)
            
            Text("Balance : ₹\(balance)")
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
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
                    .background(Color.white)
                    .foregroundColor(.black)
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
        VStack(alignment: .leading, spacing: 8) {
            
            Text(title)
                .foregroundColor(.white)
                .font(.caption)
            
            TextField("Enter your \(title.lowercased())", text: text)
                .padding()
                .background(Color.white.opacity(0.05))
                .cornerRadius(12)
                .foregroundColor(.white)
        }
    }
    
    func passwordField(_ title: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            
            Text(title)
                .foregroundColor(.white)
                .font(.caption)
            
            SecureField("Enter your \(title.lowercased())", text: text)
                .padding()
                .background(Color.white.opacity(0.05))
                .cornerRadius(12)
                .foregroundColor(.white)
        }
    }
}

#Preview {
    ProfileView()
}
