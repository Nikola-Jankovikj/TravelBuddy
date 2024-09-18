//
//  CreateProfileView.swift
//  TravelBuddy
//
//  Created by Nikola Jankovikj on 15.9.24.
//

import SwiftUI

struct CreateProfileView: View {
    @StateObject private var viewModel = CreateProfileViewModel()
    @Binding public var showSignInView: Bool

    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()

    var body: some View {
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
                        showSignInView = false
                    } catch {
                        print("Error \(error)")
                    }
                }
            }
        }
        .padding()
    }
}

#Preview {
    CreateProfileView(showSignInView: .constant(true))
}
