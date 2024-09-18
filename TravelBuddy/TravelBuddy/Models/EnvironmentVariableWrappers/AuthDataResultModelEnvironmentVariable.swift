//
//  AuthDataResultModelEnvironmentVariable.swift
//  TravelBuddy
//
//  Created by Nikola Jankovikj on 18.9.24.
//

import Foundation

class AuthDataResultModelEnvironmentVariable : ObservableObject {
    @Published var authData: AuthDataResultModel
    
    init() { 
        authData = AuthDataResultModel(uid: "-1", email: "nomail", photoUrl: "nophoto")
    }
    
    func saveAuthData(newAuthData: AuthDataResultModel) {
        self.authData = newAuthData
    }
}
