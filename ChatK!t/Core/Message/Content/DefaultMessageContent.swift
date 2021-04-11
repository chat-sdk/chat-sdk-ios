//
//  DefaultMessageContent.swift
//  AFNetworking
//
//  Created by ben3 on 20/07/2020.
//

import Foundation

public class DefaultMessageContent: NSObject, MessageContent {

    public func view() -> UIView {
        assert(false, "DefaultMessageContent view() method must be overridden")
        return UIView()
    }
    
    public func bind(message: Message) {
        
    }
    
//    public func showBubble() -> Bool {
//        return true
//    }
//    public func bubbleCornerRadius() -> Float {
//        return 5.0
//    }
    
}

extension DefaultMessageContent {
    public func showBubble() -> Bool {
        return true
    }
    public func bubbleCornerRadius() -> CGFloat {
        return 10.0
    }
}
