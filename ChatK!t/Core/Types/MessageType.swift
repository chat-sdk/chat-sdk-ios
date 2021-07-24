//
//  MessageType.swift
//  AFNetworking
//
//  Created by ben3 on 20/07/2020.
//

import Foundation

open class MessageType: NSObject {
    
    let type: String
    
    public init(type: String) {
        self.type = type
    }
    
    open class func text() -> MessageType {
        return MessageType(type: "Text")
    }

    open class func image() -> MessageType {
        return MessageType(type: "Image")
    }

    open class func location() -> MessageType {
        return MessageType(type: "Location")
    }

    open class func audio() -> MessageType {
        return MessageType(type: "Audio")
    }
    
    open class func video() -> MessageType {
        return MessageType(type: "Video")
    }
    
    open class func file() -> MessageType {
        return MessageType(type: "File")
    }

    open class func sticker() -> MessageType {
        return MessageType(type: "Sticker")
    }
    
    open func get() -> String {
        return type
    }
}
