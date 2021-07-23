//
//  CKMessageStore.swift
//  ChatK!t
//
//  Created by ben3 on 21/06/2021.
//

import Foundation
import ChatSDK


public class CKMessageStore {
    
    public static let instance = CKMessageStore()
    public static func shared() -> CKMessageStore {
        return instance
    }
    
    public var messageStore = [String: CKMessage]()

    public func new(for message: PMessage) -> CKMessage {
        var m: CKMessage?
        
        print("CKMessageStore: new message id: " + message.entityID())

        let type = message.type().intValue
        if type == bMessageTypeAudio.rawValue {
            m = CKAudioMessage(message: message)
        }
        else if type == bMessageTypeImage.rawValue {
            m = CKImageMessage(message: message)
        }
        else if type == bMessageTypeLocation.rawValue {
            m = CKLocationMessage(message: message)
        }
        else if type == bMessageTypeVideo.rawValue {
            m = CKVideoMessage(message: message)
        }
        else if let provider = ChatKitModule.shared().newMessageProviders[type] {
            m = provider.new(for: message)
        }
        else {
            m = CKMessage(message: message)
        }
        return m!
    }

    public func message(for message: PMessage) -> CKMessage {
        let message = self.message(with: message.entityID()) ?? new(for: message)
        messageStore[message.messageId()] = message
        return message
    }

    public func message(with id: String) -> CKMessage? {
        return messageStore[id]
    }


}

