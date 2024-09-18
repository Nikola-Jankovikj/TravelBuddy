//
//  LogInWithEmailView.swift
//  TravelBuddy
//
//  Created by Nikola Jankovikj on 17.9.24.
//

import SwiftUI

struct LogInWithEmailView: View {
    
    @StateObject private var viewModel = LogInWithEmailViewModel()
    @EnvironmentObject var authUser: AuthDataResultModelEnvironmentVariable
    @Binding var showSignInView: Bool

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

            Button {
                Task {
                    do {
                        try await viewModel.signIn()
                        let tmpAuthData = try AuthenticationManager.shared.getAuthenticatedUser()
                        authUser.saveAuthData(newAuthData: tmpAuthData)
                        showSignInView = false
                    } catch {
                        print(error)
                    }
                }
            } label: {
                Text("Log In")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
        }
        .padding()
    }
}

//#Preview {
//    LogInWithEmailView(showSignInView: .constant(true), authUser: $authUser)
//}
