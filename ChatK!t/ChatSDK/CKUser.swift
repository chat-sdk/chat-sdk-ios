//
//  CKUser.swift
//  AFNetworking
//
//  Created by ben3 on 19/07/2020.
//

import Foundation
import ChatSDK

open class CKUser: User {
    
    let user: PUser
    
    public init(user: PUser) {
        self.user = user
    }
    
    public func userId() -> String {
        return user.entityID()
    }
    
    public func userName() -> String {
        return user.name()
    }
    
    public func userImageUrl() -> URL? {
        return URL(string: user.imageURL())
    }
    
    public func userIsMe() -> Bool {
        return user.isMe()
    }
    
    public func userIsOnline() -> Bool {
        return user.online()?.boolValue ?? false
    }
    
}
