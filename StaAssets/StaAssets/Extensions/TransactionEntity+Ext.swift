
import Foundation

extension TransactionEntity {
    
    func toModel() -> Transaction {
        Transaction(
            id: self.id ?? UUID(),
            amount: self.amount,
            category: self.category ?? "",
            date: self.date ?? Date(),
            note: self.note ?? "",
            isIncome: self.isIncome
        )
    }
}
