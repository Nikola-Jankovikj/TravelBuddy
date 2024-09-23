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
    
    var body: some View {
        TabView {
            
            TripsView()
                .tabItem {
                    Image(systemName: "airplane")
                    Text("My Trips")
                }
            
            SwipingView()
                .tabItem {
                    Image(systemName: "globe")
//                    Text("Browse")
                }
            
            ProfileView(showSignInView: $showSignInView)
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
                
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Shake Detected"),
                message: Text("We are happy you are enjoying our app!"),
                dismissButton: .default(Text("OK"))
            )
        }
        .background(ShakeDetector(showAlert: $showAlert))
    }
}

#Preview {
    MainAppView(showSignInView: .constant(false))
}
