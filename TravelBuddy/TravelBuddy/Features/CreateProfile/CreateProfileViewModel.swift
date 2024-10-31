//
//  CreateProfileViewModel.swift
//  TravelBuddy
//
//  Created by Nikola Jankovikj on 15.9.24.
//

import Foundation
import SwiftUI
import Combine
import CoreLocation

@MainActor
final class CreateProfileViewModel : ObservableObject {
    
    @Published var name = ""
    @Published var age = 18
    @Published var city = ""
    @Published var country = ""
    @Published var favoriteActivity : Activity = .sightseeing
    @Published var description = ""
    @Published var location = Location(city: "", country: "")
    
    @Published var locationManager = LocationManager.shared

    func updateLocation() {
        self.city = LocationManager.shared.city
        self.country = LocationManager.shared.country
        self.location = Location(city: city, country: country)
    }

    func createProfile() throws {
        updateLocation()
        
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        
        let location = Location(city: city, country: country)
        
        let user = DbUser(
            id: authDataResult.uid,
            name: name,
            age: age,
            location: location,
            description: description,
            favoriteActivity: favoriteActivity.rawValue,
            dateCreated: Date(),
            dateUpdated: Date()
        )
        
        try UserManager.shared.createNewUser(user: user)
    }
    
    func updateLocationIfNeeded() {
            self.city = LocationManager.shared.city
            self.country = LocationManager.shared.country
            self.location = Location(city: city, country: country)
        }
    
    
    func signUp(email: String, password: String) async throws { //add validation for email/password
        guard !email.isEmpty, !password.isEmpty else {
            print("No email or password fouond.")
            return
        }
        
        try await AuthenticationManager.shared.createUser(email: email, password: password)
    }
}
