//
//  DotComWebViewPresenter.swift
//  WebServerSocket
//
//  Created by Tolu Oridota on 1/29/24.
//

import Foundation
import UIKit
import WebKit

extension DotComWebViewPresenter: AppWebSocketProtocol {
    
    func socketConnected(isConnected: Bool) {
        logDebugMessage(message: "")
    }
    
    func socketRecievedText(socketText: String) {
        logDebugMessage(message: "")
    }
    
    func socketError(socketError: Error?) {
        logDebugMessage(message: "")
    }
    
    func socketViabilityChanged(isViable: Bool) {
        logDebugMessage(message: "")
    }
    
    func socketBoardStatus(statusType: CDCStatusType) {
        logDebugMessage(message: "")
    }
    
}
