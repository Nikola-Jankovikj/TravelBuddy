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
    @Published var errorMessage: ErrorMessage?
    

    private let tripManager = TripManager.shared

    init(trip: Trip) {
        self.trip = trip
    }

    func refreshTrip() {
        guard let tripId = trip.id else { return }
        
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
    
    func updateTripStatus(_ status: TripStatus) {
        guard let tripId = trip.id else { return }
        
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
}
