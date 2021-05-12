//
//  CKThread.swift
//  
//
//  Created by ben3 on 19/07/2020.
//

import Foundation
import ChatSDK

open class CKThread: Thread {
    
    let _thread: PThread
    
    lazy var _threadType: ThreadType = {
        if let type = _thread.type() {
            if type.int32Value == bThreadTypePublicGroup.rawValue {
                return .publicGroup
            } else if type.int32Value == bThreadTypePrivateGroup.rawValue {
                return .privateGroup
            } else if type.int32Value == bThreadType1to1.rawValue {
                return .private1to1
            }
        }
        return .none
    }()
    
    public init(_ thread: PThread) {
        _thread = thread
    }

    open func threadId() -> String {
        return _thread.entityID()
    }
    
    open func threadName() -> String {
        return _thread.displayName()
    }
    
    open func threadImageUrl() -> URL? {
        return URL(string: _thread.imageURL())
    }
    
    open func threadUsers() -> [User] {
        var users = [User]()
        for user in _thread.users() {
            if let user = user as? PUser {
                users.append(CKUser(user: user))
            }
        }
        return users
    }
        
    open func threadType() -> ThreadType {
        return _threadType
    }
}
