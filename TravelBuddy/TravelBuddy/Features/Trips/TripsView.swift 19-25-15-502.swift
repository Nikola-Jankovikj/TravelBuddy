//
//  ActiveTripView.swift
//  TravelBuddy
//
//  Created by Todor Jovanovski on 22.9.24.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseAuth

struct TripsView: View {
    @State private var activeTrip: Trip? = nil
    @State private var showTripCreationView = false

    var body: some View {
        VStack {
            if let trip = activeTrip {
                TripDetailView(trip: trip)
            } else {
                NoTripView(showTripCreationView: $showTripCreationView)
            }
        }
        .onAppear {
            fetchActiveTrip()
        }
        .sheet(isPresented: $showTripCreationView) {
            TripCreationView(onTripCreated: { newTrip in
                self.activeTrip = newTrip
                self.showTripCreationView = false
            })
        }
    }

    private func fetchActiveTrip() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        db.collection("trips")
            .whereField("createdByUserID", isEqualTo: userId)
            .whereField("status", isEqualTo: TripStatus.planned)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching trip: \(error)")
                    return
                }
                if let documents = snapshot?.documents, !documents.isEmpty {
                    let trip = try? documents.first?.data(as: Trip.self)
                    self.activeTrip = trip
                }
            }
    }
}

struct NoTripView: View {
    @Binding var showTripCreationView: Bool

    var body: some View {
        VStack {
            Text("You don't have an active trip.")
                .font(.headline)
                .padding()

            Button(action: {
                showTripCreationView = true
            }) {
                Text("Create a Trip")
                    .font(.title2)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
    }
}

#Preview{
    TripsView()
}
