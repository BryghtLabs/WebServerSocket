//
//  Utils.swift
//  WebServerSocket
//
//  Created by Tolu Oridota on 1/29/24.
//

import Foundation
import UIKit

var globalMainQueue: DispatchQueue {
    return DispatchQueue.main
}

var globalUserInitiatedQueue: DispatchQueue {
    return DispatchQueue.global(qos: .userInitiated)
}

var globalUserInteractiveQueue: DispatchQueue {
    return DispatchQueue.global(qos: .userInteractive)
}

var globalBackgroundQueue: DispatchQueue {
    return DispatchQueue.global(qos: .background)
}

var globalUtilityQueue: DispatchQueue {
    return DispatchQueue.global(qos: .utility)
}

class Utils {
    
    /// Get TimeStamp
    /// - Returns: String
    class func getTimeStamp() -> String {
        return String(format: "%f", Date().timeIntervalSince1970)
    }
    
    /// Returns timeStamp in "yyyy-MM-dd'T'HH:mm:ssZ" format
    /// - Returns: String
    class func debugLogTimeStamp() -> String {
        if let timeStampDouble = Double(Utils.getTimeStamp()) {
            let date = NSDate(timeIntervalSince1970: timeStampDouble)
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.timeZone = TimeZone.current
            //dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSS"
            return dateFormatterGet.string(from: date as Date)
        }
        return ""
    }
    
    //Implement Delay before execution
    class func delayExecution(_ delayInSeconds:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(delayInSeconds * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
    
    class func getChessDotComSocketJavascript() -> String? {
        guard let scriptPath = Bundle.main.path(forResource: "socketScript", ofType: AppConstants.extJS, inDirectory: "") else { return nil }
        
        guard let javaScriptString = try? String(contentsOfFile: scriptPath) else { return nil }
        return javaScriptString
    }
    
}


/// Logs Messages to Console
/// - Parameters:
///   - message: Message to log
///   - error: Error
///   - file: Name of file message is coming from
///   - function: Name of function message is coming from
///   - line: Line number message is coming from
public func logDebugMessage(message: String, error: NSError? = nil, file: String = "", function: String = "", line: String = "") {
    guard message.isEmpty == false else { return }
    var log = ""
    let logImagePrefix = (error == nil) ? "✅" : "⛔"
    let logPrefix = "\(logImagePrefix)\(AppConstants.LogPrefix)[\(Utils.debugLogTimeStamp())]: "
    let messageString = message.replacingOccurrences(of: "%", with: "%%")
    
    if let validError = error {
        let validErrorString = NSError(domain: validError.domain, code: validError.code, userInfo: validError.userInfo)
        log = String(format: "Message: %@\n Error: %@", messageString, validErrorString)
    } else {
        log = messageString
    }
    
    //    Only append location string when there's information to be displayed
    if file != "" || function != "" || line != "" {
        let locationString = String(format: "%@", file + " " + function + " " + line)
        log += "Location: " + locationString + "\n "
    }
    
    
    DispatchQueue.main.async {
        let strs = splitByLength(str: log, length: 1000)
        for str in strs {
            print("\(logPrefix)\(str)")
        }
    }
}

/// Logs Error Message to Console
/// - Parameters:
///   - message: Error Message to Log
///   - error: Error Object
///   - file: Name of file error message is coming from
///   - function: Name of function error message is coming from
///   - line: Line number error message is coming from
public func logDebugError(message: String, error: NSError? = nil, file: String = "", function: String = "", line: String = "") {
    var log = ""
    let logPrefix = "⛔\(AppConstants.LogErrorPrefix)[\(Utils.debugLogTimeStamp())]: "
    let messageString = message.replacingOccurrences(of: "%", with: "%%")
    
    if let validError = error {
        let validErrorString = NSError(domain: validError.domain, code: validError.code, userInfo: validError.userInfo)
        log = String(format: "Message: %@\n Error: %@", messageString, validErrorString)
    } else {
        log = message
    }
    
    //    Only append location string when there's information to be displayed
    if file != "" || function != "" || line != "" {
        let locationString = String(format: "%@", file + " " + function + " " + line)
        log += "Location: " + locationString + "\n "
    }
    
    
    DispatchQueue.main.async {
        let strs = splitByLength(str: log, length: 1000)
        for str in strs {
            print("\(logPrefix)\(str)")
        }
    }
}

func splitByLength(str: String, length: Int) -> [String] {
    var result = [String]()
    var collectedCharacters = [Character]()
    collectedCharacters.reserveCapacity(length)
    var count = 0
    
    for character in str {
        collectedCharacters.append(character)
        count += 1
        if (count == length) {
            // Reached the desired length
            count = 0
            result.append(String(collectedCharacters))
            collectedCharacters.removeAll(keepingCapacity: true)
        }
    }
    
    // Append the remainder
    if !collectedCharacters.isEmpty {
        result.append(String(collectedCharacters))
    }
    
    return result
}
