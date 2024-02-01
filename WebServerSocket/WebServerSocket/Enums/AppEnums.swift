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

enum ScreenHeight: Int, Codable, CaseIterable {
    case Large
    case Medium
    case Small
}

enum ScreenWidth: Int, Codable, CaseIterable {
    case Large
    case Medium
    case Small
}

enum PrecisionScreenWidth: Int, Codable, CaseIterable {
    case Small
    case Medium
    case Large
    case ExtraLarge
    case ExtraXLarge
}

enum IPadScreenWidth: Int, Codable, CaseIterable {
    case Mini
    case Small
    case Medium
    case Large
    case ExtraLarge
}

enum IPadScreenHeight: Int, Codable, CaseIterable {
    case Mini
    case Small
    case Medium
    case Large
    case ExtraLarge
}

public enum DeviceHardwareType: Int, CaseIterable  {
    case iPhone
    case iPad
    case tvOS
    case carPlay
    case mac
    case none
}
