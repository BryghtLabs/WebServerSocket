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
        
        //Check if its connecto the internet
        /*if DataConnectionResolver.sharedInstance.isConnectedToInternet == false {
         viewController?.displayConnectionError()
         return
         }*/
        
        //let urlObject = AnalyticsDataManager.sharedInstance.getAnalyticsURL(url: urlString)
        urlRequest = NSMutableURLRequest(url: urlString, cachePolicy: NSURLRequest.CachePolicy.useProtocolCachePolicy, timeoutInterval: 30)
        if let urlRequest = urlRequest {
            urlRequest.httpShouldHandleCookies = true
            /*OAuthInteractor().getAuthToken(completionBlock: { token in
             guard let token = token else {
             return
             }
             var commonParam: String = "webview=true;Splash=true;"
             if SessionRepository.sharedInstance.isLoggedIn {
             commonParam.append("access_token=\(token);puid=\(AccountsInteractor().getCurrentAccountId())")
             }
             urlRequest.addValue(commonParam, forHTTPHeaderField: "Cookie")
             })*/
            viewController?.webView?.load(urlRequest as URLRequest)
            self.reportAnalytics()
        }
    }
    
    
    func getWebViewConfiguration(url: URL) -> WKWebViewConfiguration {
        let websiteDataTypes = NSSet(array: [WKWebsiteDataTypeDiskCache, WKWebsiteDataTypeMemoryCache, WKWebsiteDataTypeCookies, WKWebsiteDataTypeLocalStorage, WKWebsiteDataTypeSessionStorage])
        let date = NSDate(timeIntervalSince1970: 0)
        
        WKWebsiteDataStore.default().removeData(ofTypes: websiteDataTypes as! Set<String>, modifiedSince: date as Date, completionHandler: {})
        
        let webViewConfiguration: WKWebViewConfiguration = WKWebViewConfiguration()
        let dictionary: [String: String] = ["webview": "true", "os": "ios", "Splash": "true"]
        let userContentController: WKUserContentController = WKUserContentController()
        let cookieScript: WKUserScript = WKUserScript(source: CookieUtils.getJSCookiesString(url: url, cookies: dictionary), injectionTime: WKUserScriptInjectionTime.atDocumentStart, forMainFrameOnly: false)
        userContentController.addUserScript(cookieScript)
        webViewConfiguration.userContentController = userContentController
        
        return webViewConfiguration
    }
    
    
    
    
    func reportAnalytics() {
    }
}
