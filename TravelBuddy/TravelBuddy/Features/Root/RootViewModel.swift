//
//  RootViewModel.swift
//  TravelBuddy
//
//  Created by Nikola Jankovikj on 24.9.24.
//

import Foundation

@MainActor
final class RootViewModel : ObservableObject {
    @Published var showLoadingScreen: Bool = true
    @Published var showSignInView: Bool = true
    @Published var isDataFetched: Bool = false
    @Published var user: DbUser? = nil
    @Published var imageData: [Data] = []
    
    func checkLogin() {
        if let _ = try? AuthenticationManager.shared.getAuthenticatedUser() {
            showSignInView = false
        }
    }
    
    func fetchData() async throws {
        showLoadingScreen = true
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        self.user = try await UserManager.shared.getUser(userId: authDataResult.uid)
        let tmpUser = retreiveUser()
        guard let userImages = try? await StorageManager.shared.getAllData(userId: tmpUser.id) else {
            print("cannot find user images")
            return
        }
        self.imageData = userImages
        print("user here is: \(String(describing: self.user))")
        showLoadingScreen = false
        isDataFetched = true
    }
    
    func retreiveUser() -> DbUser {
        guard let user else {
            return DbUser(id: "0", name: "Name", age: 18, location: Location(city: "Skopje", country: "Macedonia"), description: "Description", favoriteActivity: "Activity", dateCreated: Date.now, dateUpdated: Date.now)
        }
        return user
    }
}
