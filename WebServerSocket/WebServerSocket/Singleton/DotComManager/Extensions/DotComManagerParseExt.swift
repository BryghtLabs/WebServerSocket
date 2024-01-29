//
//  DotComManagerParseExt.swift
//  WebServerSocket
//
//  Created by Tolu Oridota on 1/29/24.
//

import Foundation
import UIKit
import WebKit

extension DotComManager {
    
    func parseSocMessage(dotComVC: DotComWebViewController?, msg: WKScriptMessage) {
        
        self.dotComVC = dotComVC
        let msgType = DotComSocketHandlers.None.getHandler(name: msg.name)
        
        switch msgType.type {
        case .StartUpError:
            guard let startUpError = MonitorMsgEntity.getMsg(msg: msg) else { return }
            logDebugMessage(message: "SocketLog - StartUpError: \(startUpError.monitorMessage)")
        case .WebViewLogError:
            //guard let webViewLogError = MonitorMsgEntity.getMsg(msg: msg) else { return }
            logDebugMessage(message: "SocketLog - WebViewLogError: \(msg.body)")
        case .SocketOpen:
            logDebugMessage(message: "")
        case .SocketOpenError:
            guard let socketOpenError = MonitorMsgEntity.getMsg(msg: msg) else { return }
            logDebugMessage(message: "SocketLog - SocketOpenError: \(socketOpenError.monitorMessage)")
        case .SocketOnMessage:
            logDebugMessage(message: "")
        case .SocketOnMessageError:
            guard let socketOnMessageError = MonitorMsgEntity.getMsg(msg: msg) else { return }
            logDebugMessage(message: "SocketLog - SocketOnMessageError: \(socketOnMessageError.monitorMessage)")
        case .SocketOnClose:
            logDebugMessage(message: "")
        case .SocketOnCloseError:
            logDebugMessage(message: "")
        case .SocketMainError:
            guard let socketMainError = MonitorMsgEntity.getMsg(msg: msg) else { return }
            logDebugMessage(message: "SocketLog - SocketMainError: \(socketMainError.monitorMessage) -> \(msg.body)")
        case .None:
            logDebugMessage(message: "")
        }
        
    }
    
}
