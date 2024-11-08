import SwiftUI

struct LogInWithEmailView: View {
    
    @StateObject private var viewModel = LogInWithEmailViewModel()
    @Binding var showSignInView: Bool
    @State private var errorMessage: String = ""
    
    var body: some View {
        VStack(spacing: 20) {
            // Title
            Text("Welcome Back")
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

            // Error Message
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
                    .padding(.top, 5)
            }

            // Log In Button
            Button(action: {
                Task {
                    do {
                        try await viewModel.signIn()
                        showSignInView = false
                    } catch {
                        errorMessage = "Failed to sign in. Please check your credentials."
                        print("Error: \(error)")
                    }
                }
            }) {
                Text("Log In")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .shadow(radius: 3)
            }
            .padding(.top, 20)
        }
        .padding()
        .navigationTitle("Log In")        
    }
}


#Preview {
    LogInWithEmailView(showSignInView: .constant(true))
}
