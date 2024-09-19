//
//  ProfileView.swift
//  TravelBuddy
//
//  Created by Nikola Jankovikj on 12.9.24.
//

import SwiftUI
import PhotosUI


struct ProfileView: View {
    
    @StateObject private var viewModel = ProfileViewModel()
    @Binding var showSignInView: Bool
    @EnvironmentObject var authUser: AuthDataResultModelEnvironmentVariable
    @State var showEditProfileView = false
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var imageData: Data? = nil
    
    var body: some View {
        
        VStack {
            ZStack {
                if let imageData, let image = UIImage(data: imageData) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                } else {
                    Color.red.ignoresSafeArea()
                    PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared()) {
                        Text("Select photos")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                    }
                    .onChange(of: selectedItem) { oldValue, newValue in
                        if let newValue {
                            viewModel.saveProfileImage(item: newValue)
                        }
                    }
                }
            }
            .frame(height: 300)
            
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
            
            Spacer()
            
        }
        .onAppear {
            Task {
                do {
                    try await viewModel.loadCurrentUser()
                    if let user = viewModel.user, let photos = viewModel.user?.personalPhotos {
                        if !photos.isEmpty {
                            let data = try await StorageManager.shared.getData(userId: user.id, name: photos[0])
                            self.imageData = data
                        }
                    }
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
