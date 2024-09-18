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
    @EnvironmentObject var authUser: AuthDataResultModelEnvironmentVariable
    
    var body: some View {
        VStack {
            
            NavigationStack {
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
            } else {
                Text("user is not found")
            }
        }
        .onAppear {
            Task {
                try? await viewModel.loadCurrentUser()
                viewModel.loadAuthProviders()
            }
        }
        .navigationTitle("Profile")
    }
}

#Preview {
    NavigationStack {
        ProfileView(showSignInView: .constant(false))
            .environmentObject(AuthDataResultModelEnvironmentVariable())
    }
}
