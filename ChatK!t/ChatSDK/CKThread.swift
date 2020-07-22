//
//  CKThread.swift
//  
//
//  Created by ben3 on 19/07/2020.
//

import Foundation
import ChatSDK

@objc public class CKThread: NSObject, Thread {
    
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
    
    @objc public init(thread: PThread) {
        _thread = thread
    }

    @objc public func threadId() -> String {
        return _thread.entityID()
    }
    
    @objc public func threadName() -> String {
        return _thread.name()
    }
    
    @objc public func threadImageUrl() -> URL? {
        return nil
    }
    
    @objc public func threadUsers() -> [User] {
        var users = [User]()
        for user in _thread.users() {
            if let user = user as? PUser {
                users.append(CKUser(user: user))
            }
        }
        return users
    }
    
    @objc public func threadMessages() -> [Message] {
        var messages = [Message]()
        for message in _thread.messagesOrderedByDateOldestFirst() {
            if let message = message as? PMessage {
                messages.append(CKMessage(message: message))
            }
        }
        return messages
    }
    
    @objc public func threadType() -> ThreadType {
        return _threadType
    }
}
