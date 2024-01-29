//
//  BaseViewManager.swift
//  WebServerSocket
//
//  Created by Tolu Oridota on 1/29/24.
//

import Foundation
import UIKit

class BaseViewManagers: NSObject {
    
    @IBOutlet weak var presenterObject: AnyObject?
    
    @IBOutlet weak var viewControllerObject: AnyObject?
    
    // MARK: - ViewManager
    
    open func reload() {
        reload(animated: false)
    }
    
    open func reload(animated: Bool) {
        if animated { reloadAnimated(); return }
        reloadNonAnimated()
    }
    
    open func reloadNonAnimated() {
        // subclass should replace this with a non-animated reload
    }
    
    open func reloadAnimated() {
        // subclass should replace this with an animated reload
    }
}
