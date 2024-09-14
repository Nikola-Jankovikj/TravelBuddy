//
//  ProfileView.swift
//  TravelBuddy
//
//  Created by Nikola Jankovikj on 12.9.24.
//

import SwiftUI

struct ProfileView: View {
    
    @StateObject private var viewModel = ProfileViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        VStack {
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
            
            if viewModel.authProviders.contains(.email) {
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
            
            if let user = viewModel.user {
                Text("UserId: \(user.id)")
            }
        }
        .task {
            try? await viewModel.loadCurrentUser()
            viewModel.loadAuthProviders()
        }
        .navigationTitle("Profile")
    }
}

#Preview {
    NavigationStack {
        ProfileView(showSignInView: .constant(false))
    }
}
