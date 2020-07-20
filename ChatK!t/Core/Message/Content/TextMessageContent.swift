//
//  TextMessageContent.swift
//  AFNetworking
//
//  Created by ben3 on 20/07/2020.
//

import Foundation

@objc public class TextMessageContent: NSObject, MessageContent {
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    @objc public func view() -> UIView {
        return label
    }
    
    @objc public func bind(message: Message) {
        label.text = message.messageText()
    }
    
}
