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
            ZStack {
                Color.red.ignoresSafeArea()
                Text("Placeholder for image")
                    .font(.largeTitle)
                    .foregroundColor(.white)
            }
//            .frame(height: 300)
            
            VStack {
                HStack {
                    Text("\(viewModel.user?.numberCompletedTrips.description ?? "0") completed trips")
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    Spacer()
                    
                    Text("\(viewModel.user?.numberPhotosTaken.description ?? "0") photos taken")
                        .padding(.horizontal)
                    
                    Spacer()
                    
                    Text("\(viewModel.user?.numberPhotosTaken.description ?? "0") photos taken")
                        .padding(.horizontal)
                    
                    Spacer()
                }
                .padding(.vertical)
                
                HStack {
                    Spacer()
                    
                    VStack {
                        Text("\(viewModel.user?.name.description ?? "Unknown"), \(viewModel.user?.age.description ?? "18")")
                            .bold()
                            .font(.title)
                        
                        Text("\(viewModel.user?.location.city.description ?? "City"), \(viewModel.user?.location.country.description ?? "Country")")
                    }
                    
                    Spacer()
                    
                    NavigationStack {
                        Button("Edit Profile") {
                            showEditProfileView = true
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(height: 40)
                        .frame(maxWidth: 120)
                        .background(Color.blue)
                        .cornerRadius(20)
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
            .padding(.vertical)
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
