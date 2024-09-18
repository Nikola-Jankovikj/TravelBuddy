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
                    Text("\(String(describing: viewModel.user?.numberCompletedTrips)) completed trips")
                        .padding(.horizontal)
                    
                    Text("\(String(describing: viewModel.user?.numberPhotosTaken)) photos taken")
                        .padding(.horizontal)
                    
                    Text("\(String(describing: viewModel.user?.numberPhotosTaken)) photos taken")
                        .padding(.horizontal)
                }
                .padding(.vertical)
                
                HStack {
                    
                    Spacer()
                    
                    VStack {
                        Text("\(String(describing: viewModel.user?.name)), \(String(describing: viewModel.user?.age))")
                        
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
                
                Text("\(String(describing: viewModel.user?.description))")
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
