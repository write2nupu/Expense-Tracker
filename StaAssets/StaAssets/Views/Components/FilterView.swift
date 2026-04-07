
import SwiftUI

struct FilterView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @Binding var selectedCategories: Set<String>
    @Binding var selectedType: String?
    
    let categories = [
        "Savings",
        "Debts",
        "Subscriptions",
        "Utilities",
        "Housing",
        "Transportation",
        "Personal Care",
        "Gifts",
        "Insurance",
        "Entertainment",
        "Food",
        "Travel",
        "Shopping",
        "Bills"
    ]
    
    var body: some View {
        
        VStack(spacing: 20) {
            
            HStack {
                
                if hasActiveFilters {
                    Button("Clear All") {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            selectedCategories.removeAll()
                            selectedType = nil
                        }
                    }
                }
                
                Spacer()
                
                Button("Done") {
                    dismiss()
                }
            }
            
            Text("Filter by")
                .font(.largeTitle.bold())
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(alignment: .leading, spacing: 10) {
                
                Text("Transaction Type")
                    .font(.headline)
                
                Picker("", selection: Binding(
                    get: { selectedType ?? "None" },
                    set: { selectedType = $0 == "None" ? nil : $0 }
                )) {
                    Text("All").tag("None")
                    Text("Credited").tag("Income")
                    Text("Debited").tag("Expense")
                }
                .pickerStyle(.segmented)
            }
            
            VStack(alignment: .leading, spacing: 12) {
                
                ScrollView(showsIndicators: true) {
                    VStack(spacing: 12) {
                        
                        ForEach(categories, id: \.self) { category in
                            
                            HStack {
                                Text(category)
                                
                                Spacer()
                                
                                if selectedCategories.contains(category) {
                                    Image(systemName: "checkmark.circle.fill")
                                }
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                toggleCategory(category)
                            }
                        }
                    }
                    .padding(.top, 4)
                }
            }
            
            Spacer(minLength: 0)
        }
        .padding()
    }
}

extension FilterView {
    var hasActiveFilters: Bool {
        !selectedCategories.isEmpty || selectedType != nil
    }

    func toggleCategory(_ category: String) {
        if selectedCategories.contains(category) {
            selectedCategories.remove(category)
        } else {
            selectedCategories.insert(category)
        }
    }
}
