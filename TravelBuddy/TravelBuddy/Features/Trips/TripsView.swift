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
                // Segmented Control Styled
                Picker("Trip Sections", selection: $selectedTab) {
                    Text("Active Trip").tag(Tab.active)
                    Text("Completed Trips").tag(Tab.completed)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .padding(.top)
                
                // Content based on selected tab
                if selectedTab == .active {
                    if viewModel.isLoading {
                        ProgressView()
                            .scaleEffect(1.5)
                            .padding(.top, 50)
                    } else if let activeTrip = viewModel.activeTrip {
                        VStack(spacing: 20) {
                            TripDetailView(trip: activeTrip, shouldNavigateBack: .constant(false))
                            
                            Button(action: {
                                viewModel.completeTrip(trip: activeTrip)
                            }) {
                                Text("Complete Trip")
                                    .font(.headline)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.green)
                                    .foregroundColor(.white)
                                    .cornerRadius(12)
                                    .shadow(radius: 3)
                            }
                            .padding(.horizontal)
                        }
                        .padding(.top, 20)
                    } else {
                        VStack(spacing: 20) {
                            Text("No active trip")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(.secondary)
                                .padding(.top, 40)

                            Button(action: {
                                viewModel.showTripCreation = true
                            }) {
                                Text("Create New Trip")
                                    .font(.headline)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(12)
                                    .shadow(radius: 3)
                            }
                            .padding(.horizontal)
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

                Spacer() // Push content to the top
            }
            .padding(10)
            .background(LinearGradient(gradient: Gradient(colors: [Color(.systemBackground), Color(.systemGray6)]), startPoint: .top, endPoint: .bottom)
                            .edgesIgnoringSafeArea(.all))
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
