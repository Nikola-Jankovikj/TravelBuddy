//
//  Location.swift
//  TravelBuddy
//
//  Created by Nikola Jankovikj on 8.9.24.
//

import Foundation

struct Location : Codable, CustomStringConvertible {
    public var description: String  { return "\(city), \(country)" }
    
    var city: String
    var country: String
}
