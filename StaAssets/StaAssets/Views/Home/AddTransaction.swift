
import SwiftUI

struct AddTransactionView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var amount = ""
    @State private var category = "Food"
    @State private var note = ""
    @State private var isIncome = false
    
    var onSave: (Double, String, String, Bool) -> Void
    
    var body: some View {
        
        NavigationStack {
            
            Form {
                
                // MARK: - Amount
                Section("Amount") {
                    TextField("Enter amount", text: $amount)
                        .keyboardType(.decimalPad)
                }
                
                // MARK: - Category
                Section("Category") {
                    
                    Picker("Select Category", selection: $category) {
                        ForEach(allCategories, id: \.self) { item in
                            
                            Label {
                                Text(item)
                            } icon: {
                                Image(systemName: categoryIcon(item))
                            }
                            .tag(item)
                        }
                    }
                }
                
                // MARK: - Note
                Section("Note") {
                    TextField("Add note", text: $note)
                }
                
                // MARK: - Income Toggle
                Section {
                    Toggle("Is Income?", isOn: $isIncome)
                }
            }
            .navigationTitle("Add Transaction")
            .navigationBarTitleDisplayMode(.inline)
            
            // MARK: - Toolbar
            .toolbar {
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        if let value = Double(amount) {
                            onSave(value, category, note, isIncome)
                            dismiss()
                        }
                    }
                    .fontWeight(.semibold)
                    .disabled(amount.isEmpty)
                }
            }
        }
    }
}
