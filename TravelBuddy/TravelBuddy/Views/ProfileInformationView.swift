//
//  ProfileInformationView.swift
//  TravelBuddy
//
//  Created by Nikola Jankovikj on 19.9.24.
//

import SwiftUI

struct ProfileInformationView: View {
    var numberCompletedTrips: Int
    var numberPhotosTaken: Int
    var favoriteActivity: String
    var name: String
    var age: Int
    var location: Location
    var description: String
    @Binding var showEditProfileView: Bool
    @Binding var showSignInView: Bool
    
    var body: some View {
        VStack {
            HStack {
                Text("\(numberCompletedTrips) completed trips")
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Spacer()
                
                Text("\(numberPhotosTaken) photos taken")
                    .padding(.horizontal)
                
                Spacer()
                
                Text("favorite activity \(favoriteActivity)")
            }
            .padding(.vertical)
            .offset(y: -20)
            
            HStack {
                Spacer()
                
                VStack {
                    Text("\(name), \(age)")
                        .bold()
                        .font(.title)
                    
                    Text("\(location.city), \(location.country)")
                }
                
                Spacer()
                
                NavigationStack {
                    Button("Edit Profile") {
                        showEditProfileView = true
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height: 40)
                    .frame(maxWidth: 120)
                    .background(Color.blue)
                    .cornerRadius(20)
                }
                .navigationDestination(isPresented: $showEditProfileView) {
                    EditProfileView(showSignInView: $showSignInView)
                }
                
            }
            .padding(.vertical)
            .offset(y: -25)
            
            HStack {
                Text("\(description)")
                    .multilineTextAlignment(.leading)
                    .padding()
                
                Spacer()
            }
            .offset(y: -30)
        }
    }
}

#Preview {
    ProfileInformationView(numberCompletedTrips: 0, numberPhotosTaken: 0, favoriteActivity: "Coding", name: "Name", age: 18, location: Location(city: "Skopje", country: "Macedonia"), description: "Description", showEditProfileView: .constant(false), showSignInView: .constant(false))
}
