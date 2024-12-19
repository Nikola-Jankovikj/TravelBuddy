//
//  RootView.swift
//  TravelBuddy
//
//  Created by Nikola Jankovikj on 12.9.24.
//

import SwiftUI

struct RootView: View {
    
    @StateObject private var viewModel = RootViewModel()
    
    var body: some View {
        ZStack{
            if !viewModel.showSignInView {
                
                if viewModel.showLoadingScreen {
                    NavigationStack {
                        LoadingView()
                            .onAppear() {
                                Task {
                                    try await viewModel.fetchData()
                                }
                            }
                    }
                }
                
                if viewModel.isDataFetched {
                    NavigationStack {
                        MainAppView(showSignInView: $viewModel.showSignInView, imageData: $viewModel.imageData, user: $viewModel.user)
                    }
                }
            }
        }
        .onAppear {
            UIApplication.shared.applicationIconBadgeNumber = 0
            viewModel.checkLogin()
        }
        .fullScreenCover(isPresented: $viewModel.showSignInView, content: {
            NavigationStack {
                AuthenticationView(showSignInView: $viewModel.showSignInView)
                    .onDisappear() {
                        viewModel.isDataFetched = false
                        viewModel.showLoadingScreen = true
                    }
            }
        })
    }
}

#Preview {
    RootView()
}
