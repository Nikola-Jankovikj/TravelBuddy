//
//  TripDetailViewModel.swift
//  TravelBuddy
//
//  Created by Todor Jovanovski on 22.9.24.
//

import Foundation

@MainActor
class TripDetailViewModel: ObservableObject {
    @Published var trip: Trip
    @Published var isLoading = false
    @Published var loggedInUserId: String = ""
    @Published var errorMessage: ErrorMessage?
    @Published var showAlertDialog: Bool = false
    

    private let tripManager = TripManager.shared

    init(trip: Trip) {
        self.trip = trip
        do {
           self.loggedInUserId = try AuthenticationManager.shared.getAuthenticatedUser().uid
        }
        catch{
            print("Error fetching authenticated user: \(error.localizedDescription)")
        }
    }
    
    func toggleShowAlertDialog() {
        showAlertDialog.toggle()
    }

    func refreshTrip() {
        let tripId = trip.id
        
        isLoading = true
        Task {
            do {
                let updatedTrip = try await tripManager.getTrip(tripId: tripId)
                self.trip = updatedTrip
            } catch {
                errorMessage = ErrorMessage(message: "Failed to refresh trip: \(error.localizedDescription)")
            }
            isLoading = false
        }
    }
    
    func fetchParticipants() async throws -> [DbUser] {
        let participantIDs = trip.participantIDs
        var participants: [DbUser] = []
        for userId in participantIDs {
            let user = try await UserManager.shared.getUser(userId: userId)
            participants.append(user)
        }
        
        return participants
    }
    
    func updateTripStatus(_ status: TripStatus) {
        let tripId = trip.id
        
        isLoading = true
        Task {
            do {
                try await tripManager.updateTripStatus(tripId: tripId, status: status)
                trip.status = status
            } catch {
                errorMessage = ErrorMessage(message: "Failed to update trip status: \(error.localizedDescription)")
            }
            isLoading = false
        }
    }
    
    func deleteTrip(tripId: String) async throws {
        try await tripManager.deleteTrip(tripId: tripId)
    }
    
    func completeTrip(trip: Trip) {
        Task {
            do {
                try await tripManager.completeTrip(trip: trip)
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = ErrorMessage(message: "Failed to complete trip: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func leaveTrip(trip: Trip) {
        Task {
            do {
                self.trip.participantIDs.removeAll { participantId in
                    participantId == loggedInUserId
                }
                try tripManager.updateTrip(trip: self.trip)
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = ErrorMessage(message: "Failed to complete trip: \(error.localizedDescription)")
                }
            }
        }
    }
}
