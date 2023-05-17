//
//  PublicKey.swift
//  ChatSDKModules
//
//  Created by ben3 on 05/01/2021.
//

import Foundation

//import VirgilCryptoApiImpl
//import VirgilCryptoAPI
//import VirgilSDK

import VirgilCrypto

public class PublicKey {
    
    enum KeyError: Error {
        case runtimeError(String)
    }
    
    lazy var crypto: VirgilCrypto = {
        return try! VirgilCrypto()
    }()
    
    public let key: String
    public var identifier: String?
    
    public init(identifier: String?, key: String) {
        self.key = key
        self.identifier = identifier
    }
    public init(serialization: String) {
        let split = serialization.components(separatedBy: " ")
        if split.count == 2 {
            identifier = split[0]
            key = split[1]
        } else {
            key = serialization
        }
    }

    public func serialize() -> String {
        if let id = self.identifier {
            return id + " " + key
        }
        return key
    }
    
    public func virgilPublicKey() throws -> VirgilPublicKey? {
        if let publicKeyData = Data(base64Encoded: key) {
            return try crypto.importPublicKey(from: publicKeyData)
        }
        return nil
    }

    public static func virgilPublicKey(from: String) throws -> VirgilPublicKey? {
        if let publicKeyData = Data(base64Encoded: from) {
            let crypto = try! VirgilCrypto()
            return try crypto.importPublicKey(from: publicKeyData)
        }
        return nil
    }
}
