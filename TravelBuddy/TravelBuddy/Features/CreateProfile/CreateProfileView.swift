//
//  CreateProfileView.swift
//  TravelBuddy
//
//  Created by Nikola Jankovikj on 15.9.24.
//

import SwiftUI

struct CreateProfileView: View {
    @StateObject private var viewModel = CreateProfileViewModel()
    @State private var isProfileCreated = false // Track if profile is created

    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()

    var body: some View {
        NavigationStack {
            VStack {
                TextField("Name...", text: $viewModel.name)
                    .padding()
                    .background(Color.gray.opacity(0.4))
                    .cornerRadius(10)

                TextField("Favorite activity...", text: $viewModel.favoriteActivity)
                    .padding()
                    .background(Color.gray.opacity(0.4))
                    .cornerRadius(10)

                TextField("Description...", text: $viewModel.description)
                    .padding()
                    .background(Color.gray.opacity(0.4))
                    .cornerRadius(10)

                Stepper("\(viewModel.age) years old", value: $viewModel.age, in: 18...100)
                    .padding()

                Button("Create Profile") {
                    Task {
                        do {
                            try viewModel.createProfile()
                            isProfileCreated = true // Set to true when profile is successfully created
                        } catch {
                            print("Error \(error)")
                        }
                    }
                }
                .navigationDestination(isPresented: $isProfileCreated) {
                    ProfileView(showSignInView: .constant(false))
                }
            }
            .padding()
        }
    }
}

#Preview {
    CreateProfileView()
}
