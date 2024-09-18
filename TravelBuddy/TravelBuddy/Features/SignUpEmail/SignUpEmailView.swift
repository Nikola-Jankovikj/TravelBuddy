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
            
            NavigationStack {
                Button("Continue") {
                    showCreateProfileView = true
                }
            }
            .navigationDestination(isPresented: $showCreateProfileView) {
                CreateProfileView(showSignInView: $showSignInView, email: $viewModel.email, password: $viewModel.password)
            }
        }
        .padding()
        .navigationTitle("Sign In With Email")
    }
}

#Preview {
    SignUpEmailView(showSignInView: .constant(false))
}
