//
//  KeyStorage.swift
//  ChatSDKModules
//
//  Created by ben3 on 05/01/2021.
//

import Foundation
import SAMKeychain

public class PublicKeyStorage {
    
    static let instance = PublicKeyStorage()
    public static func shared() -> PublicKeyStorage {
        return instance
    }

    public func addKey(userId: String, publicKey: PublicKey) {
        SAMKeychain.setPassword(publicKey.serialize(), forService: Keys.UserPublicKeysService, account: userId)
    }

    public func getKey(userId: String) throws -> PublicKey? {
        if let serialization = SAMKeychain.password(forService: Keys.UserPublicKeysService, account: userId) {
            return try PublicKey(serialization: serialization)
        }
        return nil
    }
    
    public func deleteKey(userId: String) {
        SAMKeychain.deletePassword(forService: Keys.UserPublicKeysService, account: userId)
    }
    
    public func deleteAllKeys() {
        if let accounts = SAMKeychain.accounts(forService: Keys.UserPublicKeysService) {
            for account in accounts {
                if let user = account["acct"] as? String {
                    SAMKeychain.deletePassword(forService: Keys.UserPublicKeysService, account: user)
                }
            }
        }
    }

}

extension Keys {
    public static let UserPublicKeysService = "co.chatsdk.user-public-keys"
}
