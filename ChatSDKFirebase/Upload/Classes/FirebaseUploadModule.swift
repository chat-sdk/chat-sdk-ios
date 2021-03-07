//
//  FirebaseUploadModule.swift
//  ChatSDKFirebase
//
//  Created by ben3 on 13/01/2021.
//

import Foundation
import FirebaseCore

@objc open class FirebaseUploadModule: NSObject, PModule {
    static let instance = FirebaseUploadModule()
    @objc public static func shared() -> FirebaseUploadModule {
        return instance
    }
    
    @objc public var firebaseStorage: Storage?
    
    override public init() {
        super.init()
    }
    
    @objc public func activate() {
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
        BChatSDK.shared().networkAdapter.setUpload(BFirebaseUploadHandler.init())
    }
        
    @objc open func storage() -> Storage {
        return firebaseStorage ?? Storage.storage()
    }

}
