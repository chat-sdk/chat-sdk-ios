//
//  Images.swift
//  AFNetworking
//
//  Created by ben3 on 17/06/2020.
//

import Foundation

@objc public class Icons: NSObject {
    
    @objc public var bundle: Bundle?

    @objc public static let defaultProfile = "defaultProfile"
    @objc public static let defaultGroup = "defaultGroup"
    @objc public static let defaultPlaceholder = "defaultPlaceholder"

    @objc public func get(name: String) -> UIImage? {
        if bundle == nil {
            self.bundle = BChatSDK.shared()?.bundle
        }
        return UIImage(named: name, in:  bundle, compatibleWith: nil)
    }
        
}

