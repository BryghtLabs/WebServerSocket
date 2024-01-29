//
//  DictionaryExtension.swift
//  WebServerSocket
//
//  Created by Tolu Oridota on 1/29/24.
//

import Foundation
import UIKit

extension Dictionary {
    
    
    func convertToData() -> Data? {
        do {
            let data = try JSONSerialization.data(withJSONObject: self)
            return data
        } catch (let error) {
            logDebugError(message: "JSONSerialization ERROR convertToData(): \(error)")
        }
        return nil
    }
    
    func convertToJSONString() -> String? {
        guard let data = self.convertToData() else { return nil }
        let jsonText = String(data: data, encoding: .utf8)
        return jsonText
    }
    
}
