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
            VStack(spacing: 10) {
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
                            .padding(.top)
                        
                    } else {
                        CompletedTripsView()
                    }
                }
                
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
        } else if viewModel.activeTrip != nil || viewModel.participatedTrips != [] {
            ScrollView(.vertical){
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        // Active Trip
//                        if let activeTrip = viewModel.activeTrip {
//                            TripDetailView(trip: activeTrip, shouldNavigateBack: .constant(false))
//                                .frame(width: UIScreen.main.bounds.width * 0.85)
//                        }
//                        
                        // Participated Trips
                        ForEach(viewModel.participatedTrips, id: \.id) { trip in
                            TripDetailView(trip: trip, shouldNavigateBack: 
                                .constant(false))
                                .frame(width: UIScreen.main.bounds.width * 0.85)
                        }
                    }
                    .padding(.horizontal)
                }
                
                if viewModel.isUserTripOwner {
                    if let activeTrip = viewModel.activeTrip{
                        VStack{
                            Text("Requests for your trip (\(viewModel.requestedUsers.count))")
                                .font(.headline)
                                .padding(.top)
                                .frame(alignment: .topLeading)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(viewModel.requestedUsers) { user in
                                        UserRequestCard(user: user, trip: activeTrip, viewModel: viewModel)
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                        .background(Color(.systemGray6))
                        .frame(maxWidth: .infinity)
                        .cornerRadius(16)
                    }
                    }
                    
            }
        }
        if viewModel.activeTrip == nil {
            NoActiveTripView
        }
    }
    
    private var NoActiveTripView: some View {
        VStack() {
            
            if viewModel.participatedTrips.count == 0 {
                Spacer()
                Image("no-trips")
                    .resizable()
                    .scaledToFit()
                    .opacity(0.8)
                Spacer()
            }
          
            CreateTripButton
        }
    }
    
    private var CreateTripButton: some View {
        Button(action: {
            viewModel.showTripCreation = true
        }) {
            Label("Create Your Trip", systemImage: "plus.circle.fill")
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
