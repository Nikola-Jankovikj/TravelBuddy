//
//  UserState.swift
//  TravelBuddy
//
//  Created by Nikola Jankovikj on 24.9.24.
//

import Foundation

class UserState {
    var showLoadingScreen: Bool = true
    var showSignInView: Bool = true
    var isDataFetched: Bool = false
    var user: DbUser? = nil
    var imageData: [Data] = []
}
