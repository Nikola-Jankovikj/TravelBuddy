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
    
    private let userCollection = Firestore.firestore().collection("users")
    
    private func userDocument(userId: String) -> DocumentReference {
        userCollection.document(userId)
    }
    
    func createNewUser(user: DbUser) throws {
//        try Firestore.firestore().collection("users").document(user.id).setData(from: user)
        
        try userDocument(userId: user.id).setData(from: user)
    }
    
    func getUser(userId: String) async throws -> DbUser {
        let snapshot = try await userDocument(userId: userId).getDocument()
        
        guard let data = snapshot.data() else { throw URLError(.badServerResponse) }
        
        return DbUserMapper.shared.mapSnapshotToDbUser(dict: data)
    }
    
    func updateUserProfileImagePath(userId: String, name: String) async throws {
        guard var user = try? await getUser(userId: userId) else { return }
        user.personalPhotos.append(name)
        try userDocument(userId: userId).setData(from: user)
    }
    
    func deletePhotos(userId: String) async throws {
        guard var user = try? await getUser(userId: userId) else { return }
        user.personalPhotos = []
        try userDocument(userId: userId).setData(from: user)
    }
    
}
