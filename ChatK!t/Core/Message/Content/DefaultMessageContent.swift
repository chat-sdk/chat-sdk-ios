//
//  DefaultMessageContent.swift
//  AFNetworking
//
//  Created by ben3 on 20/07/2020.
//

import Foundation

open class DefaultMessageContent: MessageContent {
    
    public required init() {
        
    }
    
    open func view() -> UIView {
        preconditionFailure("This method must be overridden")
    }
    
    open func bind(_ message: AbstractMessage, model: MessagesModel) {
        message.setContent(self)
    }
    
}

extension DefaultMessageContent {
    @objc open func showBubble() -> Bool {
        return true
    }
    @objc open func bubbleCornerRadius() -> CGFloat {
        return ChatKit.config().bubbleCornerRadius
    }
}
