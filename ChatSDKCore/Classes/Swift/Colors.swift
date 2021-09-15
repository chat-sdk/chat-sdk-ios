//
//  ColorProvider.swift
//  AFNetworking
//
//  Created by ben3 on 16/06/2020.
//

import Foundation

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

    @objc public static let background = "background"
    @objc public static let label = "label"
    @objc public static let gray = "gray"
    @objc public static let mediumGray = "mediumGray"


    @objc public static let loginTextFieldBackgroundColor = "loginTextFieldBackgrzxoundColor"

    @objc public static func get(name: String) -> UIColor? {
        if #available(iOS 11.0, *) {
            return UIColor(named: name, in: BChatSDK.shared().colorsBundle, compatibleWith: nil)
        } else {
            var color: String? = nil
            if name == background {
                color = "#FFFFFF"
            } else if (name == gray) {
                color = "#aeaeb2"
            } else if (name == incomingDefaultBubbleColor) {
                color = "#d6d4d3"
            } else if (name == incomingDefaultSelectedBubbleColor) {
                color = "#41d75d"
            } else if (name == incomingDefaultTextColor) {
                color = "#000000"
            } else if (name == label) {
                color = "#000000"
            } else if (name == loginButton) {
                color = "#43a4f3"
            } else if (name == loginTextFieldBackgroundColor) {
                return UIColor.clear
            } else if (name == outcomingDefaultBubbleColor) {
                color = "#abcff5"
            } else if (name == outcomingDefaultSelectedBubbleColor) {
                color = "#41d75d"
            } else if (name == outcomingDefaultTextColor) {
                color = "#000000"
            } else if (name == registerButton) {
                color = "#3ac86e"
            } else if (name == replyDividerColor) {
                color = "#3eb43f"
            } else if (name == replyTopBorderColor) {
                color = "#cecece"
            } else if (name == mediumGray) {
                color = "#686c70"
            }
            if let color = color {
                return BCoreUtilities.color(withHexString: color)
            } else {
                return nil
            }
        }
    }
    
}
