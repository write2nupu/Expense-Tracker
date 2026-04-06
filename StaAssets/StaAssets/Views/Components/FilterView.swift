
import SwiftUI

struct FilterView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @Binding var selectedCategories: Set<String>
    @Binding var selectedType: String? // "Income" / "Expense"
    
    let categories = ["Food", "Travel", "Shopping", "Bills"]
    
    var body: some View {
        
        VStack(spacing: 20) {
            
            // HEADER
            HStack {
                
                if hasActiveFilters {
                    Button("Clear All") {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            selectedCategories.removeAll()
                            selectedType = nil
                        }
                    }
                    .transition(
                        .asymmetric(
                            insertion: .opacity,
                            removal: .opacity
                        )
                    )
                }
                
                Spacer()
                
                Button("Done") {
                    dismiss()
                }
            }
            .animation(.easeInOut(duration: 0.25), value: hasActiveFilters)
            
            Text("Filter by")
                .font(.largeTitle.bold())
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // 🔥 TYPE (ONLY THIS SEGMENT NOW)
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
            
            // CATEGORIES
            VStack(alignment: .leading, spacing: 12) {
                
                Text("Categories")
                    .font(.headline)
                
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
            
            Spacer()
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
