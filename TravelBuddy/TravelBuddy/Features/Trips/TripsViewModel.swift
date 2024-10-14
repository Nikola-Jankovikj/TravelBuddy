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
    @Published var loggedInUser: DbUser?
    @Published var requestedUsers: [DbUser] = []

    var isUserTripOwner: Bool {
            guard let loggedInUser = Auth.auth().currentUser, let activeTrip = activeTrip else { return false }
        return activeTrip.createdByUserID == loggedInUser.uid
        }
    
    func fetchRequestedUsers() async throws -> [DbUser] {
        guard let requestedUsersIds = activeTrip?.requestedUsersIds else {
            return []
        }

        var users: [DbUser] = []
        for userId in requestedUsersIds {
            let user = try await UserManager.shared.getUser(userId: userId)
            users.append(user)
        }

        return users
    }
    
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
    
    func acceptRequest(from user: DbUser, for trip: Trip) async throws {
        var updatedTrip = trip
        updatedTrip.participantIDs.append(user.id)
        updatedTrip.requestedUsersIds.removeAll { $0 == user.id }
        try TripManager.shared.updateTrip(trip: updatedTrip)
    }

    func rejectRequest(from user: DbUser, for trip: Trip) async throws {
        var updatedTrip = trip
        updatedTrip.requestedUsersIds.removeAll { $0 == user.id }
        try TripManager.shared.updateTrip(trip: updatedTrip)
    }

    deinit {
        stopListeningToTrips()
    }
}
