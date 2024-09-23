//
//  TripCreationView.swift
//  TravelBuddy
//
//  Created by Todor Jovanovski on 22.9.24.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct TripCreationView: View {
    @State private var city: String = ""
    @State private var country: String = ""
    @State private var dateFrom = Date()
    @State private var dateTo = Date()
    @State private var selectedActivities: Set<Activity> = []
    @State private var isLoading = false
    @State private var errorMessage: String?

    var onTripCreated: (Trip) -> Void
    
    var body: some View {
        VStack {
            TextField("City", text: $city)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("Country", text: $country)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            DatePicker("Date From", selection: $dateFrom, displayedComponents: .date)
                .padding()

            DatePicker("Date To", selection: $dateTo, displayedComponents: .date)
                .padding()

            Text("Preferred Activities")
                .font(.headline)
                .padding(.top)

            ForEach(Activity.allCases, id: \.self) { activity in
                MultipleSelectionRow(activity: activity, isSelected: selectedActivities.contains(activity)) {
                    if selectedActivities.contains(activity) {
                        selectedActivities.remove(activity)
                    } else {
                        selectedActivities.insert(activity)
                    }
                }
            }

            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }

            Button(action: createTrip) {
                if isLoading {
                    ProgressView()
                } else {
                    Text("Create Trip")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .disabled(isLoading)
            .padding(.top)
        }
        .padding()
    }

    private func createTrip() {
        // Check if inputs are valid
        guard !city.isEmpty && !country.isEmpty else {
            errorMessage = "Please fill in all the fields."
            return
        }
        errorMessage = nil
        isLoading = true

        // Get current user's ID
        guard let userId = Auth.auth().currentUser?.uid else {
            errorMessage = "Unable to get user ID."
            isLoading = false
            return
        }

        // Create the trip object
        let newTrip = Trip(
            id: UUID().uuidString,
            destination: Location(city: city, country: country),
            startDate: dateFrom,
            endDate: dateTo,
            activities: Array(selectedActivities),
            createdByUserID: userId,
            participantIDs: [],
            photos: [],
            videos: [],
            status: .planned
        )

        // Use TripManager to save the trip
        do {
            try TripManager.shared.createNewTrip(trip: newTrip)
            onTripCreated(newTrip)
        } catch {
            errorMessage = "Failed to create trip: \(error.localizedDescription)"
        }
        isLoading = false
    }
}


struct MultipleSelectionRow: View {
    var activity: Activity
    var isSelected: Bool
    var action: () -> Void

    var body: some View {
        Button(action: self.action) {
            HStack {
                Text(activity.rawValue)
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark")
                }
            }
        }
    }
}
