//
//  CameraImagePickerView.swift
//  TravelBuddy
//
//  Created by Nikola Jankovikj on 23.9.24.
//

import AVFoundation
import UIKit
import SwiftUI

extension ProfileImagePickerView {
    func checkCameraPermissions() {
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
    
    func cameraPermissionAlert() -> Alert {
        return Alert(
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
}
