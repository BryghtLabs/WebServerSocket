//
//  DotComWebViewController.swift
//  ChessUp
//
//  Created by Tolu Oridota on 3/5/22.
//  Copyright © 2022 Bryght Labs. All rights reserved.
//

import Foundation
import WebKit

class DotComWebViewController: WebViewController {
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override var presenter: DotComWebViewPresenter? {
        return presenterObject as? DotComWebViewPresenter
    }
    
    override var viewManager: DotComWebViewManager? {
        return viewManagerObject as? DotComWebViewManager
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prepare()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
    }
    
    private func prepare() {
        setUpDelegates()
        presenter?.presentScene()
    }
    
    private func setUpDelegates() {
        self.viewManager?.setLoadCycleDelegate(presenter)
    }
    
    static func make() -> DotComWebViewController? {
        return UIStoryboard(name: "DotComWebView", bundle: nil).instantiateViewController(withIdentifier: "DotComWebView") as? DotComWebViewController
    }
    
    @discardableResult
    static func push(parentVC: BaseViewController?, url: String? = nil, script: String?) -> DotComWebViewController? {
        guard let url = url else { return nil }
        guard let script = script else { return nil }
        guard let parentVC = parentVC else { return nil }
        guard let webViewController = DotComWebViewController.make() else { return nil }
        webViewController.url = url
        webViewController.pageTitle = ""
        webViewController.script = script
        webViewController.isUsingChessDotComSocket = false
        parentVC.navigationController?.pushViewController(webViewController, animated: true, completion: {})
        return webViewController
    }
    
    @discardableResult
    static func pushForSocket(parentVC: BaseViewController?, script: String?) -> DotComWebViewController? {
        AppWebSocket.shared.start()
        let url = DotComUrl.chessDotComConnectUrl
        //let url = "https://rsaxvc.net/tolu/scriptRunner.html"
        guard let parentVC = parentVC else { return nil }
        guard let webViewController = DotComWebViewController.make() else { return nil }
        webViewController.url = url
        webViewController.pageTitle = ""
        webViewController.script = script
        webViewController.isUsingChessDotComSocket = true
        parentVC.navigationController?.pushViewController(webViewController, animated: true, completion: {})
        return webViewController
    }
    
    func removeAllChessDotComMessageHandlers() {}
    
    deinit {
        logDebugMessage(message: "DeIniting ChessDotComWebViewController")
    }
}
