////
////  CitySearchViewModel.swift
////  TravelBuddy
////
////  Created by Nikola Jankovikj on 15.9.24.
////
//
//import Foundation
//import MapKit
//
//class CitySearchViewModel: NSObject, ObservableObject, MKLocalSearchCompleterDelegate {
//    @Published var queryFragment: String = "" {
//        didSet {
//            searchCompleter.queryFragment = queryFragment
//        }
//    }
//    @Published var searchResults: [MKLocalSearchCompletion] = []
//    
//    private var searchCompleter: MKLocalSearchCompleter
//    
//    override init() {
//        searchCompleter = MKLocalSearchCompleter()
//        super.init()
//        searchCompleter.delegate = self
//        searchCompleter.resultTypes = .address
//    }
//    
//    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
//        DispatchQueue.main.async {
//            self.searchResults = completer.results
//        }
//    }
//    
//    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
//        print("Error searching: \(error.localizedDescription)")
//    }
//}
//
//
