//
//  TripCreationView.swift
//  TravelBuddy
//
//  Created by Todor Jovanovski on 22.9.24.
//

import SwiftUI
import Firebase

struct TripCreationView: View {
    @StateObject private var viewModel: TripCreationViewModel

    init(onTripCreated: @escaping (Trip) -> Void) {
        _viewModel = StateObject(wrappedValue: TripCreationViewModel(onTripCreated: onTripCreated))
    }

    var body: some View {
        VStack {
            NavigationStack {
                if viewModel.location.description == ", " {
                    Button("Choose location") {
                        viewModel.showCitySearchView = true
                    }
                } else {
                    Button("\(viewModel.location)") {
                        viewModel.showCitySearchView = true
                    }
                }
            }
            .navigationDestination(isPresented: $viewModel.showCitySearchView) {
                CitySearchView(showCitySearchView: $viewModel.showCitySearchView, location: $viewModel.location)
            }

            // DatePickers for From and To Dates
            DatePicker("Date From", selection: $viewModel.dateFrom, in: Date()..., displayedComponents: .date)
                .padding()

            DatePicker("Date To", selection: $viewModel.dateTo, in: viewModel.dateFrom..., displayedComponents: .date)
                .padding()

            // Activities Section
            Text("Preferred Activities")
                .font(.headline)
                .padding(.top)

            ForEach(Activity.allCases, id: \.self) { activity in
                MultipleSelectionRow(activity: activity, isSelected: viewModel.selectedActivities.contains(activity)) {
                    if viewModel.selectedActivities.contains(activity) {
                        viewModel.selectedActivities.remove(activity)
                    } else {
                        viewModel.selectedActivities.insert(activity)
                    }
                }
            }
            .padding(.horizontal)

            // Error message display
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }

            // Create Trip Button
            Button(action: {
                Task {
                    await viewModel.createTrip()
                }
            }) {
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    Text("Create Trip")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(viewModel.isValidTrip ? Color.blue : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .disabled(viewModel.isLoading || !viewModel.isValidTrip)
            .padding(.top)
        }
        .padding()
        .navigationBarTitle("New Trip", displayMode: .inline)
    }
}

// MARK: - MultipleSelectionRow

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
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
}

// MARK: - Preview

//#Preview {
//    TripCreationView { newTrip in
//        print("New trip created: \(newTrip)")
//    }
//}
