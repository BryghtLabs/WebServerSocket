//
//  WebViewPresenter.swift
//  WebServerSocket
//
//  Created by Tolu Oridota on 1/29/24.
//

import Foundation
import UIKit
import WebKit

class WebViewPresenter: BasePresenter {
    
    private(set) var urlRequest: NSMutableURLRequest?
    
    var viewController: WebViewController? { return viewControllerObject as? WebViewController }
    
    func loadWebView() {
        guard let url = viewController?.url, let urlString = URL(string: url) else {
            return
        }
        urlRequest = NSMutableURLRequest(url: urlString, cachePolicy: NSURLRequest.CachePolicy.useProtocolCachePolicy, timeoutInterval: 30)
        if let urlRequest = urlRequest {
            urlRequest.httpShouldHandleCookies = true
            viewController?.webView?.load(urlRequest as URLRequest)
        }
    }

}
