//
//  SwipingView.swift
//  TravelBuddy
//
//  Created by Nikola Jankovikj on 19.9.24.
//

import SwiftUI

struct SwipingView: View {
    @StateObject private var viewModel = SwipingViewModel()
    
    @State var showSwipingFilterView: Bool = false
    
    
    var body: some View {
        VStack {
//            ScrollView {
////                ForEach
//            }
            
            NavigationStack {
                Button("Show filters") {
                    print("id: \(viewModel.id)")
                    showSwipingFilterView.toggle()
                }
            }
            .navigationDestination(isPresented: $showSwipingFilterView) {
                SwipingFilterView(viewModel: viewModel, showSwipingFilterView: $showSwipingFilterView)
            }
            
            Text("Trips: \(viewModel.trips)")
        }
    }
}

#Preview {
    SwipingView()
}
