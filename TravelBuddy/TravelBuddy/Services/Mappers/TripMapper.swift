//
//  TripMapper.swift
//  TravelBuddy
//
//  Created by Todor Jovanovski on 22.9.24.
//

import Foundation
import FirebaseCore
final class TripMapper {
    
    static let shared = TripMapper()
    private init() { }
    
    func mapSnapshotToTrip(dict: [String: Any]) throws -> Trip {
        let id = dict["id"] as? String ?? UUID().uuidString
        let destinationDict = dict["destination"] as? [String: Any]
        let startDate = (dict["startDate"] as? Timestamp)?.dateValue() ?? Date()
        let endDate = (dict["endDate"] as? Timestamp)?.dateValue() ?? Date()
        let activities = (dict["activities"] as? [String])?.compactMap { Activity(rawValue: $0) } ?? []
        let createdByUserID = dict["createdByUserID"] as? String ?? ""
        let participantIDs = dict["participantIDs"] as? [String] ?? []
        let requestedUsersIds = dict["requestedUsersIds"] as? [String] ?? []
        let photos = dict["photos"] as? [String] ?? []
        let videos = dict["videos"] as? [String] ?? []
        let status = TripStatus(rawValue: dict["status"] as? String ?? "") ?? .planned
        
        let destination = Location(
            city: destinationDict?["city"] as? String ?? "",
            country: destinationDict?["country"] as? String ?? ""
        )
        
        return Trip(
            id: id,
            destination: destination,
            startDate: startDate,
            endDate: endDate,
            activities: activities,
            createdByUserID: createdByUserID,
            participantIDs: participantIDs,
            requestedUsersIds: requestedUsersIds,
            photos: photos,
            videos: videos,
            status: status
        )
    }
}
