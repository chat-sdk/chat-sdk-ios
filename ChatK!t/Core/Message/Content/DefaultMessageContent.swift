//
//  DefaultMessageContent.swift
//  AFNetworking
//
//  Created by ben3 on 20/07/2020.
//

import Foundation

public class DefaultMessageContent: MessageContent {

    public required init() {
        
    }
    
    public func view() -> UIView {
        preconditionFailure("This method must be overridden")
    }
    
    public func bind(_ message: Message, model: MessagesModel) {
        message.setContent(self)
    }
    
}

extension DefaultMessageContent {
    @objc public func showBubble() -> Bool {
        return true
    }
    @objc public func bubbleCornerRadius() -> CGFloat {
        return ChatKit.config().bubbleCornerRadius
    }
}
