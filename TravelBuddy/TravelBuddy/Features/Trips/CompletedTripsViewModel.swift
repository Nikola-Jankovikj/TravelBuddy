//
//  CompletedTripsViewModel.swift
//  TravelBuddy
//
//  Created by Todor Jovanovski on 22.9.24.
//

import Foundation
import FirebaseAuth

@MainActor
class CompletedTripsViewModel: ObservableObject {
    @Published var completedTrips: [Trip] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    

    private let tripManager = TripManager.shared

    func loadCompletedTrips() {
        guard let userId = Auth.auth().currentUser?.uid else {
            errorMessage = "Unable to get user ID."
            return
        }

        isLoading = true
        Task {
            do {
                let trips = try await tripManager.getCompletedTripsForUser(userId: userId)
                self.completedTrips = trips
            } catch {
                errorMessage = "Failed to load completed trips: \(error.localizedDescription)"
            }
            isLoading = false
        }
    }
}
