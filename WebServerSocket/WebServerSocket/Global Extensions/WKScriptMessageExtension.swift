//
//  WKScriptMessageExtension.swift
//  WebServerSocket
//
//  Created by Tolu Oridota on 1/29/24.
//

import Foundation
import UIKit
import WebKit

extension WKScriptMessage {
    
    /// Returns Msg from DotCom Javascript as Data?
    var msgData: Data? {
        guard let msgNSDict = body as? NSDictionary else { return nil }
        guard let msgDict = msgNSDict as? Dictionary<String, Any> else { return nil }
        guard let dictData = msgDict.convertToData() else { return nil }
        return dictData
    }
    
    
}
