//
//  CKThread.swift
//  
//
//  Created by ben3 on 19/07/2020.
//

import Foundation
import ChatSDK


open class CKThread: Conversation {
    
    let thread: PThread
    
    lazy var type: ConversationType = {
        if let type = thread.type() {
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
        self.thread = thread
    }

    open func conversationId() -> String {
        return thread.entityID()
    }
    
    open func conversationName() -> String {
        return thread.displayName() ?? "Thread"
    }
    
    open func conversationImageUrl() -> URL? {
        return URL(string: thread.imageURL())
    }
    
    open func conversationUsers() -> [User] {
        var users = [User]()
        for user in thread.users() {
            if let user = user as? PUser {
                users.append(CKUser(user: user))
            }
        }
        return users
    }
        
    open func conversationType() -> ConversationType {
        return type
    }
}
