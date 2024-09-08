//
//  Match.swift
//  TravelBuddy
//
//  Created by Nikola Jankovikj on 8.9.24.
//

import Foundation

struct Match: Identifiable, Codable {
    var id: String?
    var user1ID: String
    var user2ID: String
    var createdAt: Date
    var messages: [Message]
}
