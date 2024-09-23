//
//  RootView.swift
//  TravelBuddy
//
//  Created by Nikola Jankovikj on 12.9.24.
//

import SwiftUI

struct RootView: View {
    
    @State private var showSignInView: Bool = false
    @StateObject private var authUser = AuthDataResultModelEnvironmentVariable()
    
    var body: some View {
        ZStack{
            if !showSignInView {
                NavigationStack {
                    MainAppView(showSignInView: $showSignInView)
                }
            }
        }
        .onAppear {
            UIApplication.shared.applicationIconBadgeNumber = 0
            
            guard let tmpAuthUser = try? AuthenticationManager.shared.getAuthenticatedUser() else {
                self.showSignInView = true
                return
            }
            authUser.saveAuthData(newAuthData: tmpAuthUser)
            self.showSignInView = false
        }
        .fullScreenCover(isPresented: $showSignInView, content: {
            NavigationStack {
                AuthenticationView(showSignInView: $showSignInView)
            }
        })
        .environmentObject(authUser)
    }
}

#Preview {
    RootView()
}
