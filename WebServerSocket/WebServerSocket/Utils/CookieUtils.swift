//
//  CookieUtils.swift
//  WebServerSocket
//
//  Created by Tolu Oridota on 1/29/24.
//

import Foundation

class CookieUtils {
    
    public static func getJSCookiesString(url: URL, cookies: [String: String]) -> String {
        guard let hostName = url.host else { return "" }
        let domain = getPrimaryDomain(hostName)
        var result = ""
        for cookie in cookies.keys {
            let value = cookies[cookie] ?? ""
            result += "document.cookie='\(cookie)=\(value); domain=\(domain); Path=/;secure;Expires=\(Date(timeIntervalSinceNow: 86400));'; "
        }
        return result
    }
    
    static func setCookie(_ url: URL, key: String, value: AnyObject) {
        guard let hostName = url.host else { return }
        let domain = getPrimaryDomain(hostName)
        
        let cookieProps = [
            HTTPCookiePropertyKey.domain: domain,
            HTTPCookiePropertyKey.path: "/",
            HTTPCookiePropertyKey.name: key,
            HTTPCookiePropertyKey.value: value,
            HTTPCookiePropertyKey.secure: "TRUE",
            HTTPCookiePropertyKey.expires: Date(timeIntervalSinceNow: 86400) // Expires in 24 hours
        ] as [HTTPCookiePropertyKey: Any]
        
        let cookie = HTTPCookie(properties: cookieProps)
        
        HTTPCookieStorage.shared.setCookie(cookie!)
    }
    
    private static func getPrimaryDomain(_ host: String) -> String {
        if let domainSuffixRange = host.range(of: ".", options: NSString.CompareOptions.backwards) {
            let nextFindRange = host.startIndex ..< domainSuffixRange.lowerBound
            
            if let domainRange = host.range(of: ".", options: NSString.CompareOptions.backwards, range: nextFindRange) {
                return String(host[domainRange.lowerBound ..< host.endIndex])
            }
        }
        
        return host
    }
}
