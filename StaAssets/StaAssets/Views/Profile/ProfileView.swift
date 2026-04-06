
import SwiftUI

struct ProfileView: View {
    
    @State private var isEditing = false
    @State private var showAddSheet = false
    @State private var name = "Alex yu"
    @State private var email = "alex@gmail.com"
    @State private var password = ""
    @State private var confirmPassword = ""
    
    var body: some View {
        
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 20) {
                
                header
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 25) {
                        
                        profileHeader
                        
                        toggleControl
                        
                        if isEditing {
                            editView
                        } else {
                            previewView
                        }
                    }
                    .padding(.bottom, 100)
                }
            }
            .padding(.horizontal)
            
            FloatingActionButton {
                showAddSheet = true
            }
        }
    }
}

extension ProfileView {
    
    var header: some View {
        HStack {
            
            HStack(spacing: 10) {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white.opacity(0.9))
                    .frame(width: 35, height: 35)
                    .overlay(Text("P").foregroundColor(.black))
                
                Text("PayU")
                    .foregroundColor(.white)
                    .font(.headline)
            }
            
            Spacer()
            
            HStack(spacing: 16) {
                Image(systemName: "magnifyingglass")
                Image(systemName: "bell")
            }
            .foregroundColor(.white)
        }
    }
    
    var profileHeader: some View {
        HStack(spacing: 12) {
            
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white.opacity(0.9))
                .frame(width: 45, height: 45)
                .overlay(Text("P").foregroundColor(.black))
            
            Text(name)
                .foregroundColor(.white)
                .font(.headline)
            
            Spacer()
        }
    }
    
    var toggleControl: some View {
        CustomSegmentedControl(
            selectedIndex: Binding(
                get: { isEditing ? 1 : 0 },
                set: { isEditing = ($0 == 1) }
            ),
            titles: ["Preview", "Edit"]
        )
    }
    
    var previewView: some View {
        
        VStack(alignment: .leading, spacing: 16) {
            
            Text("Total spendings: $2000")
                .foregroundColor(.white)
            
            Text("Email : \(email)")
                .foregroundColor(.white)
            
            Text("Balance : $20000")
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    var editView: some View {
        
        VStack(spacing: 16) {
            
            inputField("Full Name", text: $name)
            inputField("Email", text: $email)
            passwordField("Password", text: $password)
            passwordField("Confirm Password", text: $confirmPassword)
            
            Button {
                
            } label: {
                Text("Update Details")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white)
                    .foregroundColor(.black)
                    .cornerRadius(14)
            }
            .padding(.top, 10)
        }
    }
    
    func inputField(_ title: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            
            Text(title)
                .foregroundColor(.white)
                .font(.caption)
            
            TextField("Enter your \(title.lowercased())", text: text)
                .padding()
                .background(Color.white.opacity(0.05))
                .cornerRadius(12)
                .foregroundColor(.white)
        }
    }
    
    func passwordField(_ title: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            
            Text(title)
                .foregroundColor(.white)
                .font(.caption)
            
            SecureField("Enter your \(title.lowercased())", text: text)
                .padding()
                .background(Color.white.opacity(0.05))
                .cornerRadius(12)
                .foregroundColor(.white)
        }
    }
}

#Preview {
    ProfileView()
}
