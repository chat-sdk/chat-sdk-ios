//
//  EncryptionHandler.swift
//  AFNetworking
//
//  Created by Ben on 10/17/18.
//

import Foundation
import ChatSDK
//import VirgilCryptoApiImpl
//import VirgilCryptoAPI
//import VirgilSDK
import VirgilCrypto
import SAMKeychain

open class EncryptionHandler : NSObject, PEncryptionHandler {
    
    public static let PublicKeysKey = "public-keys"

    public static let PublicKeyKeychainKey = "co.chatsdk.public-key"
    public static let PrivateKeyKeychainKey = "co.chatsdk.private-key"
    
    public var supportLegacyKeys = true

    enum EncryptionError: Error {
        case runtimeError(String)
    }
    
    static var crypto: VirgilCrypto {
        return try! VirgilCrypto()
    }

    public override init() {
        super.init()
    }
    
    open func publishKey() -> RXPromise {
        // Add to meat
        if let user = BChatSDK.currentUser(), let publicKey = publicKey() {
            user.setMetaValue(publicKey, forKey: bPublicKey)
            if let promise = BChatSDK.core().pushUser().thenOnMain({ (success: Any?) -> Any? in
                BChatSDK.core().goOnline()
                return success
            }, nil) {
                return promise
            }
        }
        return RXPromise.resolve(withResult: nil)
    }
    
    public func publicKey() -> String? {
        do {
            return try EncryptionManager.shared().keyPairForUser(userId: BChatSDK.currentUserID()).publicKeyString()
        } catch {
            return nil
        }
    }

    public func privateKeyId() -> String? {
        do {
            if let currentUserID = BChatSDK.currentUserID() {
                return try EncryptionManager.shared().keyPairForUser(userId: currentUserID).privateKeyId()
            }
        } catch {
        }
        return nil
    }
    
    open func addPublicKey(_ userId: String, identifier: String?, key: String) {
        PublicKeyStorage.shared().addKey(userId: userId, publicKey: PublicKey(identifier: identifier, key: key))
    }

    public func encryptMeta(_ thread: PThread, meta: [String: Any]) -> [String: Any]? {
        var keys = [VirgilPublicKey]()
        var failedUsers = [PUser]()

        if !thread.typeIs(bThreadFilterPublic) && (BChatSDK.config().encryptGroupThreads || thread.typeIs(bThreadType1to1)) {
            
            // Get a list of the users associated with the message
            var users = [PUser]()
            
            for user in thread.users() {
                if let user = user as? PUser {
                    users.append(user)
                }
            }
            
            // Now build a list of keys
            for user in users {
                do {
                    if user.isMe() {
                        if let myKey = publicKey(), let myVirgilKey = try PublicKey.virgilPublicKey(from: myKey) {
                            keys.append(myVirgilKey)
                        } else {
                            failedUsers.append(user)
                        }
                    }
                    else if let key = try PublicKeyStorage.shared().getKey(userId: user.entityID()), let virgilPublicKey = try key.virgilPublicKey() {
                        keys.append(virgilPublicKey)
                    }
                    //
                    // Support for legacy keys
                    //
                    else if (supportLegacyKeys) {
                        // We can try to get the key from the user meta
                        var keyAdded = false
                        if let publicKey = user.meta()[bPublicKey] as? String, let vk = try PublicKey.virgilPublicKey(from: publicKey) {
                            keys.append(vk)
                            keyAdded = true
                        }
                    }
                    //
                    // End Support for legacy keys
                    //
                    else {
                        failedUsers.append(user)
                    }
                } catch {
                    failedUsers.append(user)
                }
            }
        }
        
        // Now check if we have any failed users....
        // If have any, we abort encryption
        if failedUsers.count > 0 {
            for user in failedUsers {
                if let keys = requestPublicKeys(userEntityID: user.entityID()) {
//                        for key in keys {
//                            if let virgilKey = try PublicKey.virgilPublicKey(from: key) {
//                                keys.append(virgilKey)
//                            }
//                        }
                }
            }
        } else {
            if keys.count > 0 {
                do {
                    // Convert the message payload to data
                    let metaData = try JSONSerialization.data(withJSONObject: meta, options: .prettyPrinted)

                    let encryptedMetaData = try EncryptionHandler.crypto.encrypt(metaData, for: keys)
                    
                    let newMessageMeta = [bMessageText: Encryption.t(text: Keys.EncryptedMessage),
                                          bMessageEncryptedPayloadKey: encryptedMetaData.base64EncodedString()]
                    
                    return newMessageMeta
                } catch {
                    
                }
            }
        }
        return nil
    }
    
    public func encryptMessage(_ message: PMessage) -> [String: Any]? {
        
        // Get the message payload
        if let meta = message.meta() as? [String: Any], let thread = message.thread() {
            return encryptMeta(thread, meta: meta)
        }
        return nil
    }
    
    public func decryptMessage(_ message: String!) -> [String: Any]? {
        if !message.isEmpty && BChatSDK.auth().isAuthenticatedThisSession() {
            do {
                // Get the encrypted message
                if let encryptedMessageData = Data(base64Encoded: message) {
                    let privateKey = try EncryptionManager.shared().keyPairForUser(userId: BChatSDK.currentUserID()).keyPair.privateKey
                    let decryptedMessageData = try EncryptionHandler.crypto.decrypt(encryptedMessageData, with: privateKey)
                    if let messageMeta = try JSONSerialization.jsonObject(with: decryptedMessageData, options: .allowFragments) as? [String: Any] {
                        return messageMeta;
                    }
                }
            } catch {
                
            }
        }
        return nil
    }
    
    open func requestPublicKeys(userEntityID: String) -> [String]? {
        return nil
    }
            
    public func importPublicKey(base64Encoded: String) throws -> VirgilPublicKey? {
        // Convert the key into data
        if let keyData = Data(base64Encoded: base64Encoded) {
            return try EncryptionHandler.crypto.importPublicKey(from: keyData)
        }
        return nil
   }
    
    public static func exportKeyPair() throws -> String {
        let key = try EncryptionManager.shared().keyPairForUser(userId: BChatSDK.currentUserID())
        let privateKey = try key.privateKeyString()
        let publicKey = try key.publicKeyString()
        return privateKey + " " + publicKey
    }
    
    public static func importKeyPair(keyPairString: String) throws -> Void {
        let keysArray = keyPairString.components(separatedBy: " ")
        if keysArray.count == 2 {
            
            let privateKeyString = keysArray[0]
            let publicKeyString = keysArray[1]
            
            let key = try KeyPair(privateKeyString: privateKeyString, publicKeyString: publicKeyString)
            EncryptionManager.shared().save(userId: BChatSDK.currentUserID(), key: key)

            BChatSDK.encryption()?.publishKey()

        } else {
            throw EncryptionError.runtimeError(Bundle.t(bImportFailed))
        }
    }
}
