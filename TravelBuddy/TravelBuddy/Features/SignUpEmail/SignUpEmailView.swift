import SwiftUI

struct SignUpEmailView: View {
    
    @StateObject private var viewModel = SignUpEmailViewModel()
    @Binding var showSignInView: Bool
    @State private var showCreateProfileView = false
    @State private var confirmPassword = ""
    @State private var errorMessage = ""
    
    var body: some View {
        VStack(spacing: 20) {
            // Title
            Text("Create Your Account")
                .font(.title)
                .fontWeight(.semibold)
                .foregroundColor(.blue)
                .padding(.bottom, 30)
            
            // Email Field
            TextField("Email", text: $viewModel.email)
                .padding()
                .background(Color.gray.opacity(0.15))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.blue, lineWidth: 1)
                )
                .textInputAutocapitalization(.never)
                .keyboardType(.emailAddress)
            
            // Password Field
            SecureField("Password", text: $viewModel.password)
                .padding()
                .background(Color.gray.opacity(0.15))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.blue, lineWidth: 1)
                )

            // Confirm Password Field
            SecureField("Confirm Password", text: $confirmPassword)
                .padding()
                .background(Color.gray.opacity(0.15))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.blue, lineWidth: 1)
                )
            
            // Error Message
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
                    .padding(.top, 5)
            }

            // Continue Button
            NavigationLink(destination: CreateProfileView(showSignInView: $showSignInView, email: $viewModel.email, password: $viewModel.password), isActive: $showCreateProfileView) {
                Button(action: {
                    if validatePasswords() {
                        showCreateProfileView = true
                    }
                }) {
                    Text("Continue")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .shadow(radius: 3)
                }
            }
            .disabled(viewModel.email.isEmpty || viewModel.password.isEmpty || confirmPassword.isEmpty)

        }
        .padding()
        .navigationTitle("Sign Up with Email")
    }
    
    // Validation Method for Passwords
    private func validatePasswords() -> Bool {
        guard viewModel.password == confirmPassword else {
            errorMessage = "Passwords do not match."
            return false
        }
        
        guard viewModel.password.count >= 6 else {
            errorMessage = "Password must be at least 6 characters long"
            return false
        }
        
        errorMessage = ""
        return true
    }
}

#Preview {
    SignUpEmailView(showSignInView: .constant(false))
}
