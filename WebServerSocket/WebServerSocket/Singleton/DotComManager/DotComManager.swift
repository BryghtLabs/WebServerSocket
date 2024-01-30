//
//  DotComManager.swift
//  WebServerSocket
//
//  Created by Tolu Oridota on 1/29/24.
//

import Foundation
import UIKit
import WebKit

protocol DotComManagerProtocol: AnyObject {
    func dotComManagerLogLog(log: String)
}

class DotComManager: NSObject {
    
    var dotComVC: DotComWebViewController?
    
    weak var dotComManagerDelegate: DotComManagerProtocol?
    
    static var shared: DotComManager = DotComManager()
    
    override init() {}
    
    func start() {}
    
    func reset() {
        dotComVC = nil
    }
}
