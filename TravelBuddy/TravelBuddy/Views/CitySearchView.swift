//
//  CitySearchView.swift
//  TravelBuddy
//
//  Created by Nikola Jankovikj on 24.9.24.
//

import SwiftUI
import MapKit

struct CitySearchView: View {
    @State private var searchText = ""
    @State private var matchingCities: [MKMapItem] = []
    @State private var selectedCity: (city: String, country: String)? = nil
    @FocusState private var isSearchBarFocused: Bool // 1. Focus state for search bar
    
    var body: some View {
        NavigationView {
            VStack {
                if let selectedCity = selectedCity {
                    Text("Selected City: \(selectedCity.city), \(selectedCity.country)")
                        .font(.title2)
                        .padding()
                }
                
                // List of matching cities for the search
                List(matchingCities, id: \.self) { city in
                    Button(action: {
                        selectCity(city)
                    }) {
                        VStack(alignment: .leading) {
                            Text(city.placemark.locality ?? "Unknown City")
                                .font(.headline)
                            Text(city.placemark.country ?? "Unknown Country")
                                .font(.subheadline)
                        }
                    }
                }
            }
            .navigationTitle("Search Cities")
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
            .focused($isSearchBarFocused) // 2. Attach focus state to search bar
            .onChange(of: searchText) { newValue in
                searchCities(query: newValue)
            }
        }
    }
    
    // Function to search cities using MKLocalSearch
    func searchCities(query: String) {
        guard !query.isEmpty else {
            self.matchingCities = []
            return
        }

        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.resultTypes = .address

        let search = MKLocalSearch(request: request)
        search.start { response, error in
            guard let response = response else {
                print("Error searching for cities: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            // Filter the results to include only those with locality and country, limit to top 10 results
            self.matchingCities = response.mapItems.filter {
                $0.placemark.locality != nil && $0.placemark.country != nil
            }.prefix(10).map { $0 } // Limit to 10 results for better prediction
        }
    }
    
    // Function to handle city selection
    func selectCity(_ city: MKMapItem) {
        if let cityName = city.placemark.locality, let countryName = city.placemark.country {
            self.selectedCity = (city: cityName, country: countryName)
        }
        self.searchText = "" // Clear the search text after selecting a city
        self.matchingCities = [] // Clear the results after selection
        isSearchBarFocused = false // 3. Remove focus from search bar to dismiss the keyboard
    }
}

struct CitySearchView_Previews: PreviewProvider {
    static var previews: some View {
        CitySearchView()
    }
}
