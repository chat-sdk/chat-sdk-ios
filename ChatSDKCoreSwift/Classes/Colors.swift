//
//  ColorProvider.swift
//  AFNetworking
//
//  Created by ben3 on 16/06/2020.
//

import Foundation
import ChatSDK

@objc public class Colors: NSObject {
    
    @objc public static let outcomingDefaultBubbleColor = "outcomingDefaultBubbleColor"
    @objc public static let incomingDefaultBubbleColor = "incomingDefaultBubbleColor"

    @objc public static let incomingDefaultTextColor = "incomingDefaultTextColor"
    @objc public static let outcomingDefaultTextColor = "outcomingDefaultTextColor"

    @objc public func get(name: String) -> UIColor? {
        return UIColor(named: name, in: BChatSDK.shared()?.bundle, compatibleWith: nil)
    }
    
}
