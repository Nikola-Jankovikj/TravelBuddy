//
//  ProfileImagePickerView.swift
//  TravelBuddy
//
//  Created by Nikola Jankovikj on 19.9.24.
//

import SwiftUI
import PhotosUI

struct ProfileImagePickerView: View {
    @Binding var selectedItem: PhotosPickerItem?
    @Binding var imageData: Data?
    var width: CGFloat
    var saveProfileImage: @MainActor (_ selectedItem: PhotosPickerItem) -> Void
    
    var body: some View {
        ZStack {
            Color.red
                .ignoresSafeArea()
            
            PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared()) {
                if let imageData, let image = UIImage(data: imageData) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: width)
                } else {
                    Text("Select photos")
                        .font(.largeTitle)
                        .foregroundColor(.black)
                }
            }
            .onChange(of: selectedItem) { oldValue, newValue in
                if let newValue {
                    saveProfileImage(newValue) // Call the callback
                }
            }
        }
    }
}

#Preview {
    ProfileImagePickerView(
        selectedItem: .constant(nil),
        imageData: .constant(nil),
        width: 300, // Some arbitrary width for preview
        saveProfileImage: { _ in }
    )
}
