//
//  Message.swift
//  TravelBuddy
//
//  Created by Nikola Jankovikj on 8.9.24.
//

import Foundation

struct Message: Identifiable, Codable {
    var id: String?
    var senderID: String
    var content: String
    var timestamp: Date
}
