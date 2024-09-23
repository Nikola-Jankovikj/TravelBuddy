//
//  TripsViewModel.swift
//  TravelBuddy
//
//  Created by Todor Jovanovski on 22.9.24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class TripsViewModel: ObservableObject {
    @Published var activeTrip: Trip?
    @Published var completedTrips: [Trip] = []
    @Published var isLoading = false
    @Published var showTripCreation = false
    @Published var errorMessage: String?

    private let tripManager = TripManager.shared
    private var activeTripListener: ListenerRegistration?
    private var completedTripsListener: ListenerRegistration?
    
    func startListeningToTrips() {
        guard let userId = Auth.auth().currentUser?.uid else {
            errorMessage = "Unable to get user ID."
            return
        }

        // Listen for active trip updates in real time
        activeTripListener = tripManager.listenToActiveTrip(userId: userId) { [weak self] activeTrip in
            DispatchQueue.main.async {
                self?.activeTrip = activeTrip
            }
        }

        // Listen for completed trips updates in real time
        completedTripsListener = tripManager.listenToCompletedTrips(userId: userId) { [weak self] completedTrips in
            DispatchQueue.main.async {
                self?.completedTrips = completedTrips
            }
        }
    }

    // Function to stop listeners when the view is deallocated
    func stopListeningToTrips() {
        activeTripListener?.remove()
        completedTripsListener?.remove()
    }

    func completeTrip(trip: Trip) {
        Task {
            do {
                try await tripManager.completeTrip(trip: trip)
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to complete trip: \(error.localizedDescription)"
                }
            }
        }
    }
    
    func createNewTrip(_ trip: Trip) {
        activeTrip = trip
        showTripCreation = false
    }

    deinit {
        stopListeningToTrips()
    }
}
