//
//  Key.swift
//  ChatSDKModules
//
//  Created by ben3 on 05/01/2021.
//

import Foundation
//import VirgilCryptoApiImpl
//import VirgilCryptoAPI
//import VirgilSDK
import VirgilCrypto

public class KeyPair {
    
    public let keyPair: VirgilKeyPair
//    lazy var crypto: VirgilCrypto = {
//        return try! VirgilCrypto()
//    }()
    
    var crypto = try! VirgilCrypto()
    
    enum KeyError: Error {
        case runtimeError(String)
    }
    
    public init(with: VirgilKeyPair) {
        self.keyPair = with;
    }

    public init(privateKey: Data, publicKey: Data) throws {
//        let crypto = try! VirgilCrypto()
        let virgilPrivate = try crypto.importPrivateKey(from: privateKey)
        let virgilPublic = try crypto.importPublicKey(from: publicKey)
        self.keyPair = VirgilKeyPair(privateKey: virgilPrivate.privateKey, publicKey: virgilPublic)
    }

    public convenience init(privateKeyString: String, publicKeyString: String) throws {
        if let privateKeyData = Data(base64Encoded: privateKeyString), let publicKeyData = Data(base64Encoded: publicKeyString) {
            try self.init(privateKey: privateKeyData, publicKey: publicKeyData)
        } else {
            throw KeyError.runtimeError("Invalid Key Data")
        }
    }

    public func publicKeyData() throws -> Data {
        return try crypto.exportPublicKey(keyPair.publicKey)
    }

    public func privateKeyData() throws -> Data {
        return try crypto.exportPrivateKey(keyPair.privateKey)
    }
    
    public func publicKeyString() throws -> String {
        return try publicKeyData().base64EncodedString()
    }

    public func privateKeyString() throws -> String {
        return try privateKeyData().base64EncodedString()
    }

    public func privateKeyId() -> String {
        return keyPair.publicKey.identifier.base64EncodedString()
    }
    
}
