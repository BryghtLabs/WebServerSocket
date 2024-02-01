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
            let startUpLog = "SocketLog - StartUpError: \(startUpError.monitorMessage)\n"
            logDebugMessage(message: "SocketLog - StartUpError: \(startUpError.monitorMessage)")
            self.currentLogText += startUpLog
            self.dotComManagerDelegate?.dotComManagerLogLog(log: startUpLog)
        case .WebViewLogError:
            //guard let webViewLogError = MonitorMsgEntity.getMsg(msg: msg) else { return }
            let weViewErrorLog = "SocketLog - WebViewLogError: \(msg.body)\n"
            logDebugMessage(message: "SocketLog - WebViewLogError: \(msg.body)")
            self.currentLogText += weViewErrorLog
            self.dotComManagerDelegate?.dotComManagerLogLog(log: weViewErrorLog)
        case .SocketOpen:
            let openLog = "SocketLog - SOCKET OPENED!!!!\n"
            logDebugMessage(message: "SocketLog - SOCKET OPENED!!!!")
            self.currentLogText += openLog
            self.dotComManagerDelegate?.dotComManagerLogLog(log: openLog)
        case .SocketOpenError:
            guard let socketOpenError = MonitorMsgEntity.getMsg(msg: msg) else { return }
            let openError = "SocketLog - SocketOpenError: \(socketOpenError.monitorMessage)\n"
            logDebugMessage(message: "SocketLog - SocketOpenError: \(socketOpenError.monitorMessage)")
            self.currentLogText += openError
            self.dotComManagerDelegate?.dotComManagerLogLog(log: openError)
        case .SocketOnMessage:
            guard let socketOpenError = MonitorMsgEntity.getMsg(msg: msg) else { return }
            let onMsgLog = "SocketLog - SocketOnMessage Message Received: \(msg.body)\n"
            logDebugMessage(message: "SocketLog - SocketOnMessage Message Received: \(msg.body)")
            self.currentLogText += onMsgLog
            self.dotComManagerDelegate?.dotComManagerLogLog(log: onMsgLog)
        case .SocketOnMessageError:
            guard let socketOnMessageError = MonitorMsgEntity.getMsg(msg: msg) else { return }
            let onMessageLog = "SocketLog - SocketOnMessageError: \(socketOnMessageError.monitorMessage)\n"
            logDebugMessage(message: "SocketLog - SocketOnMessageError: \(socketOnMessageError.monitorMessage)")
            self.currentLogText += onMessageLog
            self.dotComManagerDelegate?.dotComManagerLogLog(log: onMessageLog)
        case .SocketOnClose:
            let onCloseLog = "SocketLog - SocketOnClose: Socket Closed\n"
            logDebugMessage(message: "SocketLog - SocketOnClose: Socket Closed")
            self.currentLogText += onCloseLog
            self.dotComManagerDelegate?.dotComManagerLogLog(log: onCloseLog)
        case .SocketOnCloseError:
            let onCloseError = "SocketLog - SocketOnCloseError\n"
            logDebugMessage(message: "SocketLog - SocketOnCloseError")
            self.currentLogText += onCloseError
            self.dotComManagerDelegate?.dotComManagerLogLog(log: onCloseError)
        case .SocketMainError:
            guard let socketMainError = MonitorMsgEntity.getMsg(msg: msg) else { return }
            let mainErrorLog = "SocketLog - SocketMainError: \(socketMainError.monitorMessage) -> \(msg.body)\n"
            logDebugMessage(message: "SocketLog - SocketMainError: \(socketMainError.monitorMessage) -> \(msg.body)")
            self.currentLogText += mainErrorLog
            self.dotComManagerDelegate?.dotComManagerLogLog(log: mainErrorLog)
        case .None:
            logDebugMessage(message: "")
        }
        
    }
    
}
