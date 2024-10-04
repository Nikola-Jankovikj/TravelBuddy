//
//  SwipingCardView.swift
//  TravelBuddy
//
//  Created by Nikola Jankovikj on 28.9.24.
//

import SwiftUI

struct SwipingCardView: View {
    @Binding var photos: [Data]
    @Binding var trip: Trip?
    @Binding var loggedInUser: DbUser?
    var tripUser: DbUser?
    var addToLikedTrips: @MainActor (_ trip: Trip) async throws -> Void
    var addToRejectedTrips: @MainActor (_ trip: Trip) async throws -> Void
    
    var body: some View {
        GeometryReader { geometry in
            
            Text("\(trip?.id ?? "lele") & \(photos.count)")
            
            ZStack {
                ImageSliderView(imageData: $photos, width: geometry.size.width)

                VStack {
                    Spacer()
                    
                    HStack {
                        VStack {
                            HStack {
                                Text("\(tripUser?.name ?? "Name"), \(tripUser?.age ?? 18)")
                                    .fontWeight(.heavy)
                                    .shadow(radius: 10)
                                Spacer()
                            }
                            HStack {
                                Text("\(String(describing: tripUser?.location ?? Location(city: "", country: "")))")
                                    .fontWeight(.heavy)
                                    .shadow(radius: 10)
                                Spacer()
                            }
                        }
                        .foregroundColor(.white)
                        .padding()
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    HStack {
                        Button("Reject") {
                            Task {
                                do {
                                    self.loggedInUser!.likedTripIds.append(trip!.id)
                                    try await addToRejectedTrips(trip!)
                                } catch {
                                    print("ne uspeav da reject-nam")
                                }
                            }
                        }
                        .frame(width: 100, height: 50)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(25)
                        .padding()
                        
                        Spacer()
                        
                        Button("Like") {
                            Task {
                                do {
                                    self.loggedInUser!.rejectedTripIds.append(trip!.id)
                                    try await addToLikedTrips(trip!)
                                } catch {
                                    print("ne uspeav da like-nam")
                                }
                            }
                        }
                        .frame(width: 100, height: 50)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(25)
                        .padding()
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
}


//#Preview {
//    SwipingCardView()
//}
