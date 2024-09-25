//
//  SwipingViewModel.swift
//  TravelBuddy
//
//  Created by Nikola Jankovikj on 24.9.24.
//

import Foundation

@MainActor
class SwipingViewModel: ObservableObject {
    let id = UUID()
    @Published var location: Location = Location(city: "", country: "")
    @Published var dateFrom: Date = Date()
    @Published var dateTo: Date = Date()
    @Published var selectedActivities: Set<Activity> = Set<Activity>()
    @Published var showCitySearchView = false
    @Published var trips: [Trip] = []
    
    func getTripsWithFilter() {
        if location.description == "" {
            return
        }
        
        TripManager.shared.fetchAllTripsWithFilters(location: location, dateFrom: dateFrom, dateTo: dateTo, activities: selectedActivities) { trips, error in
            if let error = error {
                print("Error fetching trips: \(error.localizedDescription)")
            } else if let trips = trips {
                print("Fetched trips: \(trips)")
                self.trips = trips
            } else {
                print("No trips found.")
            }
        }
    }
}
