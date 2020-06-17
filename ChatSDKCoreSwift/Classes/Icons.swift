//
//  Images.swift
//  AFNetworking
//
//  Created by ben3 on 17/06/2020.
//

import Foundation
import ChatSDK

@objc public class Icons: NSObject {
    
    @objc public static let defaultProfile = "defaultProfile"
    @objc public static let defaultGroup = "defaultGroup"
    @objc public static let defaultPlaceholder = "defaultPlaceholder"

    @objc public func get(name: String) -> UIImage? {
        return UIImage(named: name, in:  BChatSDK.shared()?.bundle, compatibleWith: nil)
    }
        
}

