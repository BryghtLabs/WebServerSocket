//
//  WebViewManager.swift
//  WebServerSocket
//
//  Created by Tolu Oridota on 1/29/24.
//

import Foundation
import UIKit
import WebKit

public protocol WebViewManagerDelegate {
    func activityIndicator(_ show: Bool)
    func handleErrorResponse()
    func closeWebView()
    func webViewDidFinish(webview: WKWebView)
}

public protocol WebViewLoadCycleProtocol{
    func webViewDidFinish(webView: WKWebView?)
    func webViewDecidedForPolicy(navigationAction: WKNavigationAction?)
    func webViewDidStartNavigation(navigation: WKNavigation?)
}

class WebViewManager: BaseViewManagers, WKNavigationDelegate {
    
    let WEB_CANCEL_BUTTON_PRESSED_URL = "wrong://home?"
    let EXPIRED_SESSION_URL = "logout"
    let ChessDotComUrl = "chess.com"
    
    var viewController: WebViewController? {
        return viewControllerObject as? WebViewController
    }
    
    var presenter: WebViewPresenter? {
        return presenterObject as? WebViewPresenter
    }
    
    var currentNavigationType: WKNavigationType = .other
    
    private(set) var delegate: WebViewManagerDelegate?
    
    private(set) var loadCycleDelegate: WebViewLoadCycleProtocol?
    
    public func setDelegate(_ delegate: WebViewManagerDelegate?) {
        self.delegate = delegate
    }
    
    public func setLoadCycleDelegate(_ delegate: WebViewLoadCycleProtocol?) {
        self.loadCycleDelegate = delegate
    }
    
    public func webView(_: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        delegate?.activityIndicator(true)
        loadCycleDelegate?.webViewDidStartNavigation(navigation: navigation)
    }
    
    public func webView(_: WKWebView, didFailProvisionalNavigation _: WKNavigation!, withError error: Error) {
        delegate?.activityIndicator(false)
        delegate?.handleErrorResponse()
        logDebugError(message: error.localizedDescription)
    }
    
    public func webView(_ webView: WKWebView, didFinish _: WKNavigation!) {
        delegate?.webViewDidFinish(webview: webView)
        loadCycleDelegate?.webViewDidFinish(webView: webView)
        delegate?.activityIndicator(false)
    }
    
    public func webView(_ webView: WKWebView, shouldAllowDeprecatedTLSFor challenge: URLAuthenticationChallenge) async -> Bool {
        return true
    }
    
    public func webView(_: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if let trust = challenge.protectionSpace.serverTrust {
            let cred = URLCredential(trust: trust)
            completionHandler(.useCredential, cred)
        } else {
            completionHandler(.performDefaultHandling, nil)
        }
    }
    
    public func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        
    }
    
    public func webView(_ webView: WKWebView, didFail _: WKNavigation!, withError error: Error) {
        delegate?.activityIndicator(false)
        
        if webView.isLoading == false {
            delegate?.handleErrorResponse()
        }
        let userInfo = error._userInfo as! [String: AnyObject]
        guard let failingURL = userInfo["NSErrorFailingURLStringKey"] else {
            return
        }
        
        // this is a cancel button being pushed
        if failingURL as! String == WEB_CANCEL_BUTTON_PRESSED_URL {
            delegate?.closeWebView()
        }
    }
    
    public func webView(_: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let url = navigationAction.request.url?.absoluteString else { return decisionHandler(.cancel) }
        self.processChessDotComLogOut(url: url)
        self.currentNavigationType = (navigationAction.navigationType == .formSubmitted) ? .formSubmitted : .other
        self.loadCycleDelegate?.webViewDecidedForPolicy(navigationAction: navigationAction)
        
        //logDebugMessage(message: "WebView URL: \(url)")
        
        return decisionHandler(.allow)
    }
}

extension WebViewManager {
    
    private func processChessDotComLogOut(url: String) {
        guard viewController?.isUsingChessDotComSocket == false else { return }
        guard url.contains(EXPIRED_SESSION_URL) && url.contains(ChessDotComUrl) else { return }
    }
    
}
