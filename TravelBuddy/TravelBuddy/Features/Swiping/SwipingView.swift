//
//  SwipingView.swift
//  TravelBuddy
//
//  Created by Nikola Jankovikj on 19.9.24.
//

import SwiftUI

struct SwipingView: View {
    @StateObject private var viewModel = SwipingViewModel()
    @State var showSwipingFilterView: Bool = false
    @Binding var user: DbUser?
    
    var body: some View {
        VStack {
            NavigationStack {
                Button("Search trips") {
                    print("id: \(viewModel.id)")
                    showSwipingFilterView.toggle()
                }.font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(15)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .shadow(radius: 3)
            }
            .navigationDestination(isPresented: $showSwipingFilterView) {
                SwipingFilterView(viewModel: viewModel, showSwipingFilterView: $showSwipingFilterView, user: $user)
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            

            if viewModel.showingTrip != nil {
                
                SwipingCardView(photos: $viewModel.photos, trip: $viewModel.showingTrip, loggedInUser: $user, tripUser: viewModel.tripUser, addToLikedTrips: viewModel.addToLikedTrips, addToRejectedTrips: viewModel.addToDislikedTrips)
                    .onAppear() {
                        Task {
                            await viewModel.fetchPhotosFromUser(userId: viewModel.showingTrip!.createdByUserID)
                            do {
                                try await viewModel.getUserFromTrip(trip: viewModel.showingTrip!)
                            } catch {
                                print("cannot get user")
                            }
                        }
                    }
                    .onChange(of: viewModel.showingTrip!.id) { newValue in
                        Task {
                            await viewModel.fetchPhotosFromUser(userId: viewModel.showingTrip!.createdByUserID)
                            do {
                                try await viewModel.getUserFromTrip(trip: viewModel.showingTrip!)
                            } catch {
                                print("cannot get user")
                            }
                        }
                    }
                
            } else {
                Text("No trips to show.")
            }
        }
    }
}

//#Preview {
//    SwipingView()
//}
