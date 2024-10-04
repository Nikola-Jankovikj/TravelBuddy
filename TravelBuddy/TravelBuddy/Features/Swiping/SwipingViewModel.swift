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
    @Published var photos: [Data] = []
    @Published var tripUser: DbUser? = nil
    @Published var showingTrip: Trip? = nil
    
    func getTripsWithFilter(loggedInUser: DbUser) {
        if location.description == "" {
            return
        }
        
//        TripManager.shared.fetchAllTripsWithFilters(location: location, dateFrom: dateFrom, dateTo: dateTo, activities: selectedActivities) { trips, error in
//            if let error = error {
//                print("Error fetching trips: \(error.localizedDescription)")
//            } else if let trips = trips {
//                trips.filter()
//                print("Fetched trips: \(trips)")
//                self.trips = trips
//            } else {
//                print("No trips found.")
//            }
        
        TripManager.shared.fetchAllTripsWithFilters(location: location, dateFrom: dateFrom, dateTo: dateTo, activities: selectedActivities) { trips, error in
            if let error = error {
                print("Error fetching trips: \(error.localizedDescription)")
            } else if let trips = trips {
                
                Task {
                    // Create an empty array to hold the filtered trips
                    var filteredTrips = [Trip]()
                    
                    // Loop through the trips and filter them using the async function
                    for trip in trips {
                        if await self.checkIfShouldShowTrip(trip: trip, loggedInUser: loggedInUser) {
                            filteredTrips.append(trip)
                        }
                    }
                    
                    // Update the UI with the filtered trips
                    print("Filtered trips: \(filteredTrips)")
                    self.trips = filteredTrips
                    self.showingTrip = self.trips.first
                }
                
            } else {
                print("No trips found.")
            }
        }
        }
//    }
    
    func getUserFromTrip(trip: Trip) async throws {
        let userId = trip.createdByUserID
        tripUser = try await UserManager.shared.getUser(userId: userId)
    }
    
    func checkIfShouldShowTrip(trip: Trip, loggedInUser: DbUser) async -> Bool {
        if loggedInUser.id == trip.createdByUserID || loggedInUser.rejectedTripIds.contains(trip.id) || loggedInUser.likedTripIds.contains(trip.id) {
            return false
        }
        return true
    }
    
    func fetchPhotosFromUser(userId: String) async {
        guard let photos = try? await StorageManager.shared.getAllData(userId: userId) else {
            self.photos = []
            return
        }
        self.photos = photos
    }
    
    func addToLikedTrips(trip: Trip) async throws -> Void {
        guard let authDataResultModel = try? AuthenticationManager.shared.getAuthenticatedUser() else {
            return
        }
//        guard var user = try? await UserManager.shared.getUser(userId: authDataResultModel.uid) else {
//            return
//        }
//        user.likedTripIds.append(trip.id)
        try await UserManager.shared.updateLikedTripIds(userId: authDataResultModel.uid, tripId: trip.id)
        trips.removeFirst()
        showingTrip = trips.first
    }
    
    func addToDislikedTrips(trip: Trip) async throws -> Void {
        guard let authDataResultModel = try? AuthenticationManager.shared.getAuthenticatedUser() else {
            return
        }
//        guard var user = try? await UserManager.shared.getUser(userId: authDataResultModel.uid) else {
//            return
//        }
//        user.rejectedTripIds.append(trip.id)
        try await UserManager.shared.updateRejectedTripIds(userId: authDataResultModel.uid, tripId: trip.id)
        trips.removeFirst()
        showingTrip = trips.first
    }
}
