import SwiftUI

struct TripsView: View {
    @StateObject private var viewModel = TripsViewModel()
    @State private var selectedTab: Tab = .active
    @State private var requestedUsers: [DbUser] = [] // State property for requested users


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
                    if !viewModel.participatedTrips.isEmpty {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Planned Trips")
                                .font(.headline)
                                .padding(.horizontal)
                            
                            ForEach(viewModel.participatedTrips) { trip in
                                NavigationLink(destination: TripDetailView(trip: trip, shouldNavigateBack: .constant(false))) {
                                    HStack {
                                        Text("\(trip.destination.city), \(trip.destination.country)")
                                            .font(.subheadline)
                                        Spacer()
                                        Text("\(trip.status.rawValue)")
                                            .foregroundColor(.gray)
                                            .font(.caption)
                                    }
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(8)
                                    .shadow(radius: 2)
                                    .padding(.horizontal)
                                }
                            }
                        }
                        .padding(.top, 20)
                    }

                    if viewModel.isLoading {
                        ProgressView()
                            .scaleEffect(1.5)
                            .padding(.top, 50)
                    } else if let activeTrip = viewModel.activeTrip {
                        VStack(spacing: 20) {
                            TripDetailView(trip: activeTrip, shouldNavigateBack: .constant(false))
                            
                            if viewModel.isUserTripOwner {
                                Text("Trip Requests")
                                    .font(.headline)
                                    .padding(.top)

                                ForEach(requestedUsers) { user in
                                    HStack {
                                        Text(user.name)
                                        Spacer()
                                        Button("Accept") {
                                            Task {
                                                try await viewModel.acceptRequest(from: user, for: activeTrip)
                                            }
                                        }
                                        .buttonStyle(.borderedProminent)

                                        Button("Reject") {
                                            Task {
                                                try await viewModel.rejectRequest(from: user, for: activeTrip)
                                            }
                                        }
                                        .buttonStyle(.bordered)
                                    }
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(8)
                                    .shadow(radius: 3)
                                    .padding(.horizontal)
                                }
                            }

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
                            Text("No created trip")
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
                            NavigationStack {
                                TripCreationView { newTrip in
                                    viewModel.createNewTrip(newTrip)
                                }
                            }
                        }
                    }
                } else {
                    CompletedTripsView()
                }

                Spacer()
            }
            .padding(10)
            .background(LinearGradient(gradient: Gradient(colors: [Color(.systemBackground), Color(.systemGray6)]), startPoint: .top, endPoint: .bottom)
                            .edgesIgnoringSafeArea(.all))
        }
        .onAppear {
            viewModel.startListeningToTrips()
            Task {
                do {
                    requestedUsers = try await viewModel.fetchRequestedUsers() // Fetch requested users
                } catch {
                    // Handle error, if necessary
                    print("Error fetching requested users: \(error)")
                }
            }
        }
        .onDisappear {
            viewModel.stopListeningToTrips()
        }
    }
}
