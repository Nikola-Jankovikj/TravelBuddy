//
//  GroupChat.swift
//  TravelBuddy
//
//  Created by Nikola Jankovikj on 8.9.24.
//

import Foundation

struct GroupChat: Identifiable, Codable {
    var id: String?
    var participantIDs: [String]
    var createdAt: Date
    var messages: [Message]
}

