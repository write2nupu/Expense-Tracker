
import Foundation

struct Transaction: Identifiable {
    let id: UUID
    let amount: Double
    let category: String
    let date: Date
    let note: String
    let isIncome: Bool
}
