//
//  DotComWebViewPresenter.swift
//  ChessUp
//
//  Created by Tolu Oridota on 3/5/22.
//  Copyright © 2022 Bryght Labs. All rights reserved.
//

import Foundation
import WebKit
import CoreBluetooth

class DotComWebViewPresenter: WebViewPresenter {
    
    
    override var viewController: DotComWebViewController? {
        get { return viewControllerObject as? DotComWebViewController }
    }
    
    
    override func presentScene() {
        guard let vc = viewController else { return }
        subscribeToDelegates()
        subscribeToNotifications()
        setWebConfiguration(vc: vc)
        vc.createWebView(isForSocket: vc.isUsingChessDotComSocket)
        vc.initialize()
        loadWebView()
    }
    
    override func loadWebView() {
        super.loadWebView()
        logDebugMessage(message: "")
    }
    
    func subscribeToDelegates() {
        AppWebSocket.shared.setDelegate(delegate: self)
    }
    
    func subscribeToNotifications() {
        
    }
    
    func setWebConfiguration(vc: DotComWebViewController) {
        if vc.isUsingChessDotComSocket {
            self.setSocketWebConfiguration()
        } else {

        }
    }

    
    func setSocketWebConfiguration() {
        guard let script = self.viewController?.script else { return }
        
        // Setup variables
        let config = WKWebViewConfiguration()
        let userContentController = WKUserContentController()
        
        // Add script message handlers that, when run, will make the function
        // window.webkit.messageHandlers.test.postMessage() available in all frames.
        for handler in DotComSocketHandlers.allCases {
            userContentController.add(self, name: handler.title)
            logDebugMessage(message: "Added \(handler.title) to userContentController")
        }
        
        config.userContentController = userContentController
        
        // Inject JavaScript into the webpage. You can specify when your script will be injected and for
        // which frames–all frames or the main frame only.
        let scriptSource = script
        let userScript = WKUserScript(source: scriptSource, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        userContentController.addUserScript(userScript)
        
        self.viewController?.webConfig = config
        
    }
    
    
    func setSocketCofig() {
        let config = WKWebViewConfiguration()
        let userContentController = WKUserContentController()
        //userContentController.
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

extension DotComWebViewPresenter {
    
    @objc func chessDotComGameStarted(notification: NSNotification) {
        logDebugMessage(message: "")
    }
    
}

extension DotComWebViewPresenter: WKScriptMessageHandler {
    // Capture postMessage() calls inside loaded JavaScript from the webpage. Note that a Boolean
    // will be parsed as a 0 for false and 1 for true in the message's body. See WebKit documentation:
    // https://developer.apple.com/documentation/webkit/wkscriptmessage/1417901-body.
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard let vc = viewController else { return }
        if vc.isUsingChessDotComSocket {
            DotComManager.shared.parseSocMessage(dotComVC: viewController, msg: message)
        } else {
            //DotComManager.shared.parseMessage(chessDotComVC: viewController, msg: message)
        }
    }
}


extension DotComWebViewPresenter: WebViewLoadCycleProtocol {
    
    func webViewDidFinish(webView: WKWebView?) {
        guard isLogInPage(webView: webView) else { return }
        
    }
    
    func webViewDecidedForPolicy(navigationAction: WKNavigationAction?) {}
    
    func webViewDidStartNavigation(navigation: WKNavigation?) {
        guard viewController?.isUsingChessDotComSocket == false else { return }
        guard let webView = viewController?.webView else { return }
        guard isLogInPage(webView: webView) else { return }
        guard viewController?.viewManager?.currentNavigationType == .formSubmitted else { return }
    }
    
    func isLogInPage(webView: WKWebView?) -> Bool {
        guard viewController?.isUsingChessDotComSocket == false else { return false }
        guard let webView = webView else { return false }
        guard let absoluteURL = webView.url?.absoluteString else { return false }
        return ((absoluteURL.contains("login")) || (absoluteURL.contains("login_and_go")))
    }
}

