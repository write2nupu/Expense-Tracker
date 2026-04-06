
import Foundation
import CoreData
import Combine

final class TransactionViewModel: ObservableObject {
    
    @Published var transactions: [Transaction] = []
    @Published var balance: Double = 0
    @Published var alertMessage: String = ""
    @Published var showAlert: Bool = false
    @Published var notifications: [String] = []
    
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
        
        if !isIncome && amount > balance {
            alertMessage = "Insufficient balance.\nCannot spend ₹\(Int(amount))"
            showAlert = true
            return
        }
        
        let message: String

        if isIncome {
            balance += amount
            message = "₹\(Int(amount)) credited. Balance: ₹\(Int(balance))"
        } else {
            balance -= amount
            message = "₹\(Int(amount)) debited. Balance: ₹\(Int(balance))"
        }

        alertMessage = message
        notifications.insert(message, at: 0)
        showAlert = true
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
