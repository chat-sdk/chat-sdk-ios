//
//  User.swift
//  AFNetworking
//
//  Created by ben3 on 18/07/2020.
//

import Foundation

public protocol User : class {
    func userId() -> String
    func userName() -> String
    
    // You can either provide an image url or an actual image
    func userImageUrl() -> URL?
    func userImage() -> UIImage?
    
    func userIsMe() -> Bool
    func userIsOnline() -> Bool
    func userLastOnline() -> Date?
}

public extension User {
    func userLastOnline() -> Date? {
        return nil
    }
}
