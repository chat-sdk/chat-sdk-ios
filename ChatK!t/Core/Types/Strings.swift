//
//  Strings.swift
//  ChatK!t
//
//  Created by ben3 on 10/04/2021.
//

import Foundation

public class Strings {
    public static let thread = "thread"
    public static let tapHereForContactInfo = "tapHereForContactInfo"
    public static let online = "online"
    public static let offline = "offline"
    public static let connecting = "connecting"
    public static let copiedToClipboard = "copiedToClipboard"
    public static let gallery = "gallery"
    public static let location = "location"

    public static let lastSeen_at_ = "lastSeen_at_"
    public static let today = "today"
    public static let yesterday = "yesterday"

    public static func t(_ text: String) -> String {
        return NSLocalizedString(text, bundle: Bundle(for: Strings.self), comment: "")
    }
    
}

public extension NSObject {
    func t(_ text: String) -> String {
        return NSLocalizedString(text, bundle: Bundle(for: Strings.self), comment: "")
    }
}
