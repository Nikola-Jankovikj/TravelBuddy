//
//  EditProfileView.swift
//  TravelBuddy
//
//  Created by Nikola Jankovikj on 18.9.24.
//

import SwiftUI

struct EditProfileView: View {
    
    @StateObject private var viewModel = EditProfileViewModel()
    @Binding var showSignInView: Bool
    var user: DbUser
    @State var showCameraView: Bool = false
    @State var showPlacesVisitedView: Bool = false
    @State var cities: [Location] = []
    
    var body: some View {
        VStack {
            
            NavigationStack {
                Button("See places visited") {
                    Task {
                        if let completedTrips = try? await TripManager.shared.getCompletedTripsForUser(userId: user.id) {
                            cities = completedTrips.map({ trip in
                                trip.destination
                            })
                        }
                        else{
                            cities = []
                        }
                        showPlacesVisitedView = true
                    }
                }
            }
            .navigationDestination(isPresented: $showPlacesVisitedView) {
                PlacesVisitedView(cities: cities)
            }
            
            NavigationStack {
                Button("Log out") {
                    Task {
                        do {
                            try viewModel.signOut()
                            showSignInView = true
                        } catch {
                            print("Error \(error)")
                        }
                    }
                }
            }
            
            if viewModel.authProviders.contains(.email) {
                Button("Reset password") {
                    Task {
                        do {
                            try await viewModel.resetPassword()
                            print("PASSWORD RESET!")
                        } catch {
                            print("Error \(error)")
                        }
                    }
                }
            }
        }
        .navigationTitle("Profile")
    }
}

//#Preview {
//    EditProfileView(showSignInView: .constant(false))
//}
