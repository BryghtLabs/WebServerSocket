//
//  WebServer.swift
//  WebServerSocket
//
//  Created by Tolu Oridota on 1/29/24.
//

import Foundation
import UIKit
import Telegraph

protocol AppWebServerProtocol: AnyObject {
    func serverLog(log: String)
}

class WebServer {
    
    var cdcServer: Server?
    
    var webSocketClient: WebSocketClient?
    
    var webSocket: WebSocket?
    
    var isWebServerOn: Bool = false
    
    weak var appWebServerDelegate: AppWebServerProtocol?
    
    static var shared: WebServer = WebServer()
    
    init() {}
    
    func start() {
        globalMainQueue.async {
            self.startWebServer()
        }
    }
    
    func stop() {
        self.cdcServer?.stop(immediately: true)
        self.isWebServerOn = false
    }
    
    private func startWebServer() {
        
        self.cdcServer = Server()
        self.cdcServer?.delegate = self
        self.cdcServer?.webSocketDelegate = self
        self.cdcServer?.webSocketConfig.pingInterval = 4
        //self.cdcServer?.
        
        //self.cdcServer?.serveBundle(.main, "/")
        
        self.cdcServer?.concurrency = 4
        
        do {
            //let bundleUrl = Bundle.main.url(forResource: "ChessUpBeta", withExtension: nil)
            //self.cdcServer?.serveDirectory(bundleUrl!, "/ChessUp")
            try self.cdcServer?.start(port: 1999, interface: "127.0.0.1")
            //try self.cdcServer?.start(port: 1999, interface: "localhost")
            self.isWebServerOn = true
            let startLog = "App WebServer Started: \(serverURL())\n"
            self.appWebServerDelegate?.serverLog(log: startLog)
        } catch (let error) {
            self.isWebServerOn = false
            let startError = "App WebServer Did Not Start: \(error)\n"
            self.appWebServerDelegate?.serverLog(log: startError)
            logDebugError(message: "CDCServer - Error trying to start server: \(error)")
        }
        
        logDebugMessage(message: "CDCServer - Server is running - url: \(serverURL())")
        
    }
    
    /// Generates a server url, we'll assume the server has been started.
    private func serverURL(path: String = "") -> URL {
        guard let server = cdcServer else { return URL(string: "")! }
        var components = URLComponents()
        components.scheme = server.isSecure ? "wss" : "ws"
        components.host = "localhost"
        components.port = Int(server.port)
        components.path = path
        return components.url!
    }
    
    
}

extension WebServer: ServerDelegate {
    
    func serverDidStop(_ server: Telegraph.Server, error: Error?) {
        self.isWebServerOn = false
        let stopError = "App WebServer Did Stop with: \(error?.localizedDescription ?? "no error details")\n"
        self.appWebServerDelegate?.serverLog(log: stopError)
        logDebugMessage(message: "CDCServer - Server stopped: \(error?.localizedDescription ?? "no error details")")
    }
    
}

extension WebServer: ServerWebSocketDelegate {
    
    func server(_ server: Telegraph.Server, webSocketDidConnect webSocket: Telegraph.WebSocket, handshake: Telegraph.HTTPRequest) {
        let name = handshake.headers["X-Name"] ?? "stranger"
        logDebugMessage(message: "CDCServer - WebSocket Connected: - name: \(name)")
        let didConnectLog = "App WebServer connected to socket: \(name)\n"
        self.appWebServerDelegate?.serverLog(log: didConnectLog)
    }
    
    func server(_ server: Telegraph.Server, webSocketDidDisconnect webSocket: Telegraph.WebSocket, error: Error?) {
        let didDisconnectLog = "App WebServer disconnected from socket: \(error?.localizedDescription ?? "no error details")\n"
        self.appWebServerDelegate?.serverLog(log: didDisconnectLog)
        logDebugMessage(message: "CDCServer - WebSocket DisConnected: \(error?.localizedDescription ?? "no error details")")
    }
    
    func server(_ server: Server, webSocket: WebSocket, didReceiveMessage message: WebSocketMessage) {
        let didRecieveMsgLog = "App WebServer Recieved Msg: \(message)\n"
        self.appWebServerDelegate?.serverLog(log: didRecieveMsgLog)
        logDebugMessage(message: "CDCServer - WebSocket Did Receive Message: - Message: \(message)")
    }
    
    func server(_ server: Server, webSocket: WebSocket, didSendMessage message: WebSocketMessage) {
        let didSendMsgLog = "App WebServer sent Msg: \(message)\n"
        self.appWebServerDelegate?.serverLog(log: didSendMsgLog)
        logDebugMessage(message: "CDCServer - WebSocket Did Send Message: - Message: \(message)")
    }
}
