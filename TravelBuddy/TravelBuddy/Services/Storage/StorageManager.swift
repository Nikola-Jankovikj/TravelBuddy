//
//  StorageManager.swift
//  TravelBuddy
//
//  Created by Nikola Jankovikj on 19.9.24.
//

import Foundation
import FirebaseStorage

final class StorageManager {
    
    static let shared = StorageManager()
    
    private init() { }
    
    private let storage = Storage.storage().reference()
    
    private var imagesReference: StorageReference {
        storage.child("images")
    }
    
    private func userReference(userId: String) -> StorageReference {
        storage.child("users").child(userId)
    }
    
    func getPathForImage(path: String) -> StorageReference {
        Storage.storage().reference(withPath: path)
    }
    
    func saveImage(data: Data, userId: String) async throws -> (path: String, name: String) {
        let meta = StorageMetadata()
        meta.contentType = "image/jpeg"
        
        let path = "\(UUID().uuidString).jpeg"
        let returnedMetaData = try await userReference(userId: userId).child(path).putDataAsync(data, metadata: meta)
        
        guard let returnedPath = returnedMetaData.path, let returnedName = returnedMetaData.name else {
            throw URLError(.badServerResponse)
        }
        
        return (returnedPath, returnedName)
    }

    func saveImages(dataList: [Data], userId: String) async throws -> [(path: String, name: String)] {
        let meta = StorageMetadata()
        meta.contentType = "image/jpeg"
        
        var uploadedImages: [(path: String, name: String)] = []
        
        for data in dataList {
            let path = "\(UUID().uuidString).jpeg"
            let reference = userReference(userId: userId).child(path)

            let returnedMetaData = try await reference.putDataAsync(data, metadata: meta)
            
            uploadedImages.append((path: path, name: returnedMetaData.name!))
        }
        
        // Return all uploaded image paths and names
        return uploadedImages
    }

    
    
    func getData(userId: String, name: String) async throws -> Data {
        try await userReference(userId: userId).child(name).data(maxSize: 3 * 1024 * 1024)
    }
    
    func getAllData(userId: String) async throws -> [Data] {
        var data: [Data] = []
        let allPhotos = try await userReference(userId: userId).listAll()
        for photoRef in allPhotos.items {
            let photoData = try await photoRef.data(maxSize: 3 * 1280 * 1280)
            data.append(photoData)
        }
        return data
    }
    
    func deleteImages(userId: String) async throws {
        let userImagesRef = userReference(userId: userId)

        let result = try await userImagesRef.listAll()
        
        for item in result.items {
            try await item.delete()
        }
    }

}
