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
    
    open func userId() -> String {
        return user.entityID()
    }
    
    open func userName() -> String {
        return user.name()
    }
    
    open func userImageUrl() -> URL? {
        if let url = user.imageURL() {
            return URL(string: url)
        }
        return nil
    }
    
    open func userImage() -> UIImage? {
        return user.imageAsImage()
    }
    
    open func userIsMe() -> Bool {
        return user.isMe()
    }
    
    open func userIsOnline() -> Bool {
        return user.online()?.boolValue ?? false
    }
    
}
