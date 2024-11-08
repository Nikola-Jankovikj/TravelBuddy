import SwiftUI
import GoogleSignIn
import GoogleSignInSwift

struct AuthenticationView: View {
    @StateObject private var viewModel = AuthenticationViewModel()
    @Binding var showSignInView: Bool

    var body: some View {
        VStack(spacing: 10) {
            Spacer()

            Image("TravelBuddy")
                .resizable()
                .scaledToFit()
                .padding()
            
            Spacer()
            
            NavigationLink {
                    LogInWithEmailView(showSignInView: $showSignInView)
                } label: {
                    Text("Log In")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(5 )
                        .shadow(radius: 5)
                }

            // Sign Up with Email Button
            NavigationLink {
                SignUpEmailView(showSignInView: $showSignInView)
            } label: {
                HStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 2)
                            .fill(Color.white)
                            .frame(width: 38, height: 40)
                        
                        Image(systemName: "envelope.fill")
                            .foregroundColor(.blue)
                            .font(.system(size: 14))
                    }
                    
                    Text("Sign up with Email")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Spacer()
                }
                .padding(.leading, 1)
                .frame(height: 43)
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .cornerRadius(3)
                .shadow(radius: 3, x: 2, y: 2)
            }


            // Google Sign In Button
            GoogleSignInButton(viewModel: GoogleSignInButtonViewModel(scheme: .dark, style: .wide, state: .normal)) {
                Task {
                    do {
                        try await viewModel.signInGoogle()
                        showSignInView = false
                    } catch {
                        print("Error signing in with Google: \(error)")
                    }
                }
            }
            
            Spacer()

            // Footer with Terms and Conditions
            VStack(spacing: 4) {
                Text("By continuing, you agree to our")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                
                HStack(spacing: 4) {
                    Text("Terms of Service")
                        .font(.footnote)
                        .foregroundColor(.blue)
                    Text("and")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                    Text("Privacy Policy")
                        .font(.footnote)
                        .foregroundColor(.blue)
                }
            }
        }
        .padding()
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color(red: 173/255, green: 216/255, blue: 230/255), Color(red: 135/255, green: 206/255, blue: 250/255)]), // Soft 
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
        )
        .navigationTitle("Sign In")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        AuthenticationView(showSignInView: .constant(false))
    }
}
