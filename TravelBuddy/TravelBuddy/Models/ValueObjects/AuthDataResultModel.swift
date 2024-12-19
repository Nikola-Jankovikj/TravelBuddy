//
//  AuthDataResultModel.swift
//  TravelBuddy
//
//  Created by Nikola Jankovikj on 14.9.24.
//

import Foundation
import FirebaseAuth

class AuthDataResultModel {
    let uid: String
    let email: String?
    let photoUrl: String?
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email
        self.photoUrl = user.photoURL?.absoluteString
    }
    
    init(uid: String, email: String, photoUrl: String) {
        self.uid = uid
        self.email = email
        self.photoUrl = photoUrl
    }
}
