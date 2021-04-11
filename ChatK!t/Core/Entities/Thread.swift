//
//  Conversation.swift
//  AFNetworking
//
//  Created by ben3 on 18/07/2020.
//

import Foundation

public protocol Thread {
    
    func threadId() -> String
    func threadName() -> String
    func threadImageUrl() -> URL?
    func threadUsers() -> [User]
    func threadMessages() -> [Message]
    func threadType() -> ThreadType
    func threadOtherUser() -> User?

}

public extension Thread {
    func threadOtherUser() -> User? {
        if threadType() == .private1to1 && threadUsers().count == 2 {
            for user in threadUsers() {
                if !user.userIsMe() {
                    return user
                }
            }
        }
        return nil
    }
}
