//
//  DefaultMessageContent.swift
//  AFNetworking
//
//  Created by ben3 on 20/07/2020.
//

import Foundation

public class DefaultMessageContent: NSObject, MessageContent {

    public func view() -> UIView {
        preconditionFailure("This method must be overridden")
    }
    
    public func bind(_ message: Message, model: MessagesModel) {
        preconditionFailure("This method must be overridden")
    }
    
}

extension DefaultMessageContent {
    @objc public func showBubble() -> Bool {
        return true
    }
    @objc public func bubbleCornerRadius() -> CGFloat {
        return 10.0
    }
}
