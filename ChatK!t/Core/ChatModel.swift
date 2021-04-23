//
//  ChatViewControllerModel.swift
//  AFNetworking
//
//  Created by ben3 on 19/07/2020.
//

import Foundation
import RxSwift
import ChatSDK

public class ChatModel: NSObject {

    public let thread: Thread
    public var options = [Option]()
    public var sendBarActions = [SendBarAction]()
    public var keyboardOverlays = [String: KeyboardOverlay]()
    
    public var view: PChatViewController?
    
    public lazy var messagesModel = {
        return MessagesModel(thread: thread)
    }()
    
    public init(thread: Thread) {
        self.thread = thread
    }
    
    open func getMessagesModel() -> MessagesModel {
        return messagesModel
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
        if ChatKit.config().userChatInfoEnabled {
            return t(Strings.tapHereForContactInfo)
        }
        return nil
    }

    open func send(text: String) {
        
    }
    
    open func deleteMessages(messages: [Message]) {
        
    }
    
    public func addOption(_ option: Option) {
        options.append(option)
    }
    
    open func getOptions() -> [Option] {
        return options
    }
    
    public func addSendBarAction(_ action: SendBarAction) {
        sendBarActions.append(action)
    }

    public func getSendBarActions() -> [SendBarAction] {
        return sendBarActions
    }

    public func addKeyboardOverlay(name: String, overlay: KeyboardOverlay) {
        keyboardOverlays[name] = overlay
    }

    public func getKeyboardOverlays() -> [KeyboardOverlay] {
        var values = [KeyboardOverlay]()
        for value in keyboardOverlays.values {
            values.append(value)
        }
        return values
    }

    public func keyboardOverlay(for name: String) -> KeyboardOverlay? {
        return keyboardOverlays[name]
    }

}
