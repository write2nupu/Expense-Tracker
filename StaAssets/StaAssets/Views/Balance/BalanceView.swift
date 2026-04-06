
import SwiftUI
import Charts

struct BalanceView: View {
    
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
            [
                ChartData(day: "Mon", amount: 300),
                ChartData(day: "Tue", amount: 100),
                ChartData(day: "Wed", amount: 200),
                ChartData(day: "Thu", amount: 400),
                ChartData(day: "Fri", amount: 350),
                ChartData(day: "Sat", amount: 150)
            ]
        }
        
    var chartSection: some View {
        
        VStack(alignment: .leading, spacing: 16) {
            
            Chart(chartData) { item in
                BarMark(
                    x: .value("Day", item.day),
                    y: .value("Amount", item.amount)
                )
                .cornerRadius(6)
            }
            .frame(height: 200)
            
            HStack {
                Text("Current margin: April Spendings")
                    .foregroundColor(.gray)
                    .font(.caption)
                
                Spacer()
                
                Text("$350.00 / $640.00")
                    .foregroundColor(.purple)
                    .font(.caption.bold())
            }
        }
    }
}

#Preview {
    BalanceView()
}
