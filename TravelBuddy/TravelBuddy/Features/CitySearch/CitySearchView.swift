////
////  CitySearchView.swift
////  TravelBuddy
////
////  Created by Nikola Jankovikj on 15.9.24.
////
//
//import SwiftUI
//import MapKit
//
//struct CitySearchView: View {
//    @StateObject private var viewModel = CitySearchViewModel()
//    @Binding var finalCity: MKLocalSearchCompletion
//    @State private var selectedCity: MKLocalSearchCompletion? = nil
//    
//    var body: some View {
//        VStack {
//            TextField("Search for a city...", text: $viewModel.queryFragment)
//                .padding()
//                .background(Color.gray.opacity(0.4))
//                .cornerRadius(10)
//            
//            List(viewModel.searchResults, id: \.self) { result in
//                VStack(alignment: .leading) {
//                    Text(result.title)
//                        .font(.headline)
//                    Text(result.subtitle)
//                        .font(.subheadline)
//                }
//                .onTapGesture {
//                    viewModel.queryFragment = result.title
//                    selectedCity = result
////                    searchForCity(result)
//                }
//            }
//            
//            if let city = selectedCity {
//                Button("Select: \(city.title)"){
//                    
//                }
//                .padding()
//            }
//        }
//    }
//    
//    // Function to perform search after user taps a result
//    private func searchForCity(_ city: MKLocalSearchCompletion) {
//        let searchRequest = MKLocalSearch.Request(completion: city)
//        let search = MKLocalSearch(request: searchRequest)
//        
//        search.start { response, error in
//            guard let response = response else {
//                print("Error searching for city: \(error?.localizedDescription ?? "Unknown error")")
//                return
//            }
//            
//            // Handle the location data (response.mapItems) for the selected city
//            if let firstItem = response.mapItems.first {
//                print("Coordinates: \(firstItem.placemark.coordinate.latitude), \(firstItem.placemark.coordinate.longitude)")
//            }
//        }
//    }
//}
//
//#Preview {
//    CitySearchView(finalCity: .constant())
//}
