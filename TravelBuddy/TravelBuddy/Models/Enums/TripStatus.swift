//
//  TripStatus.swift
//  TravelBuddy
//
//  Created by Nikola Jankovikj on 8.9.24.
//

import Foundation

enum TripStatus : String, CaseIterable, Identifiable, Codable{
    case planned = "Planned"
    case completed = "Completed"
    case cancelled = "Cancelled"
    var id: String { self.rawValue }
}
