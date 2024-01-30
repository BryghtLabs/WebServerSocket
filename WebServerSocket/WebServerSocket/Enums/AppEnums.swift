//
//  AppEnums.swift
//  WebServerSocket
//
//  Created by Tolu Oridota on 1/29/24.
//

import Foundation
import UIKit

enum CDCStatusType: Int, Codable, CaseIterable {
    
    case Connected
    case Synced
    case NotSynced
    case IllegalMove
    case MoveMade
    case None
    
    var title: String {
        switch self {
        case .Connected: return "connected"
        case .Synced: return "synced"
        case .NotSynced: return "not-synced"
        case .IllegalMove: return "illegal-move"
        case .MoveMade: return "move-made"
        case .None: return ""
        }
    }
    
    func getStatusType(type: String) -> CDCStatusType? {
        switch type.lowercased() {
        case CDCStatusType.Connected.title: return .Connected
        case CDCStatusType.Synced.title: return .Synced
        case CDCStatusType.NotSynced.title: return .NotSynced
        case CDCStatusType.IllegalMove.title: return .IllegalMove
        case CDCStatusType.MoveMade.title: return .MoveMade
        default: return nil
        }
    }
    
}

enum DotComSocketHandlers: Int, Codable, CaseIterable {
    
    case StartUpError // 0
    case WebViewLogError // 1
    case SocketOpen // 2
    case SocketOpenError // 3
    case SocketOnMessage // 4
    case SocketOnMessageError // 5
    case SocketOnClose // 6
    case SocketOnCloseError // 7
    case SocketMainError // 8
    case None //
    
    var title: String {
        switch self {
        case .StartUpError: return "startUpError"
        case .WebViewLogError: return "webViewLogError"
        case .SocketOpen: return "socketOpen"
        case .SocketOpenError: return "socketOpenError"
        case .SocketOnMessage: return "socketOnMessage"
        case .SocketOnMessageError: return "socketOnMessageError"
        case .SocketOnClose: return "socketOnClose"
        case .SocketOnCloseError: return "socketOnCloseError"
        case .SocketMainError: return "socketMainError"
        case .None: return ""
        }
    }
    
    func getHandler(name: String) -> (type: DotComSocketHandlers, rawValue: Int) {
        let handler = name.lowercased()
        switch handler {
        case DotComSocketHandlers.StartUpError.title.lowercased(): return (DotComSocketHandlers.StartUpError, DotComSocketHandlers.StartUpError.rawValue)
        case DotComSocketHandlers.WebViewLogError.title.lowercased(): return (DotComSocketHandlers.WebViewLogError, DotComSocketHandlers.WebViewLogError.rawValue)
        case DotComSocketHandlers.SocketOpen.title.lowercased(): return (DotComSocketHandlers.SocketOpen, DotComSocketHandlers.SocketOpen.rawValue)
        case DotComSocketHandlers.SocketOpenError.title.lowercased(): return (DotComSocketHandlers.SocketOpenError, DotComSocketHandlers.SocketOpenError.rawValue)
        case DotComSocketHandlers.SocketOnMessage.title.lowercased(): return (DotComSocketHandlers.SocketOnMessage, DotComSocketHandlers.SocketOnMessage.rawValue)
        case DotComSocketHandlers.SocketOnMessageError.title.lowercased(): return (DotComSocketHandlers.SocketOnMessageError, DotComSocketHandlers.SocketOnMessageError.rawValue)
        case DotComSocketHandlers.SocketOnClose.title.lowercased(): return (DotComSocketHandlers.SocketOnClose, DotComSocketHandlers.SocketOnClose.rawValue)
        case DotComSocketHandlers.SocketOnCloseError.title.lowercased(): return (DotComSocketHandlers.SocketOnCloseError, DotComSocketHandlers.SocketOnCloseError.rawValue)
        case DotComSocketHandlers.SocketMainError.title.lowercased(): return (DotComSocketHandlers.SocketMainError, DotComSocketHandlers.SocketMainError.rawValue)
        default: return (DotComSocketHandlers.None, DotComSocketHandlers.None.rawValue)
        }
    }
    
}

struct DotComUrl {
    static let url = "https://www.chess.com"
    static let chessDotComConnectUrl = "https://www.chess.com/play/online/connected-board"
    //static let chessDotComSocketUrl  = "wss://socketsbay.com/wss/v2/1/demo/"
    static let chessDotComSocketUrl  = "ws://127.0.0.1:1999"
    //static let chessDotComSocketUrl  = "ws://localhost:1999"
    //static let chessDotComSocketUrl  = "com.bryghtlab.ChessUpBeta://localhost:1999"
}

/*
 "adding a root view controller <WebServerSocket.ViewController: 0x11000c600> as a child of view controller:<UINavigationController: 0x11285c000>"
 */
