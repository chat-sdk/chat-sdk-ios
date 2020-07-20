//
//  MessageType.swift
//  AFNetworking
//
//  Created by ben3 on 20/07/2020.
//

import Foundation

@objc public class MessageType: NSObject {
    
    let type: String
    
    @objc public init(type: String) {
        self.type = type
    }
    
    @objc public class func text() -> MessageType {
        return MessageType(type: "Text")
    }

    @objc public class func image() -> MessageType {
        return MessageType(type: "Image")
    }

    @objc public class func location() -> MessageType {
        return MessageType(type: "Location")
    }

    @objc public class func audio() -> MessageType {
        return MessageType(type: "Audio")
    }
    
    @objc public class func video() -> MessageType {
        return MessageType(type: "Video")
    }
    
    @objc public class func file() -> MessageType {
        return MessageType(type: "File")
    }

    @objc public class func sticker() -> MessageType {
        return MessageType(type: "Sticker")
    }
    
    @objc public func get() -> String {
        return type
    }
}
