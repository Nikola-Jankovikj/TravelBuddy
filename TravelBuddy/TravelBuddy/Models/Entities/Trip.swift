//
//  Trip.swift
//  TravelBuddy
//
//  Created by Nikola Jankovikj on 8.9.24.
//

import Foundation
import FirebaseCore

struct Trip: Identifiable, Codable, Hashable {
    var id: String
    var destination: Location
    var startDate: Date
    var endDate: Date
    var activities: [Activity]
    var createdByUserID: String
    var participantIDs: [String]
    var requestedUsersIds: [String]
    var photos: [String]
    var videos: [String]
    var status: TripStatus

    func toDictionary() -> [String: Any] {
        return [
            "id": id,
            "destination": [
                "city": destination.city,
                "country": destination.country
            ],
            "startDate": Timestamp(date: startDate),
            "endDate": Timestamp(date: endDate),
            "activities": activities.map { $0.rawValue },
            "createdByUserID": createdByUserID,
            "participantIDs": participantIDs,
            "photos": photos,
            "videos": videos,
            "status": status.rawValue
        ]
    }

    // Conformance to Hashable by leveraging the unique 'id'
    static func == (lhs: Trip, rhs: Trip) -> Bool {
        return lhs.id == rhs.id
    }
    


    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
