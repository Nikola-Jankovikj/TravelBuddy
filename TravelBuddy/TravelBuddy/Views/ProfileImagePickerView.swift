import SwiftUI
import PhotosUI
import AVFoundation
import UIKit

struct ProfileImagePickerView: View {
    @Binding var selectedItems: [PhotosPickerItem]
    @Binding var imageData: [Data?]
    var width: CGFloat
    var saveProfileImages: @MainActor (_ selectedItems: [Data]) -> Void
    var saveProfileImage: @MainActor (_ selectedItem: Data) -> Void
    var deleteImages: @MainActor () async throws -> Void
    
    @State private var isShowingActionSheet = false
    @State private var isShowingImagePicker = false
    @State private var isUsingCamera = false
    @State private var cameraPermissionDenied = false
    
    var body: some View {
        ZStack {
            Color.red
                .ignoresSafeArea()
            
            if !imageData.compactMap({ $0 }).isEmpty {
                // Swipeable view of images
                TabView {
                    ForEach(imageData.compactMap { $0 }, id: \.self) { data in
                        if let image = UIImage(data: data) {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(maxWidth: width)
                                .onTapGesture {
                                    isShowingActionSheet = true
                                }
                        }
                    }
                }
                .tabViewStyle(PageTabViewStyle()) // Enable swipe functionality
                .frame(maxWidth: width, maxHeight: width * 1.5) // Adjust as per your layout
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
        .photosPicker(isPresented: $isShowingImagePicker, selection: $selectedItems, matching: .images)
        .onChange(of: selectedItems) { newItems in
            imageData.removeAll()
            Task {
                if let _ = try? await deleteImages() {
                    for item in selectedItems {
                        if let data = try? await item.loadTransferable(type: Data.self) {
                            imageData.append(data)
                            saveProfileImage(data)
                        }
                    }
                } else {
                    print("Error deleting images")
                }
            }
        }
    }
    
    // Function to check camera permissions
    private func checkCameraPermissions() {
        let cameraAuthStatus = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch cameraAuthStatus {
        case .authorized:
            isUsingCamera = true
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    if granted {
                        isUsingCamera = true
                    } else {
                        cameraPermissionDenied = true
                    }
                }
            }
        case .denied, .restricted:
            cameraPermissionDenied = true
        @unknown default:
            print("Unknown camera authorization status.")
        }
    }
}

// #Preview
#Preview {
    ProfileImagePickerView(
        selectedItems: .constant([]),
        imageData: .constant([]),
        width: 300,
        saveProfileImages: { _ in },
        saveProfileImage: { _ in },
        deleteImages: {}
    )
}
