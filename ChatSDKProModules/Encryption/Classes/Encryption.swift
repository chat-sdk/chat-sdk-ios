//
//  E2E.swift
//  AFNetworking
//
//  Created by Ben on 10/18/18.
//

import Foundation

public class Encryption {
    
    public static func bundle () -> Bundle? {
        return Bundle(path: Bundle.main.bundlePath + "/Frameworks/ChatSDKModulesSwift.framework/ChatEncryption.bundle")
    }
    
    public static func t (text: String) -> String {
        let defaultValue = "Encrypted Message"
        if let bundle = Encryption.bundle() {
            return NSLocalizedString(text, tableName: "EncryptionLocalization", bundle: bundle, value: defaultValue, comment: "")
        }
        return defaultValue
    }
    
}
