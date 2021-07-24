//
//  Registration.swift
//  AFNetworking
//
//  Created by ben3 on 20/07/2020.
//

import Foundation
 
open class MessageCellRegistration {
    
    public let messageType: String
    public let incomingNib: UINib
    public let outgoingNib: UINib
    public let incomingContentClass: DefaultMessageContent.Type
    public let outgoingContentClass: DefaultMessageContent.Type

    public init(messageType: String, incomingNib: UINib, outgoingNib: UINib, incomingContentClass: DefaultMessageContent.Type, outgoingContentClass: DefaultMessageContent.Type) {
        self.messageType = messageType
        self.incomingNib = incomingNib
        self.outgoingNib = outgoingNib
        self.incomingContentClass = incomingContentClass
        self.outgoingContentClass = outgoingContentClass
    }
    
    public init(messageType: String, incomingContentClass: DefaultMessageContent.Type, outgoingContentClass: DefaultMessageContent.Type) {
        self.messageType = messageType
        self.incomingNib = UINib(nibName: ChatKit.config().incomingMessageNibName, bundle: Bundle(for: MessageCell.self))
        self.outgoingNib = UINib(nibName: ChatKit.config().outgoingMessageNibName, bundle: Bundle(for: MessageCell.self))
        self.incomingContentClass = incomingContentClass
        self.outgoingContentClass = outgoingContentClass
    }

    public init(messageType: String, contentClass: DefaultMessageContent.Type) {
        self.messageType = messageType
        self.incomingNib = UINib(nibName: ChatKit.config().incomingMessageNibName, bundle: Bundle(for: MessageCell.self))
        self.outgoingNib = UINib(nibName: ChatKit.config().outgoingMessageNibName, bundle: Bundle(for: MessageCell.self))
        self.incomingContentClass = contentClass
        self.outgoingContentClass = contentClass
    }

    open func nib(direction: MessageDirection) -> UINib {
        switch direction {
        case .incoming:
            return incomingNib
        case .outgoing:
            return outgoingNib
        }
    }
    
    open func identifier(direction: MessageDirection) -> String {
        return messageType + direction.get()
    }
        
    open func content(direction: MessageDirection) -> MessageContent {
        var contentClass: DefaultMessageContent.Type?
        switch direction {
        case .incoming:
            contentClass = incomingContentClass
        case .outgoing:
            contentClass = outgoingContentClass
        }
        return contentClass!.init()
    }

}
