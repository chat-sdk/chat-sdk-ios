//
//  Settings.swift
//  ChatSDK
//
//  Created by ben3 on 13/11/2020.
//

import Foundation
import SAMKeychain

@objc public class Settings: NSObject {
    
    public override init() {
        super.init()
        BChatSDK.hook().add(BHook.init(_: { [weak self] dict in
            if let id = dict?[bHook_StringId] as? String, let value = dict?[bHook_ObjectValue] {
                if let boolValue = value as? Bool {
                    self?.setValue(bool: boolValue, key: id)
                }
                if let stringValue = value as? String {
                    self?.setValue(string: stringValue, key: id)
                }
            }
        }, weight: -1000), withName: bHookSettingsUpdated)
    }
        
    public func setValue(bool: Bool, key: String) {
        setValue(string: bool ? "true" : "false", key: key)
    }

    public func getBoolValue(key: String) -> Bool? {
        if let value = getValue(key: key) {
            return value == "true"
        }
        return nil
    }

    public func setValue(double: Double, key: String) {
        setValue(string: "\(double)", key: key)
    }

    public func getDoubleValue(key: String) -> Double? {
        if let value = getValue(key: key) {
            return Double(value)
        }
        return nil
    }

    public func setValue(int: Int, key: String) {
        setValue(string: "\(int)", key: key)
    }

    public func getIntValue(key: String) -> Int? {
        if let value = getValue(key: key) {
            return Int(value)
        }
        return nil
    }

    public func setValue(string: String, key: String) {
        SAMKeychain.setPassword(string, forService: Settings.Namespace, account: key)
    }
    
    public func getValue(key: String) -> String? {
        return SAMKeychain.password(forService: Settings.Namespace, account: key)
    }
    
    public func removeValue(key: String) {
        SAMKeychain.deletePassword(forService: Settings.Namespace, account: key)
    }

}

extension Settings {
    public static let Namespace = "co.chatsdk.settings"
}
