//
//  CoreBundle.swift
//  AFNetworking
//
//  Created by ben3 on 17/06/2020.
//

import Foundation

@objc public class CoreBundle: NSObject {
    
    // You can set this to override the bundle used and therefore the colors
    @objc public var bundle: Bundle?;
    
    @objc public func get() -> Bundle? {
        if bundle == nil {
            bundle = Bundle(name: "Frameworks/ChatSDK.framework/ChatUI")
        }
        return bundle;
    }
    
}
