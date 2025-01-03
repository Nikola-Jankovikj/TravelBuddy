//
//  MainAppView.swift
//  TravelBuddy
//
//  Created by Nikola Jankovikj on 19.9.24.
//

import SwiftUI

struct MainAppView: View {
    @Binding var showSignInView: Bool
    @State var showAlert: Bool = false
    @Binding var imageData: [Data]
    @Binding var user: DbUser?
    
    var body: some View {
        TabView {
            
            TripsView()
                .tabItem {
                    Image(systemName: "airplane")
                    Text("My Trips")
                }
            
            SwipingView(user: $user)
                .tabItem {
                    Image(systemName: "globe")
                }
            
            ProfileView(user: user!, showSignInView: $showSignInView, imageData: $imageData)
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
                
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Shake Detected"),
                message: Text("A reminder has been sent for 5 minutes from now!"),
                dismissButton: .default(Text("Ok"), action: {
                    NotificationManager.instance.scheduleNotifications()
                })
            )
        }
        .background(ShakeDetector(showAlert: $showAlert))
    }
}

//#Preview {
//    MainAppView(showSignInView: .constant(false))
//}
