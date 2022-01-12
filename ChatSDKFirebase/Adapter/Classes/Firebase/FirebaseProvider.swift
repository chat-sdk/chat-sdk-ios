//
//  FirebaseProvider.swift
//  ChatSDKFirebase
//
//  Created by ben3 on 10/01/2022.
//

import Foundation

@objc open class FirebaseProvider: NSObject {
    
    @objc open func userWrapper(snapshot: DataSnapshot) -> CCUserWrapper {
        return CCUserWrapper.user(with: snapshot)
    }

    @objc open func userWrapper(model: PUser) -> CCUserWrapper {
        return CCUserWrapper.user(withModel: model)
    }
    @objc open func userWrapper(entityID: String) -> CCUserWrapper {
        return CCUserWrapper.user(withEntityID: entityID)
    }
    @objc open func userWrapper(authData: User) -> CCUserWrapper {
        return CCUserWrapper.user(withAuthUserData: authData)
    }

    @objc open func threadWrapper(model: PThread) -> CCThreadWrapper {
        return CCThreadWrapper.thread(withModel: model)
    }
    
    @objc open func threadWrapper(entityID: String) -> CCThreadWrapper {
        return CCThreadWrapper.thread(withEntityID: entityID)
    }

    @objc open func messageWrapper(snapshot: DataSnapshot) -> CCMessageWrapper {
        return CCMessageWrapper.message(with: snapshot)
    }

    @objc open func messageWrapper(entityID: String) -> CCMessageWrapper {
        return CCMessageWrapper.message(withID: entityID)
    }

    @objc open func messageWrapper(model: PMessage) -> CCMessageWrapper {
        return CCMessageWrapper.message(withModel: model)
    }
 
}
