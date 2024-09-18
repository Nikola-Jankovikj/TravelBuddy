//
//  LogInWithEmailViewModel.swift
//  TravelBuddy
//
//  Created by Nikola Jankovikj on 17.9.24.
//

import Foundation

final class LogInWithEmailViewModel : ObservableObject {
    @Published var email = ""
    @Published var password = ""
    
    func signIn() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("No email or password fouond.")
            return
        }
        
        try await AuthenticationManager.shared.signInUser(email: email, password: password)
    }
}
