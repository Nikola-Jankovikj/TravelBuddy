//
//  SignInEmailViewModel.swift
//  TravelBuddy
//
//  Created by Nikola Jankovikj on 14.9.24.
//

import Foundation

final class SignInEmailViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    
    func signUp() async throws { //add validation for email/password
        guard !email.isEmpty, !password.isEmpty else {
            print("No email or password fouond.")
            return
        }
        
        try await AuthenticationManager.shared.createUser(email: email, password: password)
    }
    
    func signIn() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("No email or password fouond.")
            return
        }
        
        try await AuthenticationManager.shared.signInUser(email: email, password: password)
    }
}
