
import SwiftUI
import Combine

struct HomeView: View {
    
    @State private var selectedSegment = 0
    @State private var showAddSheet = false
    @StateObject private var vm = TransactionViewModel()
    @EnvironmentObject var userVM: UserViewModel
    
    var body: some View {
        
        ZStack {
            
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 20) {
                
                headerView
                
                ScrollView(showsIndicators: false) {
                    
                    VStack(spacing: 25) {
                        
                        greetingView
                        
                        cardView
                        
                        expenseSection
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

extension HomeView {
    
    var headerView: some View {
        HStack {
            
            HStack(spacing: 10) {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white.opacity(0.9))
                    .frame(width: 35, height: 35)
                    .overlay(
                        Text("S")
                            .foregroundColor(.black)
                    )
                
                Text("StaAssets")
                    .foregroundColor(.white)
                    .font(.headline)
            }
            
            Spacer()
            
            HStack(spacing: 16) {
                Image(systemName: "magnifyingglass")
                Image(systemName: "bell")
            }
            .foregroundColor(.white)
        }
    }
    
    var greetingView: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Hey, \(userVM.name.isEmpty ? "User" : userVM.name)")
                .foregroundColor(.white)
                .font(.title2.bold())
            
            Text("Add your yesterday’s expense")
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    var cardView: some View {
        
        ZStack(alignment: .leading) {
            
            LinearGradient(
                colors: [
                    Color(#colorLiteral(red: 0.85, green: 0.75, blue: 0.6, alpha: 1)),
                    Color(#colorLiteral(red: 0.2, green: 0.7, blue: 0.6, alpha: 1))
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .cornerRadius(25)
            
            VStack(alignment: .leading, spacing: 20) {
                
                Text("ADRBank")
                    .foregroundColor(.white)
                    .font(.headline)
                
                Text("8763 1111 2222 0329")
                    .foregroundColor(.white)
                    .font(.title2.bold())
                
                HStack {
                    
                    VStack(alignment: .leading) {
                        Text("Card Holder Name")
                            .foregroundColor(.white.opacity(0.7))
                            .font(.caption)
                        
                        Text(userVM.name)
                            .textCase(.uppercase)
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        Text("Expired Date")
                            .foregroundColor(.white.opacity(0.7))
                            .font(.caption)
                        
                        Text("10/28")
                            .foregroundColor(.white)
                    }
                }
            }
            .padding()
        }
        .frame(height: 200)
    }
    
    var expenseSection: some View {
        
        VStack(alignment: .leading, spacing: 20) {
            
            Text("Your expenses")
                .foregroundColor(.white)
                .font(.headline)
            
            CustomSegmentedControl(
                selectedIndex: $selectedSegment,
                titles: ["Weekly", "Monthly"]
            )
            
            VStack(spacing: 16) {
                
                if vm.transactions.isEmpty {
                    Text("No transactions yet")
                        .foregroundColor(.gray)
                        .padding(.top, 20)
                } else {
                    ForEach(vm.transactions) { transaction in
                        expenseCard(
                            title: transaction.category.uppercased(),
                            subtitle: transaction.note.isEmpty ? "No note" : transaction.note,
                            amount: "₹\(Int(transaction.amount))"
                        )
                    }
                }
            }
        }
    }
    
    func expenseCard(title: String, subtitle: String, amount: String) -> some View {
        
        HStack {
            
            Circle()
                .stroke(Color.white.opacity(0.5), lineWidth: 3)
                .frame(width: 40, height: 40)
            
            VStack(alignment: .leading) {
                Text(title)
                    .foregroundColor(.white)
                    .font(.headline)
                
                Text(subtitle)
                    .foregroundColor(.gray)
                    .font(.caption)
            }
            
            Spacer()
            
            Text(amount)
                .foregroundColor(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.white.opacity(0.1))
                .cornerRadius(10)
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(20)
    }

}

#Preview {
    HomeView()
}
