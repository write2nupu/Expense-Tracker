
import SwiftUI
import Combine
import Charts

struct BalanceView: View {
    
    @StateObject private var vm = TransactionViewModel()
    @State private var showAddSheet = false
    
    var body: some View {
        
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 20) {
                
                header
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 25) {
                        
                        balanceHeader
                        
                        creditScoreView
                        
                        currencyCard
                        
                        chartSection
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

extension BalanceView {
    
    var header: some View {
        HStack {
            HStack(spacing: 10) {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white.opacity(0.9))
                    .frame(width: 35, height: 35)
                    .overlay(Text("P").foregroundColor(.black))
                
                Text("PayU")
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
    
    var balanceHeader: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Your Balances")
                .foregroundColor(.white)
                .font(.title2.bold())
            
            Text("Manage your multi-currency accounts")
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    var creditScoreView: some View {
        
        VStack(spacing: 16) {
            
            ZStack {
                
                Circle()
                    .stroke(Color.white.opacity(0.1), lineWidth: 20)
                    .frame(width: 180, height: 180)
                
                Circle()
                    .trim(from: 0.0, to: 0.66)
                    .stroke(
                        AngularGradient(
                            colors: [.green, .purple, .blue],
                            center: .center
                        ),
                        style: StrokeStyle(lineWidth: 20, lineCap: .round)
                    )
                    .rotationEffect(.degrees(140))
                    .frame(width: 180, height: 180)
                
                VStack {
                    Text("660")
                        .font(.largeTitle.bold())
                        .foregroundColor(.white)
                    
                    Text("Your Credit Score is average")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            
            Text("Last Check on 21 Apr")
                .foregroundColor(.gray)
                .font(.caption)
        }
    }
    
    var currencyCard: some View {
        
        HStack {
            
            VStack(alignment: .leading, spacing: 6) {
                Text("CAD")
                    .foregroundColor(.white)
                    .font(.headline)
                
                Text("Canadian Dollar")
                    .foregroundColor(.gray)
                    .font(.caption)
            }
            
            Spacer()
            
            Button {
                
            } label: {
                HStack {
                    Image(systemName: "plus")
                    Text("Enable")
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.white.opacity(0.1))
                .cornerRadius(10)
                .foregroundColor(.white)
            }
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(20)
    }
    
    var chartData: [ChartData] {
        
        let grouped = Dictionary(grouping: vm.transactions) { transaction in
            let formatter = DateFormatter()
            formatter.dateFormat = "E"
            return formatter.string(from: transaction.date)
        }
        
        return grouped.map { (day, transactions) in
            let total = transactions.reduce(0) { $0 + $1.amount }
            return ChartData(day: day, amount: total)
        }
        .sorted { $0.day < $1.day }
    }
        
    var chartSection: some View {
        
        VStack(alignment: .leading, spacing: 16) {
            
            Chart(chartData) { item in
                BarMark(
                    x: .value("Day", item.day),
                    y: .value("Amount", item.amount)
                )
                .cornerRadius(6)
                .foregroundStyle(.purple)
            }
            .frame(height: 200)
            
            HStack {
                Text("Current margin: April Spendings")
                    .foregroundColor(.gray)
                    .font(.caption)
                
                Spacer()
                
                Text("₹\(totalExpenses) / ₹\(totalIncome)")
                    .foregroundColor(.purple)
                    .font(.caption.bold())
            }
        }
    }
    
    var totalExpenses: Int {
        Int(vm.transactions.filter { !$0.isIncome }.reduce(0) { $0 + $1.amount })
    }

    var totalIncome: Int {
        Int(vm.transactions.filter { $0.isIncome }.reduce(0) { $0 + $1.amount })
    }
}

#Preview {
    BalanceView()
}
