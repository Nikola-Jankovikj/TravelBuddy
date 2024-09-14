//
//  Utilities.swift
//  TravelBuddy
//
//  Created by Nikola Jankovikj on 12.9.24.
//

import Foundation
import UIKit

final class Utilities { //change to dependency injection
    
    static let shared = Utilities()
    private init() {}
    
    @MainActor
    class func topViewController(controller: UIViewController? = nil) -> UIViewController? {
        let controller = controller ?? UIApplication.shared.keyWindow?.rootViewController
        
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}