//
//  ColorProvider.swift
//  AFNetworking
//
//  Created by ben3 on 16/06/2020.
//

import Foundation
//import ChatSDK

@objc public class Colors: NSObject {
    
    @objc public var bundle: Bundle?
    
    @objc public static let outcomingDefaultBubbleColor = "outcomingDefaultBubbleColor"
    @objc public static let outcomingDefaultSelectedBubbleColor = "outcomingDefaultSelectedBubbleColor"

    @objc public static let incomingDefaultBubbleColor = "incomingDefaultBubbleColor"
    @objc public static let incomingDefaultSelectedBubbleColor = "incomingDefaultSelectedBubbleColor"

    @objc public static let incomingDefaultTextColor = "incomingDefaultTextColor"
    @objc public static let outcomingDefaultTextColor = "outcomingDefaultTextColor"

    @objc public static let replyDividerColor = "replyDivider"
    @objc public static let replyTopBorderColor = "replyTopBorderColor"

    @objc public static let loginButton = "loginButton"
    @objc public static let registerButton = "registerButton"

    @objc public static let loginTextFieldBackgroundColor = "loginTextFieldBackgroundColor"

    @objc public static func get(name: String) -> UIColor? {
        return UIColor(named: name, in: BChatSDK.shared().colorsBundle, compatibleWith: nil)
    }
    
}
