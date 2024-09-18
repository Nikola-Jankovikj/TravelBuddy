////
////  TmpView.swift
////  TravelBuddy
////
////  Created by Nikola Jankovikj on 18.9.24.
////
//
//import SwiftUI
//
//struct TmpView: View {
//    @ObservedObject var locationManager = LocationManager.shared
//    @Binding var location: Location
//    @Binding var showLocationRequestView: Bool
//    
//    var body: some View {
//        if locationManager.userLocation == nil {
//            LocationRequestView()
//        } else {
//            do {
//                updateLocationIfNeeded()
//            }
//        }
//    }
//    
//    func updateLocationIfNeeded() {
//        if let city = LocationManager.shared.city,
//           let country = LocationManager.shared.country {
//            location = Location(city: city, country: country)
//            showLocationRequestView = false
//        }
//    }
//}
//
//
//#Preview {
//    TmpView(location: .constant(Location(city: "", country: "")), showLocationRequestView: .constant(true))
//}
