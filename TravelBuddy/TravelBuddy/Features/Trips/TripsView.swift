//
//  TripsView.swift
//  TravelBuddy
//
//  Created by Todor Jovanovski on 22.9.24.
//


import SwiftUI

struct TripsView: View {
    @StateObject private var viewModel = TripsViewModel()
    @State private var selectedTab: Tab = .active

    enum Tab {
        case active, completed
    }

    var body: some View {
        NavigationView {
            VStack {
                Picker("Trip Sections", selection: $selectedTab) {
                    Text("Active Trip").tag(Tab.active)
                    Text("Completed Trips").tag(Tab.completed)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                if selectedTab == .active {
                    if viewModel.isLoading {
                        ProgressView()
                    } else if let activeTrip = viewModel.activeTrip {
                        VStack {
                            TripDetailView(trip: activeTrip, shouldNavigateBack: .constant(false))
                            Button("Complete Trip") {
                                viewModel.completeTrip(trip: activeTrip)
                            }
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                        }
                    } else {
                        VStack {
                            Text("No active trip")
                                .font(.headline)
                                .padding()

                            Button("Create New Trip") {
                                viewModel.showTripCreation = true
                            }
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                        }
                        .sheet(isPresented: $viewModel.showTripCreation) {
                            TripCreationView { newTrip in
                                viewModel.createNewTrip(newTrip)
                            }
                        }
                    }
                } else {
                    CompletedTripsView()
                }
            }
        }
        .onAppear {
            viewModel.startListeningToTrips()
        }
        .onDisappear {
            viewModel.stopListeningToTrips()
        }
    }
}


#Preview {
    TripsView()
}
