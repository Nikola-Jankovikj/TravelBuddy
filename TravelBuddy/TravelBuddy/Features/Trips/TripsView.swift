import SwiftUI

struct TripsView: View {
    @StateObject private var viewModel = TripsViewModel()
    @State private var selectedTab: Tab = .active
    @State private var requestedUsers: [DbUser] = []
    
    enum Tab {
        case active, completed
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                Picker("Trip Sections", selection: $selectedTab) {
                    Text("Active Trip").tag(Tab.active)
                    Text("Completed Trips").tag(Tab.completed)
                }
                .pickerStyle(SegmentedPickerStyle())
                .background(Color(.systemGray6))
                .cornerRadius(6)
                
                Group {
                    if selectedTab == .active {
                        ActiveAndParticipatedTripsSection
                        
                    } else {
                        CompletedTripsView()
                    }
                }
                .padding(.top)
                
                Spacer()
            }
            .padding()
            .background(LinearGradient(gradient: Gradient(colors: [Color(.systemBackground), Color(.systemGray6)]), startPoint: .top, endPoint: .bottom)
            .edgesIgnoringSafeArea(.all))
            .navigationTitle("Trips")
            .onAppear {
                viewModel.startListeningToTrips()
                Task {
                    do {
                        requestedUsers = try await viewModel.fetchRequestedUsers()
                    } catch {
                        print("Error fetching requested users: \(error)")
                    }
                }
            }
            .onDisappear {
                viewModel.stopListeningToTrips()
            }
        }
    }
    
    @ViewBuilder
    private var ActiveAndParticipatedTripsSection: some View {
        if viewModel.isLoading {
            ProgressView()
                .scaleEffect(1.5)
                .padding(.top, 50)
        } else if let activeTrip = viewModel.activeTrip {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    // Active Trip
                    if let activeTrip = viewModel.activeTrip {
                        TripDetailView(trip: activeTrip, shouldNavigateBack: .constant(false))
                            .frame(width: UIScreen.main.bounds.width * 0.85)
                    }
                    
                    // Participated Trips
                    ForEach(viewModel.participatedTrips, id: \.id) { trip in
                        TripDetailView(trip: trip, shouldNavigateBack: .constant(false))
                            .frame(width: UIScreen.main.bounds.width * 0.85)
                    }
                }
                .padding(.horizontal)
            }
            .padding(.top)
            
            if viewModel.isUserTripOwner {
                Text("Trip Requests")
                    .font(.headline)
                    .padding(.top)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(requestedUsers) { user in
                            UserRequestCard(user: user, trip: activeTrip, viewModel: viewModel)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        } else {
            NoActiveTripView
        }
    }
    
    private var NoActiveTripView: some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.circle")
                .resizable()
                .scaledToFit()
                .frame(height: 80)
                .foregroundColor(.gray)
            
            Text("No created trip")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
            
            CreateTripButton
        }
    }
    
    private var CreateTripButton: some View {
        Button(action: {
            viewModel.showTripCreation = true
        }) {
            Label("Create New Trip", systemImage: "plus.circle.fill")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(12)
                .shadow(radius: 3)
        }
        .padding(.horizontal)
        .sheet(isPresented: $viewModel.showTripCreation) {
            TripCreationView { newTrip in
                viewModel.createNewTrip(newTrip)
            }
        }
    }
}

struct UserRequestCard: View {
    let user: DbUser
    let trip: Trip
    let viewModel: TripsViewModel
    
    var body: some View {
        VStack(spacing: 8) {
            Text(user.name)
                .font(.headline)
                .padding(.top, 8)
            
            HStack {
                // Accept Button
                Button(action: {
                    Task {
                        try await viewModel.acceptRequest(from: user, for: trip)
                    }
                }) {
                    Label("", systemImage: "checkmark.circle")
                        .font(.subheadline)
                        .padding(6)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
                // Reject Button
                Button(action: {
                    Task {
                        try await viewModel.rejectRequest(from: user, for: trip)
                    }
                }) {
                    Label("", systemImage: "xmark.circle")
                        .font(.subheadline)
                        .padding(6)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .padding(.bottom, 8)
        }
        .frame(width: 150)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 3)
        .padding(4)
    }
}
