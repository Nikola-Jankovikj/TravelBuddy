//
//  LocationRequestView.swift
//  TravelBuddy
//
//  Created by Nikola Jankovikj on 18.9.24.
//

import SwiftUI

struct LocationRequestView: View {
    @Binding var showRequestLocationView: Bool
    
    var body: some View {
        ZStack {
            Color(.systemBlue).ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Image(systemName: "paperplane.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .padding(.bottom, 32)
                
                Text("Please provide your location.")
                    .font(.system(size: 28, weight: .semibold))
                    .multilineTextAlignment(.center)
                    .padding()
                
                Text("Start sharing your location with us")
                    .multilineTextAlignment(.center)
                    .frame(width: 140)
                    .padding()
                
                Spacer()
                
                VStack {
                    Button {
                        LocationManager.shared.requestLocation()
                        showRequestLocationView = false
                    } label: {
                        Text("Allow location")
                            .padding()
                            .font(.headline)
                            .foregroundColor(Color(.systemBlue))
                    }
                    .frame(width: UIScreen.main.bounds.width)
                    .padding(.horizontal, -32)
                    .background(Color.white)
                    .clipShape(Capsule())
                    .padding()
                    
                    Button {
                        showRequestLocationView = false
                    } label: {
                        Text("Maybe later")
                    }
                }
                .padding()
            }
            .foregroundColor(.white)
        }
    }
}

#Preview {
    LocationRequestView(showRequestLocationView: .constant(true))
}
