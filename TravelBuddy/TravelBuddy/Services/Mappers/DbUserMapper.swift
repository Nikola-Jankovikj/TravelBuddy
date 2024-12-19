//
//  DbUserMapper.swift
//  TravelBuddy
//
//  Created by Nikola Jankovikj on 14.9.24.
//

import Foundation

class DbUserMapper {
    
    static let shared = DbUserMapper()
    private init() { }
    
    func mapSnapshotToDbUser(dict: [String: Any]) -> DbUser {
        
        let id = dict["id"] as? String ?? UUID().uuidString
        let name = dict["name"] as? String ?? "Unknown"
        let age = dict["age"] as? Int ?? 0
        let personalPhotos = dict["personalPhotos"] as? [String] ?? []
        
        var location: Location?
        if let locationDict = dict["location"] as? [String: Any],
           let city = locationDict["city"] as? String,
           let country = locationDict["country"] as? String {
            location = Location(city: city, country: country)
        } else {
            location = Location(city: "Unknown", country: "Unknown")
        }
        
        let description = dict["description"] as? String ?? "No description"
        let numberCompletedTrips = dict["numberCompletedTrips"] as? Int ?? 0
        let numberPhotosTaken = dict["numberPhotosTaken"] as? Int ?? 0
        let favoriteActivity = dict["favoriteActivity"] as? String ?? "None"
        let likedTripIds = dict["likedTripIds"] as? [String] ?? []
        let rejectedTripIds = dict["rejectedTripIds"] as? [String] ?? []
        let instagram = dict["instagram"] as? String ?? "No Instagram"
        
        let dateCreated: Date
        if let dateCreatedStr = dict["dateCreated"] as? String, let date = ISO8601DateFormatter().date(from: dateCreatedStr) {
            dateCreated = date
        } else {
            dateCreated = Date()
        }
        
        let dateUpdated: Date
        if let dateUpdatedStr = dict["dateUpdated"] as? String, let date = ISO8601DateFormatter().date(from: dateUpdatedStr) {
            dateUpdated = date
        } else {
            dateUpdated = Date()
        }
        
        return DbUser(
            id: id,
            name: name,
            age: age,
            personalPhotos: personalPhotos,
            location: location!,
            description: description,
            numberCompletedTrips: numberCompletedTrips,
            numberPhotosTaken: numberPhotosTaken,
            favoriteActivity: favoriteActivity,
            likedTripIds: likedTripIds,
            rejectedTripIds: rejectedTripIds,
            dateCreated: dateCreated,
            dateUpdated: dateUpdated,
            instagram: instagram
        )
    }
}
