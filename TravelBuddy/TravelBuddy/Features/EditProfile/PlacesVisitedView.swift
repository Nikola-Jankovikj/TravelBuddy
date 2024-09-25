//
//  PlacesVisitedView.swift
//  TravelBuddy
//
//  Created by Nikola Jankovikj on 25.9.24.
//

import SwiftUI
import MapKit
import CoreLocation

struct PlacesVisitedView: View {
    @State private var coordinates: [CLLocationCoordinate2D] = []
    var cities: [Location]

    var body: some View {
        MapView(locations: $coordinates)
            .edgesIgnoringSafeArea(.all)
            .onAppear {
                Task {
                    await loadCoordinatesForLocations()
                }
            }
    }

    func loadCoordinatesForLocations() async {
        let geocoder = CLGeocoder()
        
        var newCoordinates: [CLLocationCoordinate2D] = []

        for city in cities {
            let address = city.description
            var placemarks = try? await geocoder.geocodeAddressString(address)
                if let placemark = placemarks?.first,
                   let location = placemark.location {
                    newCoordinates.append(location.coordinate)
                } else {
                    print("Geocoding failed for \(address)")
                }
        }
    }
}

#Preview {
    PlacesVisitedView(cities: [Location(city: "Belgrade", country: "Serbia"), Location(city: "Skopje", country: "North Macedonia")])
}
