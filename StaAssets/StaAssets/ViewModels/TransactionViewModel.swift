
import Foundation
import CoreData
import Combine

final class TransactionViewModel: ObservableObject {
    
    @Published var transactions: [Transaction] = []
    
    private let context = StorageManager.shared.context
    
    init() {
        fetchTransactions()
    }
    
    // MARK: - Fetch
    func fetchTransactions() {
        let request: NSFetchRequest<TransactionEntity> = TransactionEntity.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \TransactionEntity.date, ascending: false)
        ]

        do {
            let result = try context.fetch(request)
            self.transactions = result.map { $0.toModel() }
        } catch {
            print("Fetch failed")
        }
    }
    
    // MARK: - Add
    func addTransaction(
        amount: Double,
        category: String,
        note: String,
        isIncome: Bool
    ) {
        let entity = TransactionEntity(context: context)
        
        entity.id = UUID()
        entity.amount = amount
        entity.category = category
        entity.date = Date()
        entity.note = note
        entity.isIncome = isIncome
        
        save()
    }
    
    // MARK: - Delete
    func deleteTransaction(_ transaction: Transaction) {
        let request: NSFetchRequest<TransactionEntity> = TransactionEntity.fetchRequest()
        
        do {
            let result = try context.fetch(request)
            
            if let match = result.first(where: { $0.id == transaction.id }) {
                context.delete(match)
                save()
            }
        } catch {
            print("Delete failed")
        }
    }
    
    // MARK: - Save
    private func save() {
        do {
            try context.save()
            fetchTransactions()
        } catch {
            print("Save failed")
        }
    }
}
