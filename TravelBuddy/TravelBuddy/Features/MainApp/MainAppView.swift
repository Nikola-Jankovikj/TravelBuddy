//
//  MainAppView.swift
//  TravelBuddy
//
//  Created by Nikola Jankovikj on 19.9.24.
//

import SwiftUI

struct MainAppView: View {
    @Binding var showSignInView: Bool
    
    var body: some View {
        TabView {
            
            TripsView()
                .tabItem {
                    Image(systemName: "airplane")
                    Text("Trips")
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
    }
}

#Preview {
    MainAppView(showSignInView: .constant(false))
}
