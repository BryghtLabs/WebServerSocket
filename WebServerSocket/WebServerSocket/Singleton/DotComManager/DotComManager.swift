//
//  DotComManager.swift
//  WebServerSocket
//
//  Created by Tolu Oridota on 1/29/24.
//

import Foundation
import UIKit
import WebKit

class DotComManager: NSObject {
    
    var dotComVC: DotComWebViewController?
    
    static var shared: DotComManager = DotComManager()
    
    override init() {}
    
    func start() {}
    
    func reset() {
        dotComVC = nil
    }
}
