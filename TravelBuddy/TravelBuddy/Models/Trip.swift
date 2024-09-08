//
//  Trip.swift
//  TravelBuddy
//
//  Created by Nikola Jankovikj on 8.9.24.
//

import Foundation

struct Trip: Identifiable, Codable {
    var id: String?
    var destination: Location
    var startDate: Date
    var endDate: Date
    var activities: [String]
    var createdByUserID: String
    var participantIDs: [String]
    var photos: [String]
    var videos: [String]
    var status: TripStatus
}
