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

    @objc public static let icnCopy = "copy"
    @objc public static let icnForward = "forward"
    @objc public static let icnCheck = "check"

    @objc public static func get(name: String) -> UIImage? {
        return UIImage(named: name, in:  BChatSDK.shared().iconsBundle, compatibleWith: nil)
    }
        
    @objc public static func defaultUserImage() -> UIImage? {
        return get(name: defaultProfile)
    }

    @objc public static func getForward() -> UIImage? {
        return get(name: icnForward)
    }

    @objc public static func getCopy() -> UIImage? {
        return get(name: icnCopy)
    }

    @objc public static func getCheck() -> UIImage? {
        return get(name: icnCheck)
    }

}

