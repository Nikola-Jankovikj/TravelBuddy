//
//  CompletedTripsView.swift
//  TravelBuddy
//
//  Created by Todor Jovanovski on 22.9.24.
//

import SwiftUI

struct CompletedTripsView: View {
    @StateObject private var viewModel = CompletedTripsViewModel()
    @State private var navigateToTripDetail: Trip? = nil
    @State private var shouldNavigateBack = true

    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView()
            } else if viewModel.completedTrips.isEmpty {
                Text("No completed trips")
                    .font(.headline)
                    .padding()
            } else {
                List(viewModel.completedTrips) { trip in
                    NavigationLink(destination: TripDetailView(trip: trip, shouldNavigateBack: .constant(true))) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Trip to \(trip.destination.city), \(trip.destination.country)")
                                    .font(.headline)
                                Text("From: \(formattedDate(trip.startDate)) To: \(formattedDate(trip.endDate))")
                                    .font(.subheadline)
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
            viewModel.loadCompletedTrips()
        }
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

#Preview {
    CompletedTripsView()
}
