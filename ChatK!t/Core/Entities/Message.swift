//
//  Message.swift
//  AFNetworking
//
//  Created by ben3 on 18/07/2020.
//

import Foundation

public protocol Message {
    
    func messageId() -> String
    func messageType() -> String
    func messageDate() -> Date
    func messageText() -> String?
    func messageSender() -> User
    func messageImageUrl() -> URL?
    func messageMeta() -> [AnyHashable: Any]?
    func messageDirection() -> MessageDirection
    func messageReadStatus() -> MessageReadStatus
    func messageReply() -> Reply?

}

public extension Message {

    func sameDayAs(_ message: Message) -> Bool {
        return Calendar.current.isDate(messageDate(), inSameDayAs: message.messageDate())
    }
    
    static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.messageId() == rhs.messageId()
    }
}
