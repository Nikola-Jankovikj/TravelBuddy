//
//  MapView.swift
//  TravelBuddy
//
//  Created by Nikola Jankovikj on 25.9.24.
//

import Foundation
import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    @Binding var locations: [CLLocationCoordinate2D]

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView

        init(parent: MapView) {
            self.parent = parent
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        return mapView
    }

    func updateUIView(_ mapView: MKMapView, context: Context) {
        mapView.removeAnnotations(mapView.annotations)

        for locationCoordinate in locations {
            let annotation = MKPointAnnotation()
            annotation.coordinate = locationCoordinate
            mapView.addAnnotation(annotation)
        }

        if let firstCoordinate = locations.first {
            let region = MKCoordinateRegion(center: firstCoordinate, latitudinalMeters: 1000000, longitudinalMeters: 1000000)
            mapView.setRegion(region, animated: true)
        }
    }
}
