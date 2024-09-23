//
//  EditProfileView.swift
//  TravelBuddy
//
//  Created by Nikola Jankovikj on 18.9.24.
//

import SwiftUI

struct EditProfileView: View {
    
    @StateObject private var viewModel = EditProfileViewModel()
    @Binding var showSignInView: Bool
    @State var showCameraView: Bool = false
    
    var body: some View {
        VStack {
            
//            NavigationStack {
//                Button("Change Profile Picture") {
//                    showCameraView = true
//                }
//            }
//            .navigationDestination(isPresented: $showCameraView) {
//                CameraContentView()
//            }
            
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
        }
        .onAppear {
//            Task {
//                try? await viewModel.loadCurrentUser()
                viewModel.loadAuthProviders()
//            }
        }
        .navigationTitle("Profile")
    }
}

#Preview {
    EditProfileView(showSignInView: .constant(false))
}
