//
//  UserManager.swift
//  TravelBuddy
//
//  Created by Nikola Jankovikj on 14.9.24.
//

import Foundation
import FirebaseFirestore

final class UserManager {
    
    static let shared = UserManager()
    private init() { }
    
    func createNewUser(user: DbUser) throws {
//        var user = DbUser(id: auth.uid, dateCreated: Date.now, dateUpdated: Date.now)
//        let authDataResult = try await AuthenticationManager.shared.createUser(email: email, password: password)
        try Firestore.firestore().collection("users").document(user.id).setData(from: user)
    }
    
    func getUser(userId: String) async throws -> DbUser {
        let snapshot = try await Firestore.firestore().collection("users").document(userId).getDocument()
        
        guard let data = snapshot.data() else { throw URLError(.badServerResponse) }
        
        return DbUserMapper.shared.mapSnapshotToDbUser(dict: data)
    }
    
}
