//
//  Conversation.swift
//  AFNetworking
//
//  Created by ben3 on 18/07/2020.
//

import Foundation

public protocol Conversation {
    func conversationId() -> String
    func conversationName() -> String
    func conversationImageUrl() -> URL?
    func conversationUsers() -> [User]
    func conversationType() -> ConversationType
    func conversationOtherUser() -> User?
}

public extension Conversation {
    func conversationOtherUser() -> User? {
        if conversationType() == .private1to1 && conversationUsers().count == 2 {
            for user in conversationUsers() {
                if !user.userIsMe() {
                    return user
                }
            }
        }
        return nil
    }
}
