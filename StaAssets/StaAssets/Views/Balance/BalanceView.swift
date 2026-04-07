
import SwiftUI
import Charts

struct BalanceView: View {
    
    @StateObject private var vm = TransactionViewModel()
    @State private var showAddSheet = false
    
    var body: some View {
        
        ZStack {
            
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                
                AppHeaderView {}
                    .padding(.horizontal)
                    .padding(.top, 8)
                
                ScrollView(showsIndicators: false) {
                    
                    VStack(alignment: .leading, spacing: 28) {
                        
                        header
                        
                        creditScoreView
                        
                        currencyCard
                        
                        chartSection
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 120)
                }
            }
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    
                    Button {
                        showAddSheet = true
                    } label: {
                        Image(systemName: "plus")
                            .font(.title2.bold())
                            .foregroundColor(.black)
                            .frame(width: 60, height: 60)
                            .background(Color.primary)
                            .clipShape(Circle())
                            .shadow(radius: 10)
                    }
                    .padding(.trailing, 20)
                    .padding(.bottom, 30)
                }
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
    
    // MARK: - Header
    var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            
            Text("Your Balances")
                .font(.title.bold())
                .foregroundStyle(.primary)
            
            Text("Manage your multi-currency accounts")
                .foregroundStyle(.secondary)
        }
        .padding(.top, 10)
    }
    
    // MARK: - Credit Score
    var creditScoreView: some View {
        
        let score: Double = 660
        let maxScore: Double = 850
        let progress = score / maxScore
        
        return VStack(spacing: 12) {
            
            ZStack(alignment: .bottom) {
                
                // MARK: - ARC SYSTEM
                ZStack {
                    GaugeSegments()
                    GaugeDots()
                    GaugeIndicator(progress: progress)
                }
                .frame(width: 260, height: 160)
                
                // MARK: - CENTER TEXT (ANCHORED)
                VStack(spacing: 6) {
                    
                    Text("660")
                        .font(.system(size: 42, weight: .bold))
                    
                    Text("Your Credit Score is average")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    Text("Last Check on 21 Apr")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                        .padding(.top, 4)
                }
                .offset(y: 20)
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    struct GaugeIndicator: View {
        
        var progress: Double
        
        let startAngle: Double = 180
        let totalAngle: Double = 180
        
        var body: some View {
            
            GeometryReader { geo in
                
                let size = geo.size
                let radius = size.width / 2 - 20
                let center = CGPoint(x: size.width / 2, y: size.height)
                
                let angle = (startAngle + progress * totalAngle) * .pi / 180
                
                let x = center.x + radius * cos(angle)
                let y = center.y + radius * sin(angle)
                
                ZStack {
                    
                    Circle()
                        .fill(Color.blue.opacity(0.25))
                        .frame(width: 26, height: 26)
                        .blur(radius: 6)
                    
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 16, height: 16)
                    
                    Circle()
                        .fill(Color.white)
                        .frame(width: 6, height: 6)
                }
                .position(x: x, y: y)
            }
        }
    }
    
    struct GaugeSegments: View {
        
        let segments: [[Color]] = [
            [.green, .mint],
            [.purple, .pink],
            [.blue, .cyan],
            [.orange, .red]
        ]
        
        let startAngle: Double = 180
        let totalAngle: Double = 180
        let spacing: Double = 8
        
        var body: some View {
            
            let segmentAngle = (totalAngle - spacing * 3) / 4
            
            ZStack {
                ForEach(0..<4) { i in
                    
                    let start = startAngle + Double(i) * (segmentAngle + spacing)
                    let end = start + segmentAngle
                    
                    ArcShape(startAngle: start, endAngle: end)
                        .stroke(
                            LinearGradient(
                                colors: segments[i],
                                startPoint: .leading,
                                endPoint: .trailing
                            ),
                            style: StrokeStyle(
                                lineWidth: 16,
                                lineCap: .round
                            )
                        )
                }
            }
        }
    }
    
    struct GaugeDots: View {
        
        let startAngle: Double = 180
        let totalAngle: Double = 180
        
        var body: some View {
            
            GeometryReader { geo in
                
                let size = geo.size
                let radius = size.width / 2 - 20
                let center = CGPoint(x: size.width / 2, y: size.height)
                
                ZStack {
                    ForEach(0..<30) { i in
                        
                        let progress = Double(i) / 30
                        let angle = (startAngle + progress * totalAngle) * .pi / 180
                        
                        let x = center.x + radius * cos(angle)
                        let y = center.y + radius * sin(angle)
                        
                        Circle()
                            .fill(Color.primary.opacity(0.25))
                            .frame(width: 3, height: 3)
                            .position(x: x, y: y)
                    }
                }
            }
        }
    }
    
    struct SegmentedGauge: View {
        
        let colors: [Color] = [.green, .pink, .blue, .yellow]
        
        let totalAngle: Double = 220
        let startAngle: Double = -110
        let spacing: Double = 6
        
        var body: some View {
            
            let segmentAngle = (totalAngle - spacing * Double(colors.count - 1)) / Double(colors.count)
            
            ZStack {
                ForEach(colors.indices, id: \.self) { i in
                    
                    let start = startAngle + Double(i) * (segmentAngle + spacing)
                    let end = start + segmentAngle
                    
                    ArcShape(startAngle: start, endAngle: end)
                        .stroke(
                            colors[i],
                            style: StrokeStyle(
                                lineWidth: 18,
                                lineCap: .round
                            )
                        )
                }
            }
        }
    }
    
    struct ArcShape: Shape {
        
        var startAngle: Double
        var endAngle: Double
        
        func path(in rect: CGRect) -> Path {
            
            var path = Path()
            
            let center = CGPoint(
                x: rect.midX,
                y: rect.maxY
            )
            
            let radius = rect.width / 2
            
            path.addArc(
                center: center,
                radius: radius,
                startAngle: .degrees(startAngle),
                endAngle: .degrees(endAngle),
                clockwise: false
            )
            
            return path
        }
    }
    
    // MARK: - Currency Card
    var currencyCard: some View {
        
        HStack {
            
            VStack(alignment: .leading, spacing: 4) {
                
                Text("CAD")
                    .font(.headline)
                
                Text("Canadian Dollar")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Button {
                
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "plus")
                    Text("Enable")
                }
                .font(.subheadline.weight(.medium))
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(.ultraThinMaterial)
                .clipShape(Capsule())
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
        )
    }
    
    // MARK: - Chart
    
    var chartSection: some View {
        
        VStack(alignment: .leading, spacing: 16) {
            
            Chart(chartData) { item in
                
                BarMark(
                    x: .value("Day", item.day),
                    y: .value("Amount", item.amount)
                )
                .cornerRadius(8)
                .foregroundStyle(
                    LinearGradient(
                        colors: [.green, .blue],
                        startPoint: .bottom,
                        endPoint: .top
                    )
                )
            }
            .frame(height: 220)
            
            HStack {
                Text("Current margin: April Spendings")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                Text("₹\(totalExpenses) / ₹\(totalIncome)")
                    .font(.caption.bold())
                    .foregroundStyle(.primary)
            }
        }
    }
    
    // MARK: - Data
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
    
    var totalExpenses: Int {
        Int(vm.transactions.filter { !$0.isIncome }
            .reduce(0) { $0 + $1.amount })
    }

    var totalIncome: Int {
        Int(vm.transactions.filter { $0.isIncome }
            .reduce(0) { $0 + $1.amount })
    }

    func arcSegment(color: Color, start: CGFloat, end: CGFloat) -> some View {
        
        Circle()
            .trim(from: start * 0.75, to: end * 0.75)
            .stroke(
                color,
                style: StrokeStyle(
                    lineWidth: 18,
                    lineCap: .round
                )
            )
            .rotationEffect(.degrees(135))
    }
}
