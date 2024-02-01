//
//  UIApplicationExtension.swift
//  WebServerSocket
//
//  Created by Tolu Oridota on 1/30/24.
//

import Foundation
import UIKit

extension UIApplication {
    
    /// Returns Top most ViewController in foreground
    /// - Parameter controller: RootViewController
    /// - Returns: Top most ViewController
    class func topViewController(controller: UIViewController? = Utils.getKeyWindow()?.rootViewController) -> UIViewController? {
        
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
