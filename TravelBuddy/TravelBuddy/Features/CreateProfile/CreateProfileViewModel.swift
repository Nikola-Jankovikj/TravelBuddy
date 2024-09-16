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
    @Published var favoriteActivity = ""
    @Published var description = ""
    
    @Published var locationManager = LocationManager.shared

    func updateLocation() {
        if let fetchedCity = locationManager.city, let fetchedCountry = locationManager.country {
            self.city = fetchedCity
            self.country = fetchedCountry
        } else {
            print("Location data not available yet.")
        }
    }

    func createProfile() throws {
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        
        let location = Location(city: city, country: country)
        
        let user = DbUser(
            id: authDataResult.uid,
            name: name,
            age: age,
            location: location,
            description: description,
            favoriteActivity: favoriteActivity,
            dateCreated: Date(),
            dateUpdated: Date()
        )
        
        try UserManager.shared.createNewUser(user: user)
    }
}
