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
                                guard let trip = trip else { return }
                                do {
                                    try await addToRejectedTrips(trip)
                                } catch {
                                    print("Failed to dislike.")
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
                                guard let trip = trip else { return }
                                do {
                                    if let loggedInUser = loggedInUser {
                                        var updatedTrip = trip
                                        updatedTrip.requestedUsersIds.append(loggedInUser.id)
                                        //try await addToLikedTrips(updatedTrip)
                                        try TripManager.shared.updateTrip(trip: updatedTrip)
                                    }
                                } catch {
                                    print("Failed to like")
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
