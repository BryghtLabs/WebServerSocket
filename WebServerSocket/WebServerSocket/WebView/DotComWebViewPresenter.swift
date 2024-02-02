//
//  DotComWebViewPresenter.swift
//  WebServerSocket
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
        vc.createWebView(isForSocket: vc.isUsingDotComSocket)
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
        if vc.isUsingDotComSocket {
            self.setSocketWebConfiguration()
        } else {

        }
    }

    
    func setSocketWebConfiguration() {
        //guard let script = self.viewController?.script else { return }
        
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
        config.defaultWebpagePreferences.allowsContentJavaScript = true
        
        if let script = self.viewController?.script {
            // Inject JavaScript into the webpage. You can specify when your script will be injected and for
            // which frames–all frames or the main frame only.
            let scriptSource = script
            let userScript = WKUserScript(source: scriptSource, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
            userContentController.addUserScript(userScript)
        }
        
        self.viewController?.webConfig = config
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

extension DotComWebViewPresenter: WKScriptMessageHandler {
    // Capture postMessage() calls inside loaded JavaScript from the webpage. Note that a Boolean
    // will be parsed as a 0 for false and 1 for true in the message's body. See WebKit documentation:
    // https://developer.apple.com/documentation/webkit/wkscriptmessage/1417901-body.
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard let vc = viewController else { return }
        if vc.isUsingDotComSocket {
            DotComManager.shared.parseSocMessage(dotComVC: viewController, msg: message)
        } else {
            
        }
    }
}


extension DotComWebViewPresenter: WebViewLoadCycleProtocol {
    
    func webViewDidFinish(webView: WKWebView?) {
        viewController?.revealLogger()
    }
    
    func webViewDecidedForPolicy(navigationAction: WKNavigationAction?) {}
    
    func webViewDidStartNavigation(navigation: WKNavigation?) {
        guard viewController?.isUsingDotComSocket == false else { return }
        guard let webView = viewController?.webView else { return }
        guard isLogInPage(webView: webView) else { return }
        guard viewController?.viewManager?.currentNavigationType == .formSubmitted else { return }
    }
    
    func isLogInPage(webView: WKWebView?) -> Bool {
        guard viewController?.isUsingDotComSocket == false else { return false }
        guard let webView = webView else { return false }
        guard let absoluteURL = webView.url?.absoluteString else { return false }
        return ((absoluteURL.contains("login")) || (absoluteURL.contains("login_and_go")))
    }
}

