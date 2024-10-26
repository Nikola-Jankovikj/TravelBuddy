//
//  SwipingFilterView.swift
//  TravelBuddy
//
//  Created by Nikola Jankovikj on 25.9.24.
//

import SwiftUI

struct SwipingFilterView: View {
    @StateObject var viewModel: SwipingViewModel
    @Binding var showSwipingFilterView: Bool
    @Binding var user: DbUser?
    
    var body: some View {
        VStack {
            NavigationStack {
                if viewModel.location.description == ", " {
                    Button("Choose location") {
                        viewModel.showCitySearchView = true
                    }
                } else {
                    Button("\(viewModel.location)") {
                        viewModel.showCitySearchView = true
                    }
                }
            }
            .navigationDestination(isPresented: $viewModel.showCitySearchView) {
                CitySearchView(showCitySearchView: $viewModel.showCitySearchView, location: $viewModel.location)
            }
            
            // DatePickers for From and To Dates
            DatePicker("Date From", selection: $viewModel.dateFrom, in: Date()..., displayedComponents: .date)
                .padding()

            DatePicker("Date To", selection: $viewModel.dateTo, in: viewModel.dateFrom..., displayedComponents: .date)
                .padding()

            // Activities Section
            Text("Preferred Activities")
                .font(.headline)
                .padding(.top)

            ForEach(Activity.allCases, id: \.self) { activity in
                MultipleSelectionRow(activity: activity, isSelected: viewModel.selectedActivities.contains(activity)) {
                    if viewModel.selectedActivities.contains(activity) {
                        viewModel.selectedActivities.remove(activity)
                    } else {
                        viewModel.selectedActivities.insert(activity)
                    }
                }
            }
            .padding(.horizontal)
            
            Button("Submit") {
                Task {
                    print("\(viewModel.selectedActivities)")
                    try await viewModel.getTripsWithFilter(loggedInUser: user!)
                    showSwipingFilterView.toggle()
                }
            }
            
        }
    }
}

//#Preview {
//    SwipingFilterView()
//}
