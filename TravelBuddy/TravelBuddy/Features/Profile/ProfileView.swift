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
        GeometryReader { geometry in
            ZStack {
                VStack {
                    ProfileImagePickerView(
                        selectedItem: $selectedItem,
                        imageData: $imageData,
                        width: geometry.size.width,
                        saveProfileImage: viewModel.saveProfileImage
                    )
                    .frame(height: geometry.size.height / 2)
                }
                
                ProfileInformationView(
                    numberCompletedTrips: viewModel.user?.numberCompletedTrips ?? 0,
                    numberPhotosTaken: viewModel.user?.numberPhotosTaken ?? 0,
                    favoriteActivity: viewModel.user?.favoriteActivity ?? "Nothing",
                    name: viewModel.user?.name ?? "Name",
                    age: viewModel.user?.age ?? 18,
                    location: viewModel.user?.location ?? Location(city: "Skopje", country: "Macedonia"),
                    description: viewModel.user?.description ?? "No description",
                    showEditProfileView: $showEditProfileView, 
                    showSignInView: $showSignInView)
                .frame(maxWidth: geometry.size.width)
                .frame(height: geometry.size.height / 2)
                .background(Color.white)
                .cornerRadius(30)
                .shadow(radius: 10)
                .offset(y: geometry.size.height / 2 - 50)
            }
            .onAppear {
                Task {
                    do {
                        try await viewModel.loadCurrentUser()
                        if let user = viewModel.user, let photos = viewModel.user?.personalPhotos {
                            if !photos.isEmpty {
                                let data = try await StorageManager.shared.getData(userId: user.id, name: photos.last!)
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
}

#Preview {
    NavigationStack {
        ProfileView(showSignInView: .constant(false))
            .environmentObject(AuthDataResultModelEnvironmentVariable())
    }
}
