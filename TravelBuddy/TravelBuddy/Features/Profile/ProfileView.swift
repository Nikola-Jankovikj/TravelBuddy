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
    @State var showEditProfileView = false
    
    var body: some View {
        
        VStack {
            Image("image")
            
            VStack {
                HStack {
                    Text("\(viewModel.user?.numberCompletedTrips.description ?? "0") completed trips")
                        .padding(.horizontal)
                    
                    Text("\(viewModel.user?.numberPhotosTaken.description ?? "0") photos taken")
                        .padding(.horizontal)
                    
                    Text("\(viewModel.user?.numberPhotosTaken.description ?? "0") photos taken")
                        .padding(.horizontal)
                }
                .padding(.vertical)
                
                HStack {
                    Spacer()
                    
                    VStack {
                        Text("\(viewModel.user?.name.description ?? "Unknown"), \(viewModel.user?.age.description ?? "18")")
                        
                        Text("\(String(describing: viewModel.user?.location))")
                    }
                    
                    Spacer()
                    
                    NavigationStack {
                        Button("Edit Profile") {
                            showEditProfileView = true
                        }
                    }
                    .navigationDestination(isPresented: $showEditProfileView) {
                        EditProfileView(showSignInView: $showSignInView)
                    }
                    
                    Spacer()
                }
                .padding(.vertical)
                
                HStack {
                    Text("\(viewModel.user?.description.description ?? "No description")")
                        .multilineTextAlignment(.leading)
                        .padding()
                    
                    Spacer()
                }
            }
        }
        .onAppear {
            Task {
                do {
                    try await viewModel.loadCurrentUser()
                } catch {
                    print("error \(error)")
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        ProfileView(showSignInView: .constant(false))
            .environmentObject(AuthDataResultModelEnvironmentVariable())
    }
}
