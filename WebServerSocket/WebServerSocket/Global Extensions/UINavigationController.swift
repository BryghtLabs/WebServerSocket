//
//  UINavigationController.swift
//  WebServerSocket
//
//  Created by Tolu Oridota on 1/29/24.
//

import Foundation
import UIKit

extension UINavigationController {
    
    
    func pushViewController(_ viewController: UIViewController,
                            animated: Bool = true,
                            delay: Double = 0.0,
                            isNavBarHidden: Bool = true,
                            completion:(() -> Void)? = nil) {
        self.pushViewController(viewController, animated: animated)
        Utils.delayExecution(delay) {
            if let completion = completion {
                completion()
            }
        }
    }
    
    
}
