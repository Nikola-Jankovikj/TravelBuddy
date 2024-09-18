//
//  SignUpEmailView.swift
//  TravelBuddy
//
//  Created by Nikola Jankovikj on 12.9.24.
//

import SwiftUI

struct SignUpEmailView: View {
    
    @StateObject private var viewModel = SignUpEmailViewModel()
    @Binding var showSignInView: Bool
    @State var showCreateProfileView = false
    
    var body: some View {
        VStack {
            TextField("Email...", text: $viewModel.email)
                .padding()
                .background(Color.gray.opacity(0.4))
                .cornerRadius(10)
            
            SecureField("Password...", text: $viewModel.password)
                .padding()
                .background(Color.gray.opacity(0.4))
                .cornerRadius(10)
            
//            Button {
//                Task {
//                    do {
//                        try await viewModel.signUp()
//                        showSignInView = false
//                        return
//                    } catch {
//                        print(error)
//                    }
//                }
//            } label: {
//                Text("Sign Up")
//                    .font(.headline)
//                    .foregroundColor(.white)
//                    .frame(height: 55)
//                    .frame(maxWidth: .infinity)
//                    .background(Color.blue)
//                    .cornerRadius(10)
//            }
            NavigationStack {
                Button("Continue") {
                    Task {
                        do {
                            try await viewModel.signUp()
                            showCreateProfileView = true
                        } catch {
                            print(error)
                        }
                    }
                }
            }
            .navigationDestination(isPresented: $showCreateProfileView) {
                CreateProfileView(showSignInView: $showSignInView)
            }
        }
        .padding()
        .navigationTitle("Sign In With Email")
    }
}

#Preview {
    SignUpEmailView(showSignInView: .constant(false))
}
