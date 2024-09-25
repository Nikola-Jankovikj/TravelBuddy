//
//  Trip.swift
//  TravelBuddy
//
//  Created by Todor Jovanovski on 22.9.24.
//

import Foundation
import FirebaseCore
extension Trip {
    func toDictionary() -> [String: Any] {
        return [
            "id": id ?? "",
            "destination": ["name": destination],
            "startDate": Timestamp(date: startDate),
            "endDate": Timestamp(date: endDate),
            "activities": activities.map { $0.rawValue },
            "createdByUserID": createdByUserID,
            "participantIDs": participantIDs,
            "photos": photos,
            "videos": videos,
            "status": status
        ]
    }
}
