import SwiftUI

struct TripDetailView: View {
    @StateObject private var viewModel: TripDetailViewModel
    @State private var showingDeleteConfirmation = false
    @Binding var shouldNavigateBack: Bool
    @State private var participants: [DbUser] = []
    @Environment(\.presentationMode) var presentationMode
    
    init(trip: Trip, shouldNavigateBack: Binding<Bool>) {
        _viewModel = StateObject(wrappedValue: TripDetailViewModel(trip: trip))
        self._shouldNavigateBack = shouldNavigateBack
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            TripDateSection
            
            Divider()
            
            TripLocationSection
            
            Divider()
            
            // Horizontal layout for Activities and Participants sections
            HStack(alignment: .top, spacing: 16) {
                ActivitiesSection
                ParticipantsSection
            }
            
            HStack {
                if viewModel.trip.status == .planned && viewModel.loggedInUserId == viewModel.trip.createdByUserID {
                    CompleteTripButton
                }
                
                if viewModel.loggedInUserId == viewModel.trip.createdByUserID {
                    DeleteTripButton
                }
            }.padding(.top)
        }
        .padding()
        .background(Color(.systemGroupedBackground))
        .cornerRadius(16)
        .onAppear {
            viewModel.refreshTrip()
            Task {
                do {
                    participants = try await viewModel.fetchParticipants()
                } catch {
                    print("Error fetching participants: \(error)")
                }
            }
        }
        .alert(item: $viewModel.errorMessage) { errorMessage in
            Alert(
                title: Text("Error"),
                message: Text(errorMessage.message),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    // Date Section at the top
    private var TripDateSection: some View {
        VStack(alignment: .leading) {
            SectionHeader(title: "Date")
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Start Date")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text(formattedDate(viewModel.trip.startDate))
                        .font(.headline)
                }
                Spacer()
                VStack(alignment: .leading, spacing: 4) {
                    Text("End Date")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text(formattedDate(viewModel.trip.endDate))
                        .font(.headline)
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
    }
    
    // Location Section
    private var TripLocationSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            SectionHeader(title: "Location")
            HStack {
                Image(systemName: "location.fill")
                    .foregroundColor(.blue)
                Text("\(viewModel.trip.destination.city), \(viewModel.trip.destination.country)")
                    .font(.headline)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
            .padding(.horizontal)
        }
    }
    
    // Activities Section
    private var ActivitiesSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            SectionHeader(title: "Activities")
            ForEach(viewModel.trip.activities, id: \.self) { activity in
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                    Text(activity.rawValue)
                        .font(.subheadline)
                }
                .padding(.vertical, 4)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal)
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    // Participants Section
    private var ParticipantsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            SectionHeader(title: "Participants")
            ForEach(participants) { participant in
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.blue)
                    Button(action: viewModel.toggleShowAlertDialog) {
                        Text(participant.name)
                            .font(.subheadline)
                            .foregroundColor(.primary)
                    }
//                    Text(participant.name)
//                        .font(.subheadline)
//                        .foregroundColor(.primary)
                }
                .padding(.vertical, 4)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal)
                .alert(participant.instagram, isPresented: $viewModel.showAlertDialog) {
                    Button("Ok", role: .cancel) { }
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    // Complete Trip Button
    private var CompleteTripButton: some View {
        Button(action: {
            viewModel.completeTrip(trip: viewModel.trip)
        }) {
            Label("Complete Trip", systemImage: "checkmark.circle.fill")
                .font(.subheadline)
                .fontWidth(.condensed)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(12)
                .shadow(radius: 3)
        }
    }
    
    // Delete Trip Button
    private var DeleteTripButton: some View {
        Button(action: {
            showingDeleteConfirmation = true
        }) {
            Label("Delete Trip", systemImage: "trash.fill")
                .font(.subheadline)
                .fontWidth(.condensed)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(12)
                .shadow(radius: 3)
        }
        .alert("Are you sure you want to delete this trip?", isPresented: $showingDeleteConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                Task {
                    do {
                        try await viewModel.deleteTrip(tripId: viewModel.trip.id)
                        if shouldNavigateBack {
                            presentationMode.wrappedValue.dismiss()
                        }
                    } catch {
                        viewModel.errorMessage = ErrorMessage(message: "Failed to delete trip.")
                    }
                }
            }
        }
    }
    
    // Helper function to format dates
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    // Header for each section
    private func SectionHeader(title: String) -> some View {
        Text(title)
            .font(.headline)
            .foregroundColor(.primary)
            .padding(.horizontal)
    }
}
