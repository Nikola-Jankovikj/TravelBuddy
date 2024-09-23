//
//  ProfileViewModel.swift
//  TravelBuddy
//
//  Created by Nikola Jankovikj on 14.9.24.
//

import Foundation
import SwiftUI
import PhotosUI

@MainActor
final class ProfileViewModel: ObservableObject {
    
    @Published var authProviders: [AuthProviderOption] = []
    @Published private(set) var user: DbUser? = nil
    
    
    func loadCurrentUser() async throws {
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        self.user = try await UserManager.shared.getUser(userId: authDataResult.uid)
        print("user here is: \(String(describing: self.user))")
    }
    
    func loadAuthProviders() {
        if let providers = try? AuthenticationManager.shared.getProviders() {
            authProviders = providers
        }
    }
    
    func signOut() throws {
        try AuthenticationManager.shared.signOut()
    }
    
    func resetPassword() async throws {
        let authUser = try AuthenticationManager.shared.getAuthenticatedUser()
        
        guard let email = authUser.email else {
            throw URLError(.fileDoesNotExist)
        }
        
        try await AuthenticationManager.shared.resetPassword(email: email)
    }
    
    func saveProfileImage(data: Data) {
        guard let user else { return }
        
        Task {
//            guard let data = try await item.loadTransferable(type: Data.self) else { return }
            let (path, name) = try await StorageManager.shared.saveImage(data: data, userId: user.id)
            try await UserManager.shared.updateUserProfileImagePath(userId: user.id, name: name)
//            try await loadCurrentUser()
        }
    }

    func saveProfileImages(data: [Data]) {
        guard let user else { return }
        
        Task {
//            guard let data = try await item.loadTransferable(type: Data.self) else { return }
            let pathNames = try await StorageManager.shared.saveImages(dataList: data, userId: user.id)
            await withTaskGroup(of: Void.self) { group in
                pathNames.forEach { pathName in
                    group.addTask {
                        do {
                            try await UserManager.shared.updateUserProfileImagePath(userId: user.id, name: pathName.name)
                        } catch {
                            // Handle the error here, e.g., print it or log it
                            print("Failed to update profile image path for \(pathName.name): \(error)")
                        }
                    }
                }
            }

//            try await loadCurrentUser()
        }
    }
    
    func deletePhotos() async throws {
        guard let user else { return }
        
        try await UserManager.shared.deletePhotos(userId: user.id)
        try await StorageManager.shared.deleteImages(userId: user.id)
    }
}
