//
//  ChatKitSetup.swift
//  ChatKitDemo
//
//  Created by ben3 on 27/07/2021.
//

import Foundation
import ChatKit
import RxSwift

public class ChatKitSetup: ChatModelDelegate {
    public var model: ChatModel?
    
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
        
        let model = ChatModel(DummyThread(), delegate: self)
        let vc = ChatViewController(model: model)
        
    }
    
}

public class DummyMessage: AbstractMessage {
    
}

public class DummyThread: Conversation {

    public func conversationId() -> String {
        return String(Int.random(in: 0..<999999999))
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
