//
//  MessageType.swift
//  AFNetworking
//
//  Created by ben3 on 20/07/2020.
//

import Foundation

public class MessageType: NSObject {
    
    let type: String
    
    public init(type: String) {
        self.type = type
    }
    
    public class func text() -> MessageType {
        return MessageType(type: "Text")
    }

    public class func image() -> MessageType {
        return MessageType(type: "Image")
    }

    public class func location() -> MessageType {
        return MessageType(type: "Location")
    }

    public class func audio() -> MessageType {
        return MessageType(type: "Audio")
    }
    
    public class func video() -> MessageType {
        return MessageType(type: "Video")
    }
    
    public class func file() -> MessageType {
        return MessageType(type: "File")
    }

    public class func sticker() -> MessageType {
        return MessageType(type: "Sticker")
    }
    
    public func get() -> String {
        return type
    }
}
