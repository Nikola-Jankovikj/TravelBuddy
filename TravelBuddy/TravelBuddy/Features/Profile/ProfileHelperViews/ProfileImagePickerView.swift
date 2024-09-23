import SwiftUI
import PhotosUI

struct ProfileImagePickerView: View {
    @Binding var selectedItems: [PhotosPickerItem]
    @Binding var imageData: [Data?]
    var width: CGFloat
    var saveProfileImages: @MainActor (_ selectedItems: [Data]) -> Void
    var saveProfileImage: @MainActor (_ selectedItem: Data) -> Void
    var deleteImages: @MainActor () async throws -> Void
    
    @State var isShowingActionSheet = false
    @State var isShowingImagePicker = false
    @State var isUsingCamera = false
    @State var cameraPermissionDenied = false
    
    var body: some View {
        ZStack {
            Color.red
            
            if !imageData.compactMap({ $0 }).isEmpty {
                ImageSliderView(imageData: $imageData, width: width)
                    .onTapGesture {
                        isShowingActionSheet = true
                    }
            } else {
                PlaceholderView()
                    .onTapGesture {
                        isShowingActionSheet = true
                    }
            }
        }
        .actionSheet(isPresented: $isShowingActionSheet) {
            actionSheetContent()
        }
        .alert(isPresented: $cameraPermissionDenied) {
            cameraPermissionAlert()
        }
        .photosPicker(isPresented: $isShowingImagePicker, selection: $selectedItems, matching: .images)
        .onChange(of: selectedItems) { _ in
            handleSelectedItems()
        }
    }
    
    private func handleSelectedItems() {
        imageData.removeAll()
        Task {
            if let _ = try? await deleteImages() {
                for item in selectedItems {
                    if let data = try? await item.loadTransferable(type: Data.self) {
                        imageData.append(data)
                        await saveProfileImage(data)
                    }
                }
            } else {
                print("Error deleting images")
            }
        }
    }
}
