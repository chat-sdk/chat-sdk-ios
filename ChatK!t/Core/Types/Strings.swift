//
//  Strings.swift
//  ChatK!t
//
//  Created by ben3 on 10/04/2021.
//

import Foundation

public class Strings {
    public static let conversation = "conversation"
    public static let tapHereForContactInfo = "tapHereForContactInfo"
    public static let tapHereForGroupInfo = "tapHereForGroupInfo"

    public static let online = "online"
    public static let offline = "offline"
    public static let connecting = "connecting"
    public static let copiedToClipboard = "copiedToClipboard"

    public static let lastSeen_at_ = "lastSeen_at_"
    public static let today = "today"
    public static let yesterday = "yesterday"
    public static let requestAudioPermission = "requestAudioPermission"
    public static let audioPermissionDenied = "audioPermissionDenied"

    public static let camera = "camera"
    public static let gallery = "gallery"
    public static let location = "location"
    public static let file = "file"
    public static let sticker = "sticker"
    public static let video = "video"

    public static func t(_ text: String) -> String {
        return NSLocalizedString(text, bundle: Bundle(for: Strings.self), comment: "")
    }
    
}

public extension NSObject {
    func t(_ text: String) -> String {
        return NSLocalizedString(text, bundle: Bundle(for: Strings.self), comment: "")
    }
}
