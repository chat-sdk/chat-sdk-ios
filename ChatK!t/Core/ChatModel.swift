//
//  ChatViewControllerModel.swift
//  AFNetworking
//
//  Created by ben3 on 19/07/2020.
//

import Foundation
import RxSwift
import DateTools

//public protocol ChatModelDelegate: MessagesModelDelegate {
//    var model: ChatModel? {
//        get set
//    }
//}

open class ChatModel: ChatToolbarActionsDelegate {

    public let thread: Thread
    open var options = [Option]()
    open var sendBarActions = [SendBarAction]()
    open var toolbarActions = [ToolbarAction]()
    open var keyboardOverlayMap = [String: KeyboardOverlay]()
    
    open var view: PChatViewController?
    open var delegate: MessagesModelDelegate
    
    open lazy var messagesModel = {
        return ChatKit.provider().messagesModel(thread, delegate: delegate)
    }()
    
    public init(_ thread: Thread, delegate: MessagesModelDelegate) {
        self.thread = thread
        self.delegate = delegate
        self.delegate.model = self
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
    open func initialSubtitle() -> String? {
        if ChatKit.config().userChatInfoEnabled {
            if thread.threadType() == ThreadType.private1to1 {
                return Strings.t(Strings.tapHereForContactInfo)
            } else {
                return Strings.t(Strings.tapHereForGroupInfo)
            }
        }
        return nil
    }
    
    open func addOption(_ option: Option) {
        options.append(option)
    }
        
    open func addSendBarAction(_ action: SendBarAction) {
        sendBarActions.append(action)
    }

    open func addToolbarAction(_ action: ToolbarAction) {
        toolbarActions.append(action)
    }

    open func addKeyboardOverlay(name: String, overlay: KeyboardOverlay) {
        keyboardOverlayMap[name] = overlay
    }

    open func keyboardOverlays() -> [KeyboardOverlay] {
        var values = [KeyboardOverlay]()
        for value in keyboardOverlayMap.values {
            values.append(value)
        }
        return values
    }

    open func keyboardOverlay(for name: String) -> KeyboardOverlay? {
        return keyboardOverlayMap[name]
    }
    
    open func loadInitialMessages() {
        messagesModel.loadInitialMessages()
    }
    
}
