//
//  AbstractMessage.swift
//  ChatK!t
//
//  Created by ben3 on 04/06/2021.
//

import Foundation

open class AbstractMessage: Message, Hashable, Equatable {
    
    public init() {
        
    }
    
    open var selected = false
    
    open weak var content: MessageContent?
    
    open func setContent(_ content: MessageContent) {
        self.content = content
    }
    
    open func sameDayAs(_ message: Message) -> Bool {
        return Calendar.current.isDate(messageDate(), inSameDayAs: message.messageDate())
    }
        
    open func messageId() -> String {
        preconditionFailure("This method must be overridden")
    }

    open func messageType() -> String {
        preconditionFailure("This method must be overridden")
    }

    open func messageDate() -> Date {
        preconditionFailure("This method must be overridden")
    }

    open func messageText() -> String? {
        return nil
    }

    open func messageSender() -> User {
        preconditionFailure("This method must be overridden")
    }

    open func messageMeta() -> [AnyHashable: Any]? {
        return nil
    }

    open func messageDirection() -> MessageDirection {
        preconditionFailure("This method must be overridden")
    }

    open func messageReadStatus() -> MessageReadStatus {
        return .none
    }
    
    open func messageReply() -> Reply? {
        return nil
    }

    open func isSelected() -> Bool {
        return selected
    }
    
    open func setSelected(_ selected: Bool) {
        self.selected = selected
    }

    open func toggleSelected() {
        selected = !selected
    }
    
    public static func == (lhs: AbstractMessage, rhs: AbstractMessage) -> Bool {
        return lhs.messageId() == rhs.messageId()
    }
            
    open func hash(into hasher: inout Hasher) {
        hasher.combine(messageId())
    }
    
    open func messageContent() -> MessageContent? {
        return content
    }

}
