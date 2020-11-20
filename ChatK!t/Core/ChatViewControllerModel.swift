//
//  ChatViewControllerModel.swift
//  AFNetworking
//
//  Created by ben3 on 19/07/2020.
//

import Foundation

@objc public class ChatViewControllerModel: NSObject {

    let thread: Thread
    
    lazy var _messagesViewModel = {
        return MessagesViewModel(thread: thread)
    }()
    
    @objc public init(thread: Thread) {
        self.thread = thread
    }
    
    @objc public func messagesViewModel() -> MessagesViewModel {
        return _messagesViewModel
    }
    
    @objc public func title() -> String {
        return thread.threadName()
    }
    
    @objc public func send(text: String) {
        
    }

}
