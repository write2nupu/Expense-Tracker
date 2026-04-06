
import SwiftUI

struct AuthView: View {
    
    @State private var selectedTab = 0
    
    @State private var email = ""
    @State private var password = ""
    @State private var fullName = ""
    @State private var confirmPassword = ""
    
    @Binding var isLoggedIn: Bool
    
    @FocusState private var focusedField: Field?
    
    enum Field {
        case email, password, fullName, confirmPassword
    }
    
    var body: some View {
        
        ZStack {
            
            // MARK: - Background Gradient
            LinearGradient(
                colors: [Color.black, Color.black.opacity(0.9)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                
                VStack(spacing: 30) {
                    
                    Spacer(minLength: 40)
                    
                    // MARK: - Logo + Title
                    VStack(spacing: 16) {
                        
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white.opacity(0.9))
                            .frame(width: 70, height: 70)
                            .overlay(
                                Text("P")
                                    .font(.title.bold())
                                    .foregroundColor(.black)
                            )
                        
                        Text("Welcome to StaAssets")
                            .font(.title2.bold())
                            .foregroundColor(.white)
                        
                        Text("Send money globally with the real exchange rate")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                    }
                    
                    // MARK: - Card
                    VStack(alignment: .leading, spacing: 20) {
                        
                        Text("Get started")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        Text("Sign in to your account or create a new one")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        // MARK: - Segmented Control
                        CustomSegmentedControl(
                            selectedIndex: $selectedTab,
                            titles: ["Sign In", "Sign Up"]
                        )
                        .frame(height: 50)
                        
                        // MARK: - Fields
                        Group {
                            
                            if selectedTab == 1 {
                                inputField("Full Name", text: $fullName)
                                    .focused($focusedField, equals: .fullName)
                                    .transition(.move(edge: .top).combined(with: .opacity))
                            }
                            
                            inputField("Email", text: $email)
                                .focused($focusedField, equals: .email)
                            
                            passwordField("Password", text: $password)
                                .focused($focusedField, equals: .password)
                            
                            if selectedTab == 1 {
                                passwordField("Confirm Password", text: $confirmPassword)
                                    .focused($focusedField, equals: .confirmPassword)
                                    .transition(.move(edge: .bottom).combined(with: .opacity))
                            }
                        }
                        .animation(.easeInOut, value: selectedTab)
                        
                        // MARK: - Forgot Password
                        if selectedTab == 0 {
                            HStack {
                                Spacer()
                                Text("Forgot password?")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                        
                        // MARK: - Button
                        Button {
                            
                            dismissKeyboard()
                            
                            // Simple validation (optional but nice)
                            if !email.isEmpty && !password.isEmpty {
                                withAnimation {
                                    isLoggedIn = true
                                }
                            }
                            
                        } label: {
                            Text(selectedTab == 0 ? "Sign In" : "Create Account")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.white)
                                .foregroundColor(.black)
                                .cornerRadius(14)
                        }
                        .padding(.top, 10)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .fill(Color.white.opacity(0.05))
                            .background(.ultraThinMaterial)
                    )
                    
                    Spacer()
                }
                .padding()
            }
        }
    }
}

extension AuthView {
    
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
            
            HStack {
                SecureField("Enter your \(title.lowercased())", text: text)
                    .foregroundColor(.white)
                
                Image(systemName: "eye")
                    .foregroundColor(.gray)
            }
            .padding()
            .background(Color.white.opacity(0.05))
            .cornerRadius(12)
        }
    }
    
    func dismissKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }
}

#Preview {
    AuthView(isLoggedIn: .constant(false))
}
