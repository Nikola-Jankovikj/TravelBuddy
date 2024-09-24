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
    @Binding var shouldNavigateBack: Bool // Binding to control navigation
    @Environment(\.presentationMode) var presentationMode // Access presentation mode



    init(trip: Trip, shouldNavigateBack: Binding<Bool>) {
        _viewModel = StateObject(wrappedValue: TripDetailViewModel(trip: trip))
        self._shouldNavigateBack = shouldNavigateBack
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text("Trip to \(viewModel.trip.destination.city), \(viewModel.trip.destination.country)")
                .font(.largeTitle)
                .padding()

            Text("From: \(formattedDate(viewModel.trip.startDate))")
                .padding(.horizontal)

            Text("To: \(formattedDate(viewModel.trip.endDate))")
                .padding(.horizontal)

            Text("Activities:")
                .font(.headline)
                .padding(.horizontal)

            ForEach(viewModel.trip.activities, id: \.self) { activity in
                Text(activity.rawValue)
                    .padding(.horizontal)
            }

            if viewModel.isLoading {
                ProgressView()
            } else {
                Button("Delete Trip") {
                    showingDeleteConfirmation = true
                }
                .foregroundColor(.red)
                .padding()
                .background(Color.red.opacity(0.2))
                .cornerRadius(8)
                .alert("Are you sure you want to delete this trip?", isPresented: $showingDeleteConfirmation) {
                    Button("Cancel", role: .cancel) { }
                    Button("Delete", role: .destructive) {
                        Task {
                            do {
                                try await viewModel.deleteTrip(tripId: viewModel.trip.id!)
                                if (shouldNavigateBack) {
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
    // Mock data for the preview
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

