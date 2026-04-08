
import Foundation

struct PieSlice: Identifiable {
    let id = UUID()
    let category: String
    let value: Double
}

struct ChartData: Identifiable {
    let id = UUID()
    let label: String
    let value: Double
}
