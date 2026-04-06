
import SwiftUI

struct AddTransactionView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var amount = ""
    @State private var category = "Food"
    @State private var note = ""
    @State private var isIncome = false
    
    let categories = ["Food", "Travel", "Shopping", "Bills"]
    
    var onSave: (Double, String, String, Bool) -> Void
    
    var body: some View {
        
        NavigationStack {
            
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack(spacing: 20) {
                    
                    // Amount
                    VStack(alignment: .leading) {
                        Text("Amount")
                            .foregroundColor(.white)
                        
                        TextField("Enter amount", text: $amount)
                            .keyboardType(.decimalPad)
                            .padding()
                            .background(Color.white.opacity(0.05))
                            .cornerRadius(12)
                            .foregroundColor(.white)
                    }
                    
                    // Category
                    VStack(alignment: .leading) {
                        Text("Category")
                            .foregroundColor(.white)
                        
                        Picker("", selection: $category) {
                            ForEach(categories, id: \.self) {
                                Text($0)
                            }
                        }
                        .pickerStyle(.menu)
                        .padding()
                        .background(Color.white.opacity(0.05))
                        .cornerRadius(12)
                        .foregroundColor(.white)
                    }
                    
                    // Note
                    VStack(alignment: .leading) {
                        Text("Note")
                            .foregroundColor(.white)
                        
                        TextField("Add note", text: $note)
                            .padding()
                            .background(Color.white.opacity(0.05))
                            .cornerRadius(12)
                            .foregroundColor(.white)
                    }
                    
                    // Income Toggle
                    Toggle(isOn: $isIncome) {
                        Text("Is Income?")
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    // Save Button
                    Button {
                        if let value = Double(amount) {
                            onSave(value, category, note, isIncome)
                            dismiss()
                        }
                    } label: {
                        Text("Save Transaction")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .foregroundColor(.black)
                            .cornerRadius(14)
                    }
                }
                .padding()
            }
            .navigationTitle("Add Transaction")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
