//
//  AbstractMessage.swift
//  ChatK!t
//
//  Created by ben3 on 04/06/2021.
//

import Foundation

public class AbstractMessage: Message, Hashable, Equatable {
    
    public init() {
        
    }
    
    public var selected = false
    
    public var content: MessageContent?
    
    public func setContent(_ content: MessageContent) {
        self.content = content
    }
    
    public func sameDayAs(_ message: Message) -> Bool {
        return Calendar.current.isDate(messageDate(), inSameDayAs: message.messageDate())
    }
        
    public func messageId() -> String {
        preconditionFailure("This method must be overridden")
    }

    public func messageType() -> String {
        preconditionFailure("This method must be overridden")
    }

    public func messageDate() -> Date {
        preconditionFailure("This method must be overridden")
    }

    public func messageText() -> String? {
        return nil
    }

    public func messageSender() -> User {
        preconditionFailure("This method must be overridden")
    }

    public func messageMeta() -> [AnyHashable: Any]? {
        return nil
    }

    public func messageDirection() -> MessageDirection {
        preconditionFailure("This method must be overridden")
    }

    public func messageReadStatus() -> MessageReadStatus {
        preconditionFailure("This method must be overridden")
    }
    
    public func messageReply() -> Reply? {
        return nil
    }

    public func isSelected() -> Bool {
        return selected
    }
    
    public func setSelected(_ selected: Bool) {
        self.selected = selected
    }

    public func toggleSelected() {
        selected = !selected
    }
    
    public static func == (lhs: AbstractMessage, rhs: AbstractMessage) -> Bool {
        return lhs.messageId() == rhs.messageId()
    }
            
    public func hash(into hasher: inout Hasher) {
        hasher.combine(messageId())
    }
    
    public func messageContent() -> MessageContent? {
        return content
    }

}
