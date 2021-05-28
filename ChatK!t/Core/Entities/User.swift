//
//  User.swift
//  AFNetworking
//
//  Created by ben3 on 18/07/2020.
//

import Foundation

public protocol User {
    func userId() -> String
    func userName() -> String
    func userImageUrl() -> URL?
    func userIsMe() -> Bool
    func userIsOnline() -> Bool
    func userLastOnline() -> Date?
}

public extension User {
    func userLastOnline() -> Date? {
        return nil
    }
}
