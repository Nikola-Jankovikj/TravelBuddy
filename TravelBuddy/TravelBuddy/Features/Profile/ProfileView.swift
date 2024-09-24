//
//  ProfileView.swift
//  TravelBuddy
//
//  Created by Nikola Jankovikj on 12.9.24.
//

import SwiftUI
import PhotosUI

struct ProfileView: View {
    
    var user: DbUser
    @StateObject private var viewModel = ProfileViewModel()
    @Binding var showSignInView: Bool
    @State var showEditProfileView = false
    @State private var selectedItem: [PhotosPickerItem] = []
    @Binding var imageData: [Data]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack {
                    ProfileImagePickerView(
                        selectedItems: $selectedItem,
                        imageData: $imageData,
                        user: user,
                        width: geometry.size.width,
                        saveProfileImages: viewModel.saveProfileImages,
                        saveProfileImage: viewModel.saveProfileImage,
                        deleteImages: viewModel.deletePhotos
                    )
                    .frame(height: geometry.size.height / 2)
                }
                
                ProfileInformationView(
                    user: user,
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
                        if !user.personalPhotos.isEmpty {
                            let data = try await StorageManager.shared.getAllData(userId: user.id)
                            self.imageData = data
                        }
                    } catch {
                        print("error \(error)")
                    }
                }
            }
        }
    }
}
//
//#Preview {
//    NavigationStack {
//        ProfileView(showSignInView: .constant(false))
//            .environmentObject(AuthDataResultModelEnvironmentVariable())
//    }
//}
