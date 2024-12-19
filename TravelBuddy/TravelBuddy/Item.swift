//
//  Item.swift
//  TravelBuddy
//
//  Created by Nikola Jankovikj on 8.9.24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
