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

    public init(messageType: String, incomingNibName: String, outgoingNibName: String, incomingContentClass: DefaultMessageContent.Type, outgoingContentClass: DefaultMessageContent.Type) {
        self.messageType = messageType
        self.incomingNib = MessageCellRegistration.nib(forName: incomingNibName)
        self.outgoingNib = MessageCellRegistration.nib(forName: outgoingNibName)
        self.incomingContentClass = incomingContentClass
        self.outgoingContentClass = outgoingContentClass
    }

    public init(messageType: String, nibName: String, contentClass: DefaultMessageContent.Type) {
        self.messageType = messageType
        self.incomingNib = MessageCellRegistration.nib(forName: nibName)
        self.outgoingNib = MessageCellRegistration.nib(forName: nibName)
        self.incomingContentClass = contentClass
        self.outgoingContentClass = contentClass
    }

    public init(messageType: String, incomingContentClass: DefaultMessageContent.Type, outgoingContentClass: DefaultMessageContent.Type) {
        self.messageType = messageType
        self.incomingNib = MessageCellRegistration.nib(forName: ChatKit.config().incomingMessageNibName)
        self.outgoingNib = MessageCellRegistration.nib(forName: ChatKit.config().outgoingMessageNibName)
        self.incomingContentClass = incomingContentClass
        self.outgoingContentClass = outgoingContentClass
    }

    public init(messageType: String, contentClass: DefaultMessageContent.Type) {
        self.messageType = messageType
        self.incomingNib = MessageCellRegistration.nib(forName: ChatKit.config().incomingMessageNibName)
        self.outgoingNib = MessageCellRegistration.nib(forName: ChatKit.config().outgoingMessageNibName)
        self.incomingContentClass = contentClass
        self.outgoingContentClass = contentClass
    }
    
    public static func nib(forName: String) -> UINib {
        return UINib(nibName: forName, bundle: Bundle(for: MessageCell.self))
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
