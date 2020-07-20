//
//  Registration.swift
//  AFNetworking
//
//  Created by ben3 on 20/07/2020.
//

import Foundation
 
@objc public class MessageCellRegistration: NSObject {
    
    let _nib: UINib
    let _messageType: String
    let _direction: MessageDirection
    let _contentClass: MessageContent.Type
    
    public lazy var identifier: String = {
        return _messageType + _direction.get()
    }()
        
    @objc public init(contentClass: MessageContent.Type, nib: UINib, messageType: String, direction: MessageDirection) {
        _contentClass = contentClass
        _nib = nib
        _messageType = messageType
        _direction = direction
    }
    
    @objc public init(contentClass: MessageContent.Type, messageType: String, direction: MessageDirection) {
        switch direction {
            case .incoming:
                _nib = UINib(nibName: "IncomingMessageCell", bundle: Bundle(for: MessageCell.self))
            case .outgoing:
                _nib = UINib(nibName: "OutgoingMessageCell", bundle: Bundle(for: MessageCell.self))
        }
        _contentClass = contentClass
        _messageType = messageType
        _direction = direction
    }

//    convenience public init<T: MessageContent>(contentType: T.Type, nib: UINib, messageType: String, direction: MessageDirection) {
//        self.init(contentClass: contentType, nib: nib, messageType: messageType, direction: direction)
//    }
//
//    convenience public init<T: MessageContent>(contentType: T.Type, messageType: String, direction: MessageDirection) {
//        self.init(contentClass: contentType, messageType: messageType, direction: direction)
//    }

    @objc public func messageType() -> String {
        return _messageType
    }

    @objc public func nib() -> UINib {
        return _nib
    }
    
    @objc public func direction() -> MessageDirection {
        return _direction
    }
    
    @objc public func content() -> MessageContent {
        return _contentClass.init()
//        let content = _contentClass as! MessageContent
//        return content.init() as! MessageContent
    }

}
