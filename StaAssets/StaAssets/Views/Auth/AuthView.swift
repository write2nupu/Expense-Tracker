
import SwiftUI

struct AuthView: View {
    
    @State private var selectedTab = 0
    
    @State private var email = ""
    @State private var password = ""
    @State private var fullName = ""
    @State private var confirmPassword = ""
    
    @Binding var isLoggedIn: Bool
    @EnvironmentObject var userVM: UserViewModel
    
    @FocusState private var focusedField: Field?
    
    enum Field {
        case email, password, fullName, confirmPassword
    }
    
    var body: some View {
        
        ZStack {
            
            // MARK: - Adaptive Background
            LinearGradient(
                colors: [
                    Color(.systemBackground),
                    Color(.systemBackground).opacity(0.95)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            GeometryReader { geo in
                
                VStack(spacing: selectedTab == 1 ? 16 : 28) {
                    
                    Spacer(minLength: selectedTab == 1 ? 10 : 40)
                    
                    // MARK: - Logo + Title
                    VStack(spacing: 14) {
                        
                        RoundedRectangle(cornerRadius: 18)
                            .fill(Color.primary.opacity(0.1))
                            .frame(width: 64, height: 64)
                            .overlay(
                                Text("P")
                                    .font(.title.bold())
                                    .foregroundStyle(.primary)
                            )
                        
                        Text("Welcome to StaAssets")
                            .font(.title2.bold())
                            .foregroundStyle(.primary)
                        
                        Text("Send money globally with the real exchange rate")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .animation(.spring(response: 0.4, dampingFraction: 0.85), value: selectedTab)
                    
                    // MARK: - CARD
                    VStack(alignment: .leading, spacing: 16) {
                        
                        Text("Get started")
                            .font(.headline)
                            .foregroundStyle(.primary)
                        
                        Text("Sign in to your account or create a new one")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        
                        // MARK: - Native Segmented Control
                        Picker("", selection: $selectedTab) {
                            Text("Sign In").tag(0)
                            Text("Sign Up").tag(1)
                        }
                        .pickerStyle(.segmented)
                        
                        // MARK: - Fields Container (stable height)
                        VStack(spacing: 14) {
                            
                            if selectedTab == 1 {
                                inputField("Full Name", text: $fullName)
                                    .focused($focusedField, equals: .fullName)
                                    .transition(fieldTransition)
                            }
                            
                            inputField("Email", text: $email)
                                .focused($focusedField, equals: .email)
                            
                            passwordField("Password", text: $password)
                                .focused($focusedField, equals: .password)
                            
                            if selectedTab == 1 {
                                passwordField("Confirm Password", text: $confirmPassword)
                                    .focused($focusedField, equals: .confirmPassword)
                                    .transition(fieldTransition)
                            }
                        }
                        .animation(.spring(response: 0.35, dampingFraction: 0.85), value: selectedTab)
                        // MARK: - Forgot Password
                        if selectedTab == 0 {
                            HStack {
                                Spacer()
                                Text("Forgot password?")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        
                        // MARK: - Button
                        Button {
                            
                            dismissKeyboard()
                            
                            if selectedTab == 1 {
                                userVM.name = fullName.isEmpty ? "User" : fullName
                                userVM.email = email
                            } else {
                                userVM.email = email
                                let nameFromEmail = email.split(separator: "@").first ?? "User"
                                userVM.name = String(nameFromEmail).capitalized
                            }
                            
                            withAnimation {
                                isLoggedIn = true
                            }
                            
                        } label: {
                            Text(selectedTab == 0 ? "Sign In" : "Create Account")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.primary)
                                .foregroundStyle(Color(.systemBackground))
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                        }
                        .padding(.top, 8)
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 24)
                            .stroke(Color.primary.opacity(0.08))
                    )
                    .animation(.spring(response: 0.35, dampingFraction: 0.85), value: selectedTab)
                    
                    Spacer()
                }
                .padding()
                .frame(height: geo.size.height)
            }
        }
    }
}

// MARK: - Components

extension AuthView {
    
    var fieldTransition: AnyTransition {
        .asymmetric(
            insertion: .opacity.combined(with: .offset(y: -10)),
            removal: .opacity.combined(with: .offset(y: 10))
        )
    }
    
    func inputField(_ title: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            
            TextField("Enter your \(title.lowercased())", text: text)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(Color(.systemBackground)) // ✅ KEY CHANGE
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Color.primary.opacity(0.12), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.04), radius: 4, y: 2)
        }
    }
    
    func passwordField(_ title: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            
            HStack {
                SecureField("Enter your \(title.lowercased())", text: text)
                
                Image(systemName: "eye")
                    .foregroundStyle(.secondary)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(Color(.systemBackground))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Color.primary.opacity(0.12), lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.04), radius: 4, y: 2)
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
