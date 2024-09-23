//
//  Trip.swift
//  TravelBuddy
//
//  Created by Nikola Jankovikj on 8.9.24.
//

import Foundation
import FirebaseCore

struct Trip: Identifiable, Codable {
    var id: String?
    var destination: Location
    var startDate: Date
    var endDate: Date
    var activities: [Activity]
    var createdByUserID: String
    var participantIDs: [String]
    var photos: [String]
    var videos: [String]
    var status: TripStatus
    
    func toDictionary() -> [String: Any] {
            return [
                "id": id ?? UUID().uuidString,
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

}
