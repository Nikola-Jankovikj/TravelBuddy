//
//  TripDetailView.swift
//  TravelBuddy
//
//  Created by Todor Jovanovski on 22.9.24.
//

import SwiftUI

struct TripDetailView: View {
    @StateObject private var viewModel: TripDetailViewModel
    @State private var showingDeleteConfirmation = false
    @Binding var shouldNavigateBack: Bool
    @Environment(\.presentationMode) var presentationMode

    init(trip: Trip, shouldNavigateBack: Binding<Bool>) {
        _viewModel = StateObject(wrappedValue: TripDetailViewModel(trip: trip))
        self._shouldNavigateBack = shouldNavigateBack
    }

    var body: some View {
            VStack(alignment: .leading, spacing: 16) {
                // Destination Info
                Text("Trip to \(viewModel.trip.destination.city), \(viewModel.trip.destination.country)")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .padding(.top)
                    .padding(.horizontal)

                // Dates Section
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("From")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text(formattedDate(viewModel.trip.startDate))
                            .font(.headline)
                    }
                    Spacer()
                    VStack(alignment: .leading, spacing: 4) {
                        Text("To")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text(formattedDate(viewModel.trip.endDate))
                            .font(.headline)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .padding(.horizontal)

                // Activities Section
                Text("Activities")
                    .font(.headline)
                    .padding(.horizontal)

                VStack(alignment: .leading, spacing: 8) {
                    ForEach(viewModel.trip.activities, id: \.self) { activity in
                        Text(activity.rawValue)
                            .font(.subheadline)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .padding(.horizontal)
                    }
                }

                Spacer()

                // Delete Button
                if viewModel.isLoading {
                    ProgressView()
                        .padding()
                } else {
                    Button(action: {
                        showingDeleteConfirmation = true
                    }) {
                        Text("Delete Trip")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .shadow(radius: 3)
                    }
                    .padding(.horizontal)
                    .alert("Are you sure you want to delete this trip?", isPresented: $showingDeleteConfirmation) {
                        Button("Cancel", role: .cancel) { }
                        Button("Delete", role: .destructive) {
                            Task {
                                do {
                                    try await viewModel.deleteTrip(tripId: viewModel.trip.id!)
                                    if shouldNavigateBack {
                                        presentationMode.wrappedValue.dismiss() // Dismiss the view
                                    }
                                } catch {
                                    viewModel.errorMessage = ErrorMessage(message: "Failed to delete trip.")
                                }
                            }
                        }
                    }
                }
        }
        .padding(.vertical, 10)
        .background(Color(.systemGroupedBackground))
        .cornerRadius(16)
        .onAppear {
            viewModel.refreshTrip()
        }
        .alert(item: $viewModel.errorMessage) { errorMessage in
            Alert(
                title: Text("Error"),
                message: Text(errorMessage.message),
                dismissButton: .default(Text("OK"))
            )
        }
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

#Preview {
    let mockLocation = Location(city: "Paris", country: "France")
    let mockActivities: [Activity] = [.sightseeing, .partying]

    let mockTrip = Trip(
        id: UUID().uuidString,
        destination: mockLocation,
        startDate: Date(),
        endDate: Calendar.current.date(byAdding: .day, value: 7, to: Date())!,
        activities: mockActivities,
        createdByUserID: "mockUserID",
        participantIDs: ["user1", "user2"],
        photos: [],
        videos: [],
        status: .planned
    )

    return TripDetailView(trip: mockTrip, shouldNavigateBack: .constant(false))
}
