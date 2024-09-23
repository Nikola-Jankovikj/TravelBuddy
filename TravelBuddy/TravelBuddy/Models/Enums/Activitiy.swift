//
//  Activitiy.swift
//  TravelBuddy
//
//  Created by Todor Jovanovski on 22.9.24.
//

import Foundation
enum Activity: String, CaseIterable, Identifiable, Codable {
    case sightseeing = "Sightseeing"
    case partying = "Partying"
    case shopping = "Shopping"
    case chilling = "Chilling"
    var id: String { self.rawValue }
}
