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
    @State private var selectedItem: [PhotosPickerItem] = []
    @State private var imageData: [Data?] = []
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack {
                    ProfileImagePickerView(
                        selectedItems: $selectedItem,
                        imageData: $imageData,
                        width: geometry.size.width,
                        saveProfileImages: viewModel.saveProfileImages,
                        saveProfileImage: viewModel.saveProfileImage,
                        deleteImages: viewModel.deletePhotos
                    )
                    .frame(height: geometry.size.height / 2)
                }
                
                ProfileInformationView(
                    user: viewModel.user ?? DbUser(id: "0", name: "Name", age: 18, location: Location(city: "Skopje", country: "Macedonia"), description: "Description", favoriteActivity: "Activity", dateCreated: Date.now, dateUpdated: Date.now),
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
                        if let user = viewModel.user {
                            if !user.personalPhotos.isEmpty {
                                let data = try await StorageManager.shared.getAllData(userId: user.id)
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
