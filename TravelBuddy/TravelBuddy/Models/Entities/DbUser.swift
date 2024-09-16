//
//  User.swift
//  TravelBuddy
//
//  Created by Nikola Jankovikj on 8.9.24.
//

import Foundation

struct DbUser: Identifiable, Codable {
    var id: String
    var name: String
    var age: Int
    var personalPhotos: [String] = []
    var location: Location
    var description: String
    var numberCompletedTrips: Int = 0
    var numberPhotosTaken: Int = 0
    var favoriteActivity: String
    var likedUserIds: [String] = []
    var rejectedUserIds: [String] = []
    var dateCreated: Date
    var dateUpdated: Date
}
