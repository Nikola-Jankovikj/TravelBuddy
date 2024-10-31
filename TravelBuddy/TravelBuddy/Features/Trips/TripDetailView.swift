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
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                TripDateSection
                
                Divider()
                
                TripLocationSection
                
                Divider()
                
                // Horizontal layout for Activities and Participants sections
                HStack(alignment: .top, spacing: 16) {
                    ActivitiesSection
                    //ParticipantsSection
                }
                
                if viewModel.trip.status == .planned {
                    CompleteTripButton
                }
                
                DeleteTripButton
            }
            .padding()
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
            .padding(.horizontal)
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
//    private var ParticipantsSection: some View {
//        VStack(alignment: .leading, spacing: 8) {
//            SectionHeader(title: "Participants")
//            ForEach(viewModel.trip.participantIDs, id: \.self) { participantID in
//                HStack {
//                    Circle()
//                        .fill(Color.blue.opacity(0.2))
//                        .frame(width: 40, height: 40)
//                        .overlay(
//                            Text(initials(for: participantID))
//                                .font(.headline)
//                                .foregroundColor(.blue)
//                        )
//                    Text(participantID)
//                        .font(.subheadline)
//                        .foregroundColor(.primary)
//                }
//                .padding(.vertical, 4)
//                .frame(maxWidth: .infinity, alignment: .leading)
//                .background(Color(.systemGray6))
//                .cornerRadius(8)
//                .padding(.horizontal)
//            }
//        }
//        .frame(maxWidth: .infinity)
//    }
    
    // Complete Trip Button
    private var CompleteTripButton: some View {
        Button(action: {
            viewModel.completeTrip(trip: viewModel.trip)
        }) {
            Label("Complete Trip", systemImage: "checkmark.circle.fill")
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
    
    // Delete Trip Button
    private var DeleteTripButton: some View {
        Button(action: {
            showingDeleteConfirmation = true
        }) {
            Label("Delete Trip", systemImage: "trash.fill")
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
    
    // Helper function to get initials from participant ID
    private func initials(for participantID: String) -> String {
        let names = participantID.split(separator: " ")
        let initials = names.compactMap { $0.first }.prefix(2)
        return String(initials)
    }
    
    // Header for each section
    private func SectionHeader(title: String) -> some View {
        Text(title)
            .font(.headline)
            .foregroundColor(.primary)
            .padding(.horizontal)
    }
}
