//
//  ProfileInformationView.swift
//  TravelBuddy
//
//  Created by Nikola Jankovikj on 19.9.24.
//

import SwiftUI

struct ProfileInformationView: View {
    var user: DbUser
    @Binding var showEditProfileView: Bool
    @Binding var showSignInView: Bool
    
    var body: some View {
        
        VStack {
            HStack {
                Text("\(user.numberCompletedTrips)\ncompleted\ntrips")
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Spacer()
                
                Text("\(user.numberPhotosTaken)\nphotos\ntaken")
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Spacer()
                
                Text("favorite\nactivity\n\(user.favoriteActivity)")
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .padding(.top)
            .offset(y: -50)
            
            HStack {
                Spacer()
                
                VStack (alignment: .leading){
                    Text("\(user.name), \(user.age)")
                        .bold()
                        .font(.title)
                    
                    Text("\(user.location.city), \(user.location.country)")
                }
                .frame(maxWidth: .infinity)
                
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
                    .padding(.trailing)
                }
                .navigationDestination(isPresented: $showEditProfileView) {
                    EditProfileView(showSignInView: $showSignInView, user: user)
                }
                
            }
            .padding(.bottom)
            .offset(y: -25)
            
            HStack {
                Text("\(user.description)")
                    .multilineTextAlignment(.leading)
                    .padding()
                
                Spacer()
            }
            .offset(y: -30)
        }
    }
}

#Preview {
    ProfileInformationView(user: DbUser(id: "0", name: "Name", age: 18, location: Location(city: "Skopje", country: "Macedonia"), description: "Description", favoriteActivity: "Activity", dateCreated: Date.now, dateUpdated: Date.now, instagram: "instagram"), showEditProfileView: .constant(false), showSignInView: .constant(false))
}
