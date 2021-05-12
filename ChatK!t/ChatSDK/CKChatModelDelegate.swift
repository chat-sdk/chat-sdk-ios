//
//  CKMessagesModelDelegate.swift
//  ChatK!t
//
//  Created by ben3 on 04/05/2021.
//

import Foundation
import ChatSDK
import RXPromise

public class CKChatModelDelegate: ChatModelDelegate {
    
    public override func loadMessages(with oldestMessage: Message?) -> Single<[Message]> {
        return Single<[Message]>.create { [weak self] single in
            if let model = self?._model, let thread = BChatSDK.db().fetchEntity(withID: model.thread().threadId(), withType: bThreadEntity) as? PThread {
                _ = BChatSDK.thread().loadMoreMessages(from: oldestMessage?.messageDate(), for: thread).thenOnMain({ success in
                    if let messages = success as? [PMessage] {
                        single(.success(CKChatModelDelegate.convert(messages)))
                    } else {
                        single(.success([]))
                    }
                    return success
                }, { error in
                    single(.success([]))
                    return error
                })
            }
            return Disposables.create {}
        }
    }
    
    public override func initialMessages() -> [Message] {
        var messages = [Message]()
        if let model = _model, let thread = BChatSDK.db().fetchEntity(withID: model.thread().threadId(), withType: bThreadEntity) as? PThread {
            for message in BChatSDK.db().loadMessages(for: thread, newest: 15) {
                if let message = message as? PMessage {
                    messages.insert(CKMessage(message: message), at: 0)
                }
            }
        }
        return messages
    }
    
    public static func convert(_ messages: [PMessage]) -> [Message] {
        var output = [Message]()
        for message in messages {
            output.append(CKMessage(message: message))
        }
        return output
    }

}

