//
//  CKThread.swift
//  
//
//  Created by ben3 on 19/07/2020.
//

import Foundation
import ChatSDK

@objc public class CKThread: NSObject, Thread {
    
    let thread: PThread
    
    @objc public init(thread: PThread) {
        self.thread = thread
    }

    public func threadId() -> String {
        return thread.entityID()
    }
    
    public func threadName() -> String {
        return thread.name()
    }
    
    public func threadImageUrl() -> URL? {
        return nil
    }
    
    public func threadUsers() -> [User] {
        var users = [User]()
        for user in thread.users() {
            if let user = user as? PUser {
                users.append(CKUser(user: user))
            }
        }
        return users
    }
    
    public func threadMessages() -> [Message] {
        var messages = [Message]()
        for message in thread.messagesOrderedByDateOldestFirst() {
            if let message = message as? PMessage {
                messages.append(CKMessage(message: message))
            }
        }
        return messages
    }
    
}
