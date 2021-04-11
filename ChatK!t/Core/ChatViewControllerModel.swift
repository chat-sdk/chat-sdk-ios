//
//  ChatViewControllerModel.swift
//  AFNetworking
//
//  Created by ben3 on 19/07/2020.
//

import Foundation
import RxSwift
import ChatSDK

open class ChatViewControllerModel: NSObject {

    public let thread: Thread
    
    public lazy var _messagesViewModel = {
        return MessagesViewModel(thread: thread)
    }()
    
    public init(thread: Thread) {
        self.thread = thread
    }
    
    open func messagesViewModel() -> MessagesViewModel {
        return _messagesViewModel
    }
    
    open func title() -> String {
        return thread.threadName()
    }

    /**
     Steady state subtitle
     */
    open func subtitle() -> String {
        let defaultText = initialSubtitle() ?? "";
        
        if thread.threadType() == .private1to1 {
            if let user = thread.threadOtherUser() {
                if user.userIsOnline() {
                    return t(Strings.online)
                } else if let lastOnline = user.userLastOnline() as NSDate?, let text = lastOnline.lastSeenTimeAgo() {
                    return text
                }
            }
        } else {
            var text = ""
            for user in thread.threadUsers() {
                if !user.userIsMe() {
                    text += user.userName() + ", "
                }
            }
            if text.count > 1 {
                text = String(text.prefix(text.count - 2))
            }
            return text
        }
        
        return defaultText
     }
    
    /**
        This is shown for a period when the screen initially loads
     */
    open func initialSubtitle() -> String? {
        if ChatKit.shared().config.userChatInfoEnabled {
            return t(Strings.tapHereForContactInfo)
        }
        return nil
    }

    open func send(text: String) {
        
    }

}
