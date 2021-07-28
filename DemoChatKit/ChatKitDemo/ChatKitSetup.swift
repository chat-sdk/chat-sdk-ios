//
//  ChatKitSetup.swift
//  ChatKitDemo
//
//  Created by ben3 on 27/07/2021.
//

import Foundation
import ChatKit
import RxSwift
import LoremIpsum

public class ChatKitSetup: ChatModelDelegate {
    public var model: ChatModel?
    public var thread: DummyThread?
    
    public func loadMessages(with oldestMessage: AbstractMessage?) -> Single<[AbstractMessage]> {
        Single<[AbstractMessage]>.create { [weak self] single in
            
            return Disposables.create {}
        }
    }
    
    public func initialMessages() -> [AbstractMessage] {
        return []
    }
    
    public func onClick(_ message: AbstractMessage) -> Bool {
        return true
    }
    
    public init() {
        
        
        
        
    }
    
    public func chatViewController() -> UIViewController {
        thread = DummyThread()
        model = ChatModel(thread!, delegate: self)
        
        model?.addSendBarAction(SendBarActions.send {
            model?.messagesModel.addMessage(toEnd: DummyMessage())
        })
        
        return ChatViewController(model: model)
    }
    
}

public class DummyMessage: AbstractMessage {
    
    let id = String(Int.random(in: 0..<999999999))
    let date = Date()
    let text = LoremIpsum.word
    let sender = User()
    let type = MessageType.text()
    
    override init() {
        
    }
    
    open override func messageId() -> String {
        return id
    }

    open override func messageDate() -> Date {
        return date
    }

    open override func messageText() -> String? {
        return text
    }

    open override func messageSender() -> User {
        return sender
    }
    
    open override func messageType() -> String {
        return type!
    }

}

public class DummyThread: Conversation {

    let id = String(Int.random(in: 0..<999999999))
   
    public func conversationId() -> String {
        return id
    }
    
    public func conversationName() -> String {
        return "Dummy"
    }
    
    public func conversationImageUrl() -> URL? {
        return nil
    }
    
    public func conversationUsers() -> [User] {
        return []
    }
    
    public func conversationType() -> ConversationType {
        return .private1to1
    }
    
}
