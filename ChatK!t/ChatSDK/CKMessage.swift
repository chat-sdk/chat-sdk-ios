//
//  CKMessage.swift
//  ChatSDKSwift
//
//  Created by ben3 on 19/07/2020.
//  Copyright © 2020 deluge. All rights reserved.
//

import Foundation
import ChatSDK

public class CKMessage: NSObject, Message {
    

    let message: PMessage
    
    lazy var sender = CKUser(user: message.user())
    lazy var text = message.text()
    lazy var entityId = message.entityID()
    lazy var date = message.date()
    lazy var type = message.type()?.stringValue
    lazy var meta = message.meta()
    lazy var imageUrl = message.imageURL()
    lazy var direction: MessageDirection = message.senderIsMe() ? .outgoing : .incoming

    public init(message: PMessage) {
        self.message = message
    }
    
    public func messageId() -> String {
        return entityId!
    }

    public func messageDate() -> Date {
        return date!
    }

    public func messageText() -> String? {
        return text
    }

    public func messageSender() -> User {
        return sender
    }

    public func messageImageUrl() -> URL? {
        return imageUrl
    }
    
    public func messageType() -> String {
        return type!
    }
    
    public func messageMeta() -> [AnyHashable: Any]? {
        return meta!
    }
    
    public func messageDirection() -> MessageDirection {
        return direction
    }

    public func messageReadStatus() -> MessageReadStatus {
        if BChatSDK.readReceipt() != nil && messageDirection() == .outgoing {
            if let status = message.messageReadStatus?() {
                if status == bMessageReadStatusRead {
                    return .read
                }
                else if status == bMessageReadStatusDelivered {
                    return .delivered
                }
                else {
                    return .sent
                }
            }
        }
        return .none
    }
    
    public func messageReply() -> Reply? {
        if message.isReply() {
            // Get the user's name
            var fromUser: PUser?
            if let fromId = message.meta()[bFrom] as? String, let from = BChatSDK.db().fetchEntity(withID: fromId, withType: bUserEntity) as? PUser {
                fromUser = from
            }
            if fromUser == nil {
                if let fromId = message.meta()[bId] as? String, let originalMessage = BChatSDK.db().fetchEntity(withID: fromId, withType: bMessageEntity) as? PMessage {
                    fromUser = originalMessage.user()
                }
            }
            return CKReply(name: fromUser?.name(), text: message.reply(), imageURL: message.imageURL())
        }
        return nil
    }


}
