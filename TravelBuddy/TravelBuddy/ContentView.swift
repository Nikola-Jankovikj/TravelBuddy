//
//  ContentView.swift
//  TravelBuddy
//
//  Created by Nikola Jankovikj on 8.9.24.
//

import SwiftUI
import SwiftData
import Firebase

struct ContentView: View {
    
    
    
    var body: some View {
        isFirebaseConfigured() ? Text("Hello world!") : Text("Nooo")
    }
    
    func isFirebaseConfigured() -> Bool {
        if let app = FirebaseApp.app() {
            print(app.options.apiKey ?? "Failure")
            return true
        } else {
          return false
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
