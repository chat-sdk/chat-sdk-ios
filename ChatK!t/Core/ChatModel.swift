//
//  ChatViewControllerModel.swift
//  AFNetworking
//
//  Created by ben3 on 19/07/2020.
//

import Foundation
import RxSwift

public protocol PChatModelDelegate: PMessagesModelDelegate {
}

public class ChatModelDelegate: PChatModelDelegate {

    weak var _model: ChatModel?

    public init() {
    }
    
    public func setModel(_ model: ChatModel) {
        _model = model
    }

    public func loadMessages(with oldestMessage: Message?) -> Single<[Message]> {
        preconditionFailure("This method must be overridden")
    }
    
    public func initialMessages() -> [Message] {
        preconditionFailure("This method must be overridden")
    }
    
}

public class ChatModel {

    public let _thread: Thread
    public var _options = [Option]()
    public var _sendBarActions = [SendBarAction]()
    public var _toolbarActions = [ToolbarAction]()
    public var _keyboardOverlays = [String: KeyboardOverlay]()
    
    public var _view: PChatViewController?
    public let _delegate: ChatModelDelegate
    
    public lazy var _messagesModel = {
        return ChatKit.provider().messagesModel(_thread, delegate: _delegate)
    }()
    
    public init(_ thread: Thread, delegate: ChatModelDelegate) {
        _thread = thread
        _delegate = delegate
        _delegate.setModel(self)
    }
    
    open func messagesModel() -> MessagesModel {
        return _messagesModel
    }
    
    open func title() -> String {
        return _thread.threadName()
    }

    /**
     Steady state subtitle
     */
    open func subtitle() -> String {
        let defaultText = initialSubtitle() ?? "";
        
        if _thread.threadType() == .private1to1 {
            if let user = _thread.threadOtherUser() {
                if user.userIsOnline() {
                    return Strings.t(Strings.online)
                } else if let lastOnline = user.userLastOnline() as NSDate?, let text = lastOnline.lastSeenTimeAgo() {
                    return text
                }
            }
        } else {
            var text = ""
            for user in _thread.threadUsers() {
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
            return Strings.t(Strings.tapHereForContactInfo)
        }
        return nil
    }
    
    public func addOption(_ option: Option) {
        _options.append(option)
    }
    
    open func options() -> [Option] {
        return _options
    }
    
    public func addSendBarAction(_ action: SendBarAction) {
        _sendBarActions.append(action)
    }

    public func sendBarActions() -> [SendBarAction] {
        return _sendBarActions
    }

    public func addToolbarAction(_ action: ToolbarAction) {
        _toolbarActions.append(action)
    }

    public func addKeyboardOverlay(name: String, overlay: KeyboardOverlay) {
        _keyboardOverlays[name] = overlay
    }

    public func keyboardOverlays() -> [KeyboardOverlay] {
        var values = [KeyboardOverlay]()
        for value in _keyboardOverlays.values {
            values.append(value)
        }
        return values
    }

    public func keyboardOverlay(for name: String) -> KeyboardOverlay? {
        return _keyboardOverlays[name]
    }

    public func setView(_ view: PChatViewController) {
        _view = view
    }
    
    public func loadInitialMessages() {
        _messagesModel.loadInitialMessages()
    }
        
    public func thread() -> Thread {
        return _thread
    }
    
}

extension ChatModel: ChatToolbarActionsDelegate {
    public func toolbarActions() -> [ToolbarAction] {
        return _toolbarActions
    }
}
