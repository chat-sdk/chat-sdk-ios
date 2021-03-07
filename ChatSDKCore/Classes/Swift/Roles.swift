//
//  Affiliation.swift
//  AFNetworking
//
//  Created by ben3 on 17/11/2020.
//

import Foundation

public enum Affiliation: String {
    case owner = "owner"
    case admin = "admin"
    case member = "member"
    case outcast = "outcast"
    case none = "none"
}

@objc public class BAffiliation: NSObject {
    @objc public static let owner = Affiliation.owner.rawValue
    @objc public static let admin = Affiliation.admin.rawValue
    @objc public static let member = Affiliation.member.rawValue
    @objc public static let outcast = Affiliation.outcast.rawValue
    @objc public static let none = Affiliation.none.rawValue
}

public enum Role: String {
    case moderator = "moderator"
    case participant = "participant"
    case visitor = "visitor"
    case none = "none"
}

@objc public class BRole: NSObject {
    @objc public static let moderator = Role.moderator.rawValue
    @objc public static let participant = Role.participant.rawValue
    @objc public static let visitor = Role.visitor.rawValue
    @objc public static let none = Role.none.rawValue
}

@objc public extension NSString {

    @objc public func isOwner() -> Bool {
        return self as String == Affiliation.owner.rawValue
    }

    @objc public func isAdmin() -> Bool {
        return self as String == Affiliation.admin.rawValue
    }

    @objc public func isMember() -> Bool {
        return self as String == Affiliation.member.rawValue
    }

    @objc public func isOutcast() -> Bool {
        return self as String == Affiliation.outcast.rawValue
    }

    @objc public func isNone() -> Bool {
        return self as String == Affiliation.none.rawValue
    }
    
    @objc public func isOwnerOrAdmin() -> Bool {
        return isOwner() || isAdmin()
    }

    @objc public func isMemberOrOutcast() -> Bool {
        return isMember() || isOutcast()
    }
    
    @objc public func level() -> Int {
        switch self as String {
        case BAffiliation.owner:
            return 4
        case BAffiliation.admin:
            return 3
        case BAffiliation.member:
            return 2
        case BAffiliation.outcast:
            return 1
        default:
            return 0
        }
    }

    @objc public func isModerator() -> Bool {
        return self as String == Role.moderator.rawValue
    }

    @objc public func isParticipant() -> Bool {
        return self as String == Role.participant.rawValue
    }
    
    @objc public func isVisitor() -> Bool {
        return self as String == Role.visitor.rawValue
    }

    @objc public func hasVoice() -> Bool {
        return isModerator() || isParticipant()
    }
    
}

