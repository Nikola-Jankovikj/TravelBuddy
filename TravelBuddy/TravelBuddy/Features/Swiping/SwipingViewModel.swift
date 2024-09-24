//
//  SwipingViewModel.swift
//  TravelBuddy
//
//  Created by Nikola Jankovikj on 24.9.24.
//

import Foundation

@MainActor
class SwipingViewModel: ObservableObject {
    @Published var location: String = "Choose location"
    @Published var dateFrom: Date = Date()
    @Published var dateTo: Date = Date()
    @Published var selectedActivities: Set<Activity> = Set<Activity>()
}
