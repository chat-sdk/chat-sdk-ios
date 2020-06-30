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

    @objc public func get(name: String) -> UIColor? {
        if bundle == nil {
            self.bundle = BChatSDK.shared()?.bundle
        }
        return UIColor(named: name, in: bundle, compatibleWith: nil)
    }
    
}
