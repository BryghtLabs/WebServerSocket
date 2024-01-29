//
//  ViewController.swift
//  WebServerSocket
//
//  Created by Tolu Oridota on 1/29/24.
//

import UIKit

class ViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        initiateWebServerSocket()
    }
    
    func initiateWebServerSocket() {
        self.startWebServer()
        Utils.delayExecution(1) {
            self.startWebSocket()
        }
    }
    
    func startWebServer() {
        WebServer.shared.start()
    }
    
    func startWebSocket() {
        AppWebSocket.shared.start()
    }


}

