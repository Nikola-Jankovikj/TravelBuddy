//
//  TripCreationViewModel.swift
//  TravelBuddy
//
//  Created by Todor Jovanovski on 24.9.24.
//

import SwiftUI
import Firebase
import FirebaseAuth

@MainActor
final class TripCreationViewModel: ObservableObject {
    @Published var city: String = ""
    @Published var country: String = ""
    @Published var dateFrom = Date()
    @Published var dateTo = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
    @Published var selectedActivities: Set<Activity> = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    var onTripCreated: (Trip) -> Void

    init(onTripCreated: @escaping (Trip) -> Void) {
        self.onTripCreated = onTripCreated
    }

    var isValidTrip: Bool {
        return !city.isEmpty && !country.isEmpty && dateFrom < dateTo
    }

    func createTrip() async {
        guard isValidTrip else {
            errorMessage = "Please fill in all fields correctly."
            return
        }

        errorMessage = nil
        isLoading = true

        // Get current user's ID
        guard let userId = Auth.auth().currentUser?.uid else {
            errorMessage = "Unable to get user ID."
            isLoading = false
            return
        }

        // Create the trip object
        let newTrip = Trip(
            id: UUID().uuidString,
            destination: Location(city: city, country: country),
            startDate: dateFrom,
            endDate: dateTo,
            activities: Array(selectedActivities),
            createdByUserID: userId,
            participantIDs: [],
            photos: [],
            videos: [],
            status: .planned
        )

        // Use TripManager to save the trip
        do {
            try TripManager.shared.createNewTrip(trip: newTrip)
            onTripCreated(newTrip)
        } catch {
            errorMessage = "Failed to create trip: \(error.localizedDescription)"
        }
        isLoading = false
    }
}
