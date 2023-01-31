//
//  Permission.swift

//
//  Created by Ben on 31/01/2022.
//

import Foundation
import CloudKit

@objc public class Permissions: NSObject {
    
    @objc public static let owner = "owner"
    @objc public static let admin = "admin"
    @objc public static let member = "member"
    @objc public static let watcher = "watcher"
    @objc public static let banned = "banned"
    @objc public static let none = "none"
    
    @objc public static func level(role: String) -> Int {
        switch role {
            case Permissions.owner: return 5
            case Permissions.admin: return 4
            case Permissions.member: return 3
            case Permissions.watcher: return 2
            case Permissions.banned: return 1
            default: return 0
        }
        return 0
    }
    
    @objc public static func all() -> [String] {
        return [
            Permissions.owner,
            Permissions.admin,
            Permissions.member,
            Permissions.watcher,
            Permissions.banned,
        ]
    }

    @objc public static func isOr(_ role: String, roles: [String]) -> Bool {
        return roles.contains(role)
    }
}
