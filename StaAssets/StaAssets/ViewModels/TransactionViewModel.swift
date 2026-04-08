
import Foundation
import CoreData
import Combine
import SwiftUI

final class TransactionViewModel: ObservableObject {
    
    @Published var transactions: [Transaction] = []
    var balance: Double {
        transactions.reduce(0) {
            $0 + ($1.isIncome ? $1.amount : -$1.amount)
        }
    }
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
        
        let newTransaction = TransactionEntity(context: context)
        newTransaction.id = UUID()
        newTransaction.amount = amount
        newTransaction.category = category
        newTransaction.note = note
        newTransaction.date = Date()
        newTransaction.isIncome = isIncome
        
        let message: String
        if isIncome {
            message = "₹\(Int(amount)) credited"
        } else {
            message = "₹\(Int(amount)) debited"
        }
        
        alertMessage = message
        notifications.insert(message, at: 0)
        showAlert = true
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

extension Transaction {
    
    var displayAmount: String {
        let sign = isIncome ? "+ " : "- "
        return "\(sign)₹\(Int(amount))"
    }
    
    var displayColor: Color {
        isIncome ? .green : .primary
    }
}
