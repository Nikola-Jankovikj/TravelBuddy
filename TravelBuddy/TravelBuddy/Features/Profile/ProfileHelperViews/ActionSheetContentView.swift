//
//  ActionSheetContentView.swift
//  TravelBuddy
//
//  Created by Nikola Jankovikj on 23.9.24.
//

import SwiftUI

extension ProfileImagePickerView {
    func actionSheetContent() -> ActionSheet {
        return ActionSheet(
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
}
