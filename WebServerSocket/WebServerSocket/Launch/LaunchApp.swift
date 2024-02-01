//
//  LaunchApp.swift
//  WebServerSocket
//
//  Created by Tolu Oridota on 1/30/24.
//

import Foundation
import UIKit

class LaunchApp: NSObject {
    
    func launchApp() {
        loadHome()
    }
    
    func loadHome() {
        globalMainQueue.async {
            guard let mainController = ViewController.make() else { return }
            let navController = UINavigationController(rootViewController: mainController)
            //UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController = navController
            UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }
                .flatMap { $0.windows }
                .last { $0.isKeyWindow }?
                .rootViewController = navController
        }
    }
    
    
}
