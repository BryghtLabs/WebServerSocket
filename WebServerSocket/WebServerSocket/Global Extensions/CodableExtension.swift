//
//  CodableExtension.swift
//  WebServerSocket
//
//  Created by Tolu Oridota on 1/29/24.
//

import Foundation

public typealias JSONDictionary = [String: Any]

public typealias JSONArrayOfDictionary = [[String: Any]]

public extension Decodable {
    
    init?(fromData data: Data?) {
        guard let data = data else { return nil }
        let object: Self
        do {
            object = try JSONDecoder().decode(Self.self, from: data)
        } catch DecodingError.typeMismatch(let type, let context) {
            logDebugError(message: "DecodingError.typeMismatch")
            logDebugError(message: "Type: \(type) ->\(context)")
            return nil
        } catch DecodingError.valueNotFound(let type, let context) {
            logDebugError(message: "DecodingError.valueNotFound")
            logDebugError(message: "Type: \(type) ->\(context)")
            return nil
        } catch DecodingError.keyNotFound(let codingKey, let context) {
            logDebugError(message: "DecodingError.keyNotFound")
            logDebugError(message: "\(codingKey) ->\(context)")
            return nil
        } catch DecodingError.dataCorrupted(let context) {
            logDebugError(message: "DecodingError.dataCorrupted")
            logDebugError(message: "\(context)")
            return nil
        } catch {
            logDebugError(message: "Unexpected decoding error")
            return nil
        }
        
        self = object
    }
    
    init?(fromJson json: String?) {
        guard let json = json else {
            logDebugError(message: "json provided was nil")
            return nil
        }
        self.init(fromData: Data(json.utf8))
    }
}

public extension Encodable {
    
    var data: Data? {
        guard let data = try? JSONEncoder().encode(self) else {
            logDebugError(message: "JSON Data Encode Failed")
            return nil
        }
        return data
    }
    
    var jsonString: String? {
        guard let data = try? JSONEncoder().encode(self) else {
            logDebugError(message: "JSON String Encode Failed")
            return nil
        }
        return String(data: data, encoding: .utf8)
    }
    
    var jsonDict: JSONDictionary? {
        guard let data = try? JSONEncoder().encode(self) else {
            logDebugError(message: "JSONDictionary Encode Failed")
            return nil
        }
        guard let dict = try? JSONSerialization.jsonObject(with: data) else {
            logDebugError(message: "JSONDictionary Serialization Failed")
            return nil
        }
        return dict as? JSONDictionary
    }
    
    var jsonArrayDict: JSONArrayOfDictionary? {
        guard let data = try? JSONEncoder().encode(self) else {
            logDebugError(message: "JSONArrayOfDictionary Encode Failed")
            return nil
        }
        guard let arrayOfDict = try? JSONSerialization.jsonObject(with: data) else {
            logDebugError(message: "JSONArrayOfDictionary Serialization Failed")
            return nil
        }
        return arrayOfDict as? JSONArrayOfDictionary
    }
}

@propertyWrapper
/// Used to Ignore/stop a field from being serialized
/// in a codable struct/class
public struct CodableIgnored<T>: Codable {
    public var wrappedValue: T?
    
    public init(wrappedValue: T?) {
        self.wrappedValue = wrappedValue
    }
    
    public init(from decoder: Decoder) throws {
        self.wrappedValue = nil
    }
    
    public func encode(to encoder: Encoder) throws {
        // Do nothing
        logDebugMessage(message: "Encoding Skipped for Field: \(String(describing: wrappedValue))")
    }
}

extension KeyedDecodingContainer {
    public func decode<T>(
        _ type: CodableIgnored<T>.Type,
        forKey key: Self.Key) throws -> CodableIgnored<T> {
            return CodableIgnored(wrappedValue: nil)
        }
}

extension KeyedEncodingContainer {
    public mutating func encode<T>(
        _ value: CodableIgnored<T>,
        forKey key: KeyedEncodingContainer<K>.Key) throws {
            // Do nothing
            //logDebugMessage(message: "KeyedEncodingContainer Skipped for Field: \(value)")
        }
}
