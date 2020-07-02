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

    @objc public static func get(name: String) -> UIImage? {
        return UIImage(named: name, in:  BChatSDK.shared()?.iconsBundle, compatibleWith: nil)
    }
        
    @objc public static func defaultUserImage() -> UIImage? {
        return get(name: defaultProfile)
    }

}

