//
//  TripManager.swift
//  TravelBuddy
//
//  Created by Todor Jovanovski on 22.9.24.
//

import Foundation
import FirebaseFirestore

final class TripManager {
    
    static let shared = TripManager()
    private init() { }
    
    private let tripCollection = Firestore.firestore().collection("trips")
    
    private func tripDocument(tripId: String) -> DocumentReference {
        tripCollection.document(tripId)
    }
    
    // Save new trip to Firestore
    func createNewTrip(trip: Trip) throws {
        try tripDocument(tripId: trip.id ?? UUID().uuidString).setData(from: trip)
    }
    
    // Fetch a specific trip by tripId
    func getTrip(tripId: String) async throws -> Trip {
        let snapshot = try await tripDocument(tripId: tripId).getDocument()
        
        guard let data = snapshot.data() else { throw URLError(.badServerResponse) }
        
        return try TripMapper.shared.mapSnapshotToTrip(dict: data)
    }
    
    // Fetch all trips for a specific user
    func getTripsForUser(userId: String) async throws -> [Trip] {
        let snapshot = try await tripCollection
            .whereField("createdByUserID", isEqualTo: userId)
            .getDocuments()
        
        return snapshot.documents.compactMap { document in
            try? TripMapper.shared.mapSnapshotToTrip(dict: document.data())
        }
    }
    
    
    func getCompletedTripsForUser(userId: String) async throws -> [Trip] {
        let snapshot = try await tripCollection
            .whereField("createdByUserID", isEqualTo: userId)
            .whereField("status", isEqualTo: "Completed")
            .getDocuments()

        let trips = snapshot.documents.compactMap { doc -> Trip? in
            return try? doc.data(as: Trip.self)
        }
        return trips
    }
    
    // Update trip information in Firestore
    func updateTrip(trip: Trip) throws {
        guard let tripId = trip.id else { return }
        try tripDocument(tripId: tripId).setData(from: trip)
    }
    
    // Update trip status
    func updateTripStatus(tripId: String, status: TripStatus) async throws {
        try await tripDocument(tripId: tripId).updateData([
            "status": status.rawValue
        ])
    }
    
    // Add photo to the trip
    func addPhotoToTrip(tripId: String, photoUrl: String) async throws {
        let trip = try await getTrip(tripId: tripId)
        var updatedTrip = trip
        updatedTrip.photos.append(photoUrl)
        
        try tripDocument(tripId: tripId).setData(from: updatedTrip)
    }
    
    func listenToActiveTrip(userId: String, completion: @escaping (Trip?) -> Void) -> ListenerRegistration? {
           return tripCollection
               .whereField("createdByUserID", isEqualTo: userId)
               .whereField("status", isEqualTo: "Planned")
               .addSnapshotListener { snapshot, error in
                   guard let documents = snapshot?.documents, error == nil else {
                       completion(nil)
                       return
                   }
                   
                   let activeTrip = documents.compactMap { doc -> Trip? in
                       return try? doc.data(as: Trip.self)
                   }.first
                   
                   completion(activeTrip)
               }
       }

       // Real-time listener for the completed trips
       func listenToCompletedTrips(userId: String, completion: @escaping ([Trip]) -> Void) -> ListenerRegistration? {
           return tripCollection
               .whereField("participantIDs", arrayContains: userId)
               .whereField("status", isEqualTo: "completed")
               .addSnapshotListener { snapshot, error in
                   guard let documents = snapshot?.documents, error == nil else {
                       completion([])
                       return
                   }

                   let completedTrips = documents.compactMap { doc -> Trip? in
                       return try? doc.data(as: Trip.self)
                   }
                   
                   completion(completedTrips)
               }
       }

       // Method to mark a trip as completed
       func completeTrip(trip: Trip) async throws {
           var updatedTrip = trip
           updatedTrip.status = .completed
           try tripCollection.document(trip.id!).setData(from: updatedTrip)
       }
    
    func deleteTrip(tripId: String) async throws {
        try await tripCollection.document(tripId).delete()
    }
}
