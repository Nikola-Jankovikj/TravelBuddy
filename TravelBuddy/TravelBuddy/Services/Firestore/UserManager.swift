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
    
    func createNewUser(auth: AuthDataResultModel) throws {
        var user = DbUser(id: auth.uid, dateCreated: Date.now, dateUpdated: Date.now)
        try Firestore.firestore().collection("users").document(auth.uid).setData(from: user)
    }
    
    func getUser(userId: String) async throws -> DbUser {
        let snapshot = try await Firestore.firestore().collection("users").document(userId).getDocument()
        
        guard let data = snapshot.data() else { throw URLError(.badServerResponse) }
        
        return DbUserMapper.shared.mapSnapshotToDbUser(dict: data)
    }
    
}
