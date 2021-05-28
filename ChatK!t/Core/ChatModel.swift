//
//  ChatViewControllerModel.swift
//  AFNetworking
//
//  Created by ben3 on 19/07/2020.
//

import Foundation
import RxSwift

public class ChatModelDelegate: MessagesModelDelegate {

    weak var model: ChatModel?

    public init() {
    }
    
    public func loadMessages(with oldestMessage: Message?) -> Single<[Message]> {
        preconditionFailure("This method must be overridden")
    }
    
    public func initialMessages() -> [Message] {
        preconditionFailure("This method must be overridden")
    }
    
}

public class ChatModel: ChatToolbarActionsDelegate {

    public let thread: Thread
    public var options = [Option]()
    public var sendBarActions = [SendBarAction]()
    public var toolbarActions = [ToolbarAction]()
    public var keyboardOverlayMap = [String: KeyboardOverlay]()
    
    public var view: PChatViewController?
    public let delegate: ChatModelDelegate
    
    public lazy var messagesModel = {
        return ChatKit.provider().messagesModel(thread, delegate: delegate)
    }()
    
    public init(_ thread: Thread, delegate: ChatModelDelegate) {
        self.thread = thread
        self.delegate = delegate
        delegate.model = self
    }
        
    public func title() -> String {
        return thread.threadName()
    }

    /**
     Steady state subtitle
     */
    public func subtitle() -> String {
        let defaultText = initialSubtitle() ?? "";
        
        if thread.threadType() == .private1to1 {
            if let user = thread.threadOtherUser() {
                if user.userIsOnline() {
                    return Strings.t(Strings.online)
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
    public func initialSubtitle() -> String? {
        if ChatKit.config().userChatInfoEnabled {
            return Strings.t(Strings.tapHereForContactInfo)
        }
        return nil
    }
    
    public func addOption(_ option: Option) {
        options.append(option)
    }
        
    public func addSendBarAction(_ action: SendBarAction) {
        sendBarActions.append(action)
    }

    public func addToolbarAction(_ action: ToolbarAction) {
        toolbarActions.append(action)
    }

    public func addKeyboardOverlay(name: String, overlay: KeyboardOverlay) {
        keyboardOverlayMap[name] = overlay
    }

    public func keyboardOverlays() -> [KeyboardOverlay] {
        var values = [KeyboardOverlay]()
        for value in keyboardOverlayMap.values {
            values.append(value)
        }
        return values
    }

    public func keyboardOverlay(for name: String) -> KeyboardOverlay? {
        return keyboardOverlayMap[name]
    }
    
    public func loadInitialMessages() {
        messagesModel.loadInitialMessages()
    }
    
}
