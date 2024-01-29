//
//  WebViewController.swift
//  WebServerSocket
//
//  Created by Tolu Oridota on 1/29/24.
//

import Foundation
import UIKit
import WebKit

class WebViewController: BaseViewController {
    
    var webView: WKWebView?
    
    var errorView: UIView?
    
    var url: String?
    
    var pageTitle: String?
    
    var script: String?
    
    var evaluateScript: String?
    
    var canEvaluateScripts: Bool = false
    
    var webConfig: WKWebViewConfiguration?
    
    var isUsingChessDotComSocket: Bool = false
    
    var presenter: WebViewPresenter? {
        return presenterObject as? WebViewPresenter
    }
    
    var viewManager: WebViewManager? {
        return viewManagerObject as? WebViewManager
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //initializeURL()
        //createWebView()
        //createErrorView()
        //initialize()
        //presenter?.loadWebView()
        viewManager?.setDelegate(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //appShare.urlLink = nil
        //appShare.urlPageTitle = nil
    }
    
    func initializeURL() {
//        if let thelink = appShare.urlLink {
//            self.url = thelink
//        }
    }
    
    func initializePageTitle() {
//        if let pageTitle = appShare.urlPageTitle {
//            self.pageTitle = pageTitle
//        }
    }
    
    func createWebView(isForSocket: Bool = true) {
        createSocketWebView()
    }
    
    func createSocketWebView() {
        guard let config = webConfig else { return }
        let customFrame = CGRect(origin: CGPoint.zero, size: CGSize(width: 0.0, height:view.frame.size.height))
        webView = WKWebView(frame: customFrame, configuration: config)
        //webView = WKWebView(frame: customFrame)
        webView?.translatesAutoresizingMaskIntoConstraints = false
        webView?.customUserAgent = AppConstants.CustomUserAgent
        if let webView = webView {
            view.addSubview(webView)
            webView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            webView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
            webView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            webView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
            webView.navigationDelegate = viewManager
            webView.uiDelegate = self
            webView.allowsLinkPreview = false
            webView.allowsBackForwardNavigationGestures = true
        }
    }
    
    func createErrorView() {
        /*errorView = ConnectionFailedAlertView(message: "", btnAction: { self.presenter?.loadWebView() })
        if let errorView = errorView {
            view.addSubview(errorView)
        }*/
    }
    
    /*override func navigationTitle() -> String? {
        initializePageTitle()
        guard let pageTitle = pageTitle else {
            return super.navigationTitle()
        }
        return pageTitle
    }*/
    
    func initialize() {
        webView?.isHidden = true
        errorView?.isHidden = true
    }
    
    func hideWebViewBackButton() {
        navigationItem.leftBarButtonItem = nil
    }
    
    @objc func backButtonClicked() {
        guard let webView = webView else {
            _ = navigationController?.popViewController(animated: true)
            return
        }
        if webView.canGoBack {
            webView.goBack()
        } else {
            _ = navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func backward() {
        guard let webView = webView else { return }
        webView.stopLoading()
        if webView.canGoBack {
            webView.goBack()
        }
    }
    
    @objc func forward() {
        guard let webView = webView else { return }
        if webView.canGoForward {
            webView.goForward()
        }
    }
    
    @objc func reload() {
        guard let webView = webView else { return }
        /*guard ChessSession.shared.chessGameConfig.isChessGameInPlay == false,
              ChessSession.shared.chessGameConfig.chessPlayMode == .PlayChessDotCom else {
            useReloadToRequestCurrentGameState()
            return
        }*/
        webView.reload()
    }
    
    func useReloadToRestartChessDotComLiveGameMonitor() {
        //ChessDotComManager.shared.restartLiveGameMonitor()
    }
    
    func useReloadToRequestCurrentGameState() {
        guard isUsingChessDotComSocket == false else { return }
        //ChessDotComManager.shared.requestCurrentGameState()
    }
    
    func displayConnectionError() {
        //self.stopStatusIndicator(parentVC: self, transitionType: .Normal)
        webView?.isHidden = true
        errorView?.isHidden = false
    }
    
    func handleWebViewDidFinish(webView: WKWebView) {
        guard isUsingChessDotComSocket == false else { return }
        guard self.canEvaluateScripts else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            if let script = self.evaluateScript {
                self.webView?.evaluateJavaScript(script, completionHandler: { (_, _) in })
            }
        }
    }
}

extension WebViewController: WebViewManagerDelegate {
    
    func activityIndicator(_ show: Bool) {
        guard let webView = webView else {
            return
        }
        if show && webView.isHidden {
            //self.startStatusIndicator(parentVC: self, transitionType: .Normal)
            webView.isHidden = true
            errorView?.isHidden = true
        } else {
            //self.stopStatusIndicator(parentVC: self, transitionType: .Normal)
            webView.isHidden = false
            errorView?.isHidden = true
        }
    }
    
    func handleErrorResponse() {
        displayConnectionError()
    }
    
    func closeWebView() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    func webViewDidFinish(webview: WKWebView) {
        self.handleWebViewDidFinish(webView: webview)
    }
}

