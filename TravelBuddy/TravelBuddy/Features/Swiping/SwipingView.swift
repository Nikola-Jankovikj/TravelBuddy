//
//  SwipingView.swift
//  TravelBuddy
//
//  Created by Nikola Jankovikj on 19.9.24.
//

import SwiftUI

struct SwipingView: View {
    @StateObject private var viewModel = SwipingViewModel()
    
    var body: some View {
        VStack {
            CitySearchView()
            
            Text("Location: \(viewModel.location)")
            
        }
    }
}

#Preview {
    SwipingView()
}
