//
//  AppWebSocket.swift
//  WebServerSocket
//
//  Created by Tolu Oridota on 1/29/24.
//

import Foundation
import UIKit
import Starscream

protocol AppWebSocketProtocol: AnyObject {
    func socketConnected(isConnected: Bool)
    func socketRecievedText(socketText: String)
    func socketError(socketError: Error?)
    func socketViabilityChanged(isViable: Bool)
    func socketBoardStatus(statusType: CDCStatusType)
}

class AppWebSocket {
    
    var socket: WebSocket?
    
    var socketRequest: URLRequest?
    
    var socketQueue: DispatchQueue?
    
    var isConnected: Bool = false
    
    var socketHeaders: [String: String] = [String: String]()
    
    weak var appWebSocketDelegate: AppWebSocketProtocol?
    
    static var shared: AppWebSocket = AppWebSocket()
    
    init() {}
    
    func start(queue: DispatchQueue? = nil) {
        socketQueue = queue
        startWebSocket()
    }
    
    func setDelegate(delegate: AppWebSocketProtocol) {
        self.appWebSocketDelegate = delegate
    }
    
    private func startWebSocket() {
        //let webSocketUrl = ContentfulSession.shared.chessUpDefaults?.chessDotComSocketUrl ?? ChessDotCom.chessDotComSocketUrl
        let webSocketUrl = DotComUrl.chessDotComSocketUrl
        guard let socketUrl = URL(string: webSocketUrl) else { return }
        
        self.socketRequest = URLRequest(url: socketUrl)
        self.setSocketHeaders()
        
        /**This is automatically taken care of by defualt. Meaning a pong is sent when a ping is recieved
         otherwise this flag can stop the automatic response**/
        //socket?.respondToPingWithPong = false
        
        if let request = self.socketRequest {
            
            socket = WebSocket(request: request)
            //socket?.request.urlRequest.
            //socket?.request.requiresDNSSECValidation = false
            socket?.delegate = self
            socket?.connect()
        }
    }
    
    private func setSocketHeaders() {
        /*
         self.socketRequest?.setValue("someother protocols", forHTTPHeaderField: "Sec-WebSocket-Protocol")
         self.socketRequest?.setValue("14", forHTTPHeaderField: "Sec-WebSocket-Version")
         self.socketRequest?.setValue("chat,superchat", forHTTPHeaderField: "Sec-WebSocket-Protocol")
         self.socketRequest?.setValue("Something", forHTTPHeaderField: "Other")
         */
    }
    
    func stopSocket() {
        self.socket?.disconnect()
    }
    
}

extension AppWebSocket: WebSocketDelegate {
    
    func didReceive(event: Starscream.WebSocketEvent, client: Starscream.WebSocketClient) {
        logDebugMessage(message: "CDCServer - WebSocket: \(client)")
        switch event {
        case .connected(let headers):
            self.handleConnection(headers: headers)
        case .disconnected(let reason, let reasonCode):
            self.handleDisConnection(reason: reason, reasonCode: reasonCode)
        case .text(let string):
            self.handleSocketText(socketText: string)
        case .binary(let socketData):
            self.parseSocketData(socketData: socketData)
        case .pong(let data):
            self.handleSocketPong(data: data)
        case .ping(let data):
            self.handleSocketPing(data: data)
        case .error(let error):
            self.handleSocketError(socketError: error)
        case .viabilityChanged(let isViable):
            self.handleSocketViabilityChanged(isViable: isViable)
        case .reconnectSuggested(let reconnect):
            self.handleSocketReconnectSuggested(reconnect: reconnect)
        case .cancelled:
            self.handleDisConnection()
        case .peerClosed:
            self.handlePeerClosed()
        }
    }
    
    private func handleConnection(headers: [String: String]) {
        self.isConnected = true
        self.socketHeaders = headers
        self.appWebSocketDelegate?.socketConnected(isConnected: true)
        logDebugMessage(message: "CDCServer - CDCWS - WebSocket Is Now Connected")
        logDebugMessage(message: "CDCServer - CDCWS - WebSocket Headers: \(headers)")
    }
    
    private func handleDisConnection(reason: String? = nil, reasonCode: UInt16? = nil) {
        self.isConnected = false
        self.appWebSocketDelegate?.socketConnected(isConnected: false)
        if let reason = reason, let reasonCode = reasonCode {
            logDebugError(message: "CDCServer - CDCWS - WebSocket is disconnected because: \(reason) with code: \(reasonCode)")
        } else {
            logDebugError(message: "CDCServer - CDCWS - WebSocket Cancelled")
        }
    }
    
    private func handleSocketText(socketText: String) {
        self.appWebSocketDelegate?.socketRecievedText(socketText: socketText)
        logDebugMessage(message: "CDCServer - CDCWS - Received Websocket Text: \(socketText)")
    }
    
    private func handleSocketPong(data: Data?) {
        logDebugMessage(message: "CDCServer - CDCWS - WebSocket Pong: \(data ?? Data())")
    }
    
    private func handleSocketPing(data: Data?) {
        logDebugMessage(message: "CDCServer - CDCWS - WebSocket Ping: \(data ?? Data())")
    }
    
    private func handleSocketError(socketError: Error?) {
        self.appWebSocketDelegate?.socketError(socketError: socketError)
        logDebugError(message: "CDCServer - CDCWS - WebSocket Error \(String(describing: socketError))")
    }
    
    private func handleSocketViabilityChanged(isViable: Bool) {
        self.appWebSocketDelegate?.socketViabilityChanged(isViable: isViable)
        logDebugMessage(message: "CDCServer - CDCWS - WebSocket Viability Change: \(isViable)")
    }
    
    private func handleSocketReconnectSuggested(reconnect: Bool) {
        logDebugMessage(message: "CDCServer - CDCWS - WebSocket Reconnect Suggested: \(reconnect)")
    }
    
    private func handlePeerClosed() {
        logDebugError(message: "CDCServer - CDCWS - WebSocket Peer Closed")
    }
    
}

extension AppWebSocket {
    
    private func parseSocketData(socketData: Data) {
        logDebugMessage(message: "CDCServer - CDCWS - Received WebSocket Data: \(socketData.count)")
    }
    
}

extension AppWebSocket {
    
    func writeSocketData(data: Data) {
        self.socket?.write(data: data, completion: {
            logDebugMessage(message: "CDCServer - CDCWS - Data written to socket")
        })
    }
    
    func writeSocketString(socString: String) {
        self.socket?.write(string: socString, completion: {
            logDebugMessage(message: "CDCServer - CDCWS - String written to socket")
        })
    }
    
    func writeSocketStringData(stringData: Data) {
        self.socket?.write(stringData: stringData, completion: {
            logDebugMessage(message: "CDCServer - CDCWS - String Data written to socket")
        })
    }
    
    func writeSocketPong(pong: Data = Data()) {
        self.socket?.write(pong: pong)
    }
    
}
