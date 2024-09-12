//
//  ProfileView.swift
//  TravelBuddy
//
//  Created by Nikola Jankovikj on 12.9.24.
//

import SwiftUI

@MainActor
final class ProfileViewModel: ObservableObject {
    
    
    func signOut() throws {
        try AuthenticationManager.shared.signOut()
    }
    
    func resetPassword() async throws {
        let authUser = try  AuthenticationManager.shared.getAuthenticatedUser()
        
        guard let email = authUser.email else {
            throw URLError(.fileDoesNotExist)
        }
        
        try await AuthenticationManager.shared.resetPassword(email: email)
    }
}

struct ProfileView: View {
    
    @StateObject private var viewModel = ProfileViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        Button("Log out") {
            Task {
                do {
                    try viewModel.signOut()
                    showSignInView = true
                } catch {
                    print("Error \(error)")
                }
            }
        }
        
        Button("Reset password") {
            Task {
                do {
                    try await viewModel.resetPassword()
                    print("PASSWORD RESET!")
                } catch {
                    print("Error \(error)")
                }
            }
        }
    }
}

#Preview {
    ProfileView(showSignInView: .constant(false))
}
