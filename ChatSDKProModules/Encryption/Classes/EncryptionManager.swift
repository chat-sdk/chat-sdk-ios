//
//  EncryptionManager.swift
//  ChatSDKModules
//
//  Created by ben3 on 05/01/2021.
//

import Foundation
//import VirgilCryptoApiImpl
//import VirgilCryptoAPI
//import VirgilSDK
import VirgilCrypto
import SAMKeychain
import ChatSDK
import RXPromise

public class EncryptionManager {

    enum ChatError: Error {
        case runtimeError(String)
    }

    // Singleton
    static let instance = EncryptionManager()
    public static func shared() -> EncryptionManager { return instance }

    // Properties

    let crypto = try! VirgilCrypto()
    
    public func keyPairForUser(userId: String?) throws -> KeyPair {
        
        // Try to load the keypair
        if userId == nil {
            throw ChatError.runtimeError("UserID cannot be nil")
        }

        // Try to load the keypair
        if let key = try load(userId: userId!) {
            return key
        } else {
            // We need to create the keys
            let keyPair = try crypto.generateKeyPair()
            
            let key = KeyPair(with: keyPair)
            
            save(userId: userId!, key: key)
            
            return key
        }
    }
    
    public func save(userId: String, key: KeyPair) {
        do {
            SAMKeychain.setPasswordData(try key.publicKeyData(), forService: Keys.PublicKeyService, account: userId)
            SAMKeychain.setPasswordData(try key.privateKeyData(), forService: Keys.PrivateKeyService, account: userId)
        } catch {
            
        }
    }

    public func load(userId: String) throws -> KeyPair? {
        if let publicKeyData = SAMKeychain.passwordData(forService: Keys.PublicKeyService, account: userId),
           let privateKeyData = SAMKeychain.passwordData(forService: Keys.PrivateKeyService, account: userId) {
            return try KeyPair(privateKey: privateKeyData, publicKey: publicKeyData)
        }
        return nil
    }
    
    public func deletePrivateKey() {
        SAMKeychain.deletePassword(forService: Keys.PublicKeyService, account: BChatSDK.currentUserID())
        SAMKeychain.deletePassword(forService: Keys.PrivateKeyService, account: BChatSDK.currentUserID())
        // Generate a new one
        do {
            let pair = try keyPairForUser(userId: BChatSDK.currentUserID())
            print(try pair.privateKeyString())
            BChatSDK.encryption()?.publishKey()
        } catch {
        
        }
    }
    
}

public extension Keys {
    static let PublicKeys = "public-keys"
    static let PublicKeyService = "co.chatsdk.public-key"
    static let PrivateKeyService = "co.chatsdk.private-key"
}
