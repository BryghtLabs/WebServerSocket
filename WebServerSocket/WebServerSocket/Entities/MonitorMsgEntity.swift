//
//  MonitorMsgEntity.swift
//  WebServerSocket
//
//  Created by Tolu Oridota on 1/29/24.
//

import Foundation
import UIKit
import WebKit

struct MonitorMsgEntity: Codable {
    
    let msgType: MsgHandlerType
    
    let msgMonitor: MsgMonitor
    
    var isError: Bool {
        return msgMonitor.isError
    }
    
    var errorMessage: String {
        return msgMonitor.errMsg
    }
    
    var monitorMessage: String {
        return msgMonitor.msg
    }
    
    struct MsgMonitor: Codable {
        let isError: Bool
        let errMsg: String
        let msg: String
    }
    
    static func getMsg(msg: WKScriptMessage) -> MonitorMsgEntity? {
        guard let dictData = msg.msgData else { return nil }
        guard let entity = MonitorMsgEntity.init(fromData: dictData) else { return nil }
        return entity
    }
    
}
