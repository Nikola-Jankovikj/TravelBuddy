import SwiftUI
import UIKit

struct ShakeDetector: UIViewControllerRepresentable {
    @Binding var showAlert: Bool

    class Coordinator: UIResponder, UIAccelerometerDelegate {
        var parent: ShakeDetector

        init(parent: ShakeDetector) {
            self.parent = parent
        }

        override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
            if motion == .motionShake {
                parent.showAlert = true
            }
        }

        override var canBecomeFirstResponder: Bool {
            true
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = ShakeDetectingViewController()
        viewController.coordinator = context.coordinator
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    }

    class ShakeDetectingViewController: UIViewController {
        weak var coordinator: Coordinator?

        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            self.becomeFirstResponder()
        }

        override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
            coordinator?.motionEnded(motion, with: event)
        }

        override var canBecomeFirstResponder: Bool {
            return true
        }
    }
}
