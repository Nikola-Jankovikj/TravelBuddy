//
//  LoadingView.swift
//  TravelBuddy
//
//  Created by Nikola Jankovikj on 24.9.24.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack {
            Color.blue.ignoresSafeArea()
            VStack {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .black))
                    .scaleEffect(3)
                    .padding(.bottom)
                Text("Loading...")
                    .font(.title)
                    .foregroundStyle(.white)
                    .padding(.top)
            }
        }
    }
}

#Preview {
    LoadingView()
}
