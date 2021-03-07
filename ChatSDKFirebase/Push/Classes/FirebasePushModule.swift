//
//  FirebasePushModule.swift
//  ChatSDKFirebase
//
//  Created by ben3 on 13/01/2021.
//

import Foundation
import FirebaseCore

@objc open class FirebasePushModule: NSObject, PModule {
    static let instance = FirebasePushModule()
    @objc public static func shared() -> FirebasePushModule {
        return instance
    }
    
    @objc public var firebaseFunctions: Functions?

    @objc open func activate() {
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
        BChatSDK.shared().networkAdapter.setPush(BFirebasePushHandler.init())
    }
    
    @objc open func functions() -> Functions {
        return firebaseFunctions ?? Functions.functions()
    }
    
}
