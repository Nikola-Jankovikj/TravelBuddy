//
//  ProfileImagePickerView.swift
//  TravelBuddy
//
//  Created by Nikola Jankovikj on 19.9.24.
//

import SwiftUI
import PhotosUI
import AVFoundation
import UIKit

struct ProfileImagePickerView: View {
    @Binding var selectedItem: PhotosPickerItem?
    @Binding var imageData: Data?
    var width: CGFloat
    var saveProfileImage: @MainActor (_ selectedItem: Data) -> Void
    
    @State private var isShowingActionSheet = false
    @State private var isShowingImagePicker = false
    @State private var isUsingCamera = false
    @State private var cameraPermissionDenied = false
    
    var body: some View {
        ZStack {
            Color.red
                .ignoresSafeArea()
            
            if let imageData, let image = UIImage(data: imageData) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: width)
                    .onTapGesture {
                        isShowingActionSheet = true
                    }
            } else {
                Text("Select photos")
                    .font(.largeTitle)
                    .foregroundColor(.black)
                    .onTapGesture {
                        isShowingActionSheet = true
                    }
            }
        }
        .actionSheet(isPresented: $isShowingActionSheet) {
            ActionSheet(
                title: Text("Choose an option"),
                buttons: [
                    .default(Text("Take a Photo")) {
                        checkCameraPermissions()
                    },
                    .default(Text("Choose from Library")) {
                        isUsingCamera = false
                        isShowingImagePicker = true
                    },
                    .cancel()
                ]
            )
        }
        .alert(isPresented: $cameraPermissionDenied) {
            Alert(
                title: Text("Camera Access Denied"),
                message: Text("Please enable camera access in Settings."),
                primaryButton: .default(Text("Settings"), action: {
                    if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(appSettings)
                    }
                }),
                secondaryButton: .cancel()
            )
        }
        .sheet(isPresented: $isShowingImagePicker) {
            ImagePicker(sourceType: isUsingCamera ? .camera : .photoLibrary) { image in
                if let data = image.jpegData(compressionQuality: 0.8) {
                    self.imageData = data
                    saveProfileImage(data)
                }
            }
        }
    }
    
    // Function to check camera permissions
    private func checkCameraPermissions() {
        let cameraAuthStatus = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch cameraAuthStatus {
        case .authorized:
            // Camera access is authorized, proceed to use the camera
            isUsingCamera = true
            isShowingImagePicker = true
            
        case .notDetermined:
            // The user has not been prompted yet. Request access.
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    DispatchQueue.main.async {
                        isUsingCamera = true
                        isShowingImagePicker = true
                    }
                } else {
                    DispatchQueue.main.async {
                        cameraPermissionDenied = true
                    }
                }
            }
            
        case .denied, .restricted:
            // The user has previously denied camera access or it is restricted.
            cameraPermissionDenied = true
            
        @unknown default:
            print("Unknown camera authorization status.")
        }
    }
}

// ImagePicker to handle both camera and library selection
struct ImagePicker: UIViewControllerRepresentable {
    var sourceType: UIImagePickerController.SourceType
    var completionHandler: (UIImage) -> Void

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) { }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.completionHandler(image)
            }
            picker.dismiss(animated: true)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
}

#Preview {
    ProfileImagePickerView(
        selectedItem: .constant(nil),
        imageData: .constant(nil),
        width: 300,
        saveProfileImage: { _ in }
    )
}
