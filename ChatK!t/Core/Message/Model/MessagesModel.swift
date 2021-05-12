//
//  ChatViewModel.swift
//  AFNetworking
//
//  Created by ben3 on 18/07/2020.
//

import Foundation
import RxSwift

public protocol PMessagesModelDelegate {
    // Need to be with the oldest message first
    func loadMessages(with oldestMessage: Message?) -> Single<[Message]>

    // Need to be with the oldest message last
    func initialMessages() -> [Message]
}

public class MessagesModel {
    
    public let _thread: Thread
    public let _delegate: PMessagesModelDelegate
    public let _messageTimeFormatter = DateFormatter()
            
    public var _onSelectionChange: (([Message]) -> Void)?
    public var _sectionNib: UINib? = ChatKit.provider().sectionNib()
    
    public var _messageCellRegistrations = [String: MessageCellRegistration]()
    public var _view: PMessagesView?
    
    public var _adapter = MessagesListAdapter()
    
    public init(_ thread: Thread, delegate: PMessagesModelDelegate) {
        _thread = thread
        _delegate = delegate
        _messageTimeFormatter.setLocalizedDateFormatFromTemplate(ChatKit.config().timeFormat)
    }
    
    public func delegate() -> PMessagesModelDelegate {
        _delegate
    }
    
    public func messageTimeFormatter() -> DateFormatter {
        return _messageTimeFormatter
    }
    
    public func registerMessageCell(registration: MessageCellRegistration) {
        _messageCellRegistrations[registration.messageType()] = registration
    }

    public func registerMessageCells(registrations: [MessageCellRegistration]) {
        for registration in registrations {
            registerMessageCell(registration: registration)
        }
    }
    
    public func cellRegistration(_ messageType: String) -> MessageCellRegistration? {
        return _messageCellRegistrations[messageType]
    }

    public func messageCellRegistrations() -> [MessageCellRegistration] {
        return _messageCellRegistrations.map { $1 }
    }
    
    public func sectionNib() -> UINib? {
        return _sectionNib
    }
    
    public func sectionIdentifier() -> String {
        return SectionCell.identifier
    }
    
    public func estimatedRowHeight() -> CGFloat {
        return 69
    }

    public func avatarSize() -> CGFloat {
        return 34
    }
    
    public func incomingBubbleColor(selected: Bool = false) -> UIColor {
        if selected {
            return ChatKit.asset(color: "incoming_bubble_selected")
        } else {
            return ChatKit.asset(color: "incoming_bubble")
        }
    }

    public func outgoingBubbleColor(selected: Bool = false) -> UIColor {
        if selected {
            return ChatKit.asset(color: "outgoing_bubble_selected")
        } else {
            return ChatKit.asset(color: "outgoing_bubble")
        }
    }
    
    public func showAvatar() -> Bool {
        return _thread.threadType() != .private1to1
    }
    
    public func bundle() -> Bundle {
        return Bundle(for: MessagesModel.self)
    }

    public func notifySelectionChanged() {
        _onSelectionChange?(selectedMessages())
    }
    
    public func toggleSelection(_ message: Message) {
        message.toggleSelected()
        notifySelectionChanged()
    }
    
    public func setSelectionChangeListener(_ listener: @escaping (([Message]) -> Void)) {
        _onSelectionChange = listener
    }

    public func section(for index: Int) -> Section? {
        return _adapter.section(index)
    }
    
    public func setView(_ view: PMessagesView) {
        _view = view
    }
    
    public func loadInitialMessages() {
        let messages = _delegate.initialMessages()
        _ = addMessages(toEnd: messages, updateView: true, animated: false)?.subscribe(onCompleted: { [weak self] in
            self?._view?.scrollToBottom(animated: false, force: true)
        })
    }
    
    public func messageExists(_ message: Message) -> Bool {
        _adapter.message(exists: message)
    }
    
    public func message(for id: String) -> Message? {
        _adapter.message(for: id)
    }
    
    public func adapter() -> MessagesListAdapter {
        _adapter
    }
    
}

extension MessagesModel {

    public func addMessage(toStart message: Message, updateView: Bool = true, animated: Bool = true) -> Completable? {
        _adapter.addMessage(toStart: message)
        if updateView {
            return synchronize(animated)
        }
        return nil
    }

    public func addMessage(toEnd message: Message, updateView: Bool = true, animated: Bool = true, scrollToBottom: Bool = false) -> Completable? {
        _adapter.addMessage(toEnd: message)
        if updateView {
            return synchronize(animated)?.do(onCompleted: { [weak self] in
                if scrollToBottom {
                    self?._view?.scrollToBottom(animated: true, force: message.messageSender().userIsMe())
                }
            })
        }
        return nil
    }

    public func addMessages(toStart messages: [Message], updateView: Bool = true, animated: Bool = true) -> Completable? {
        _adapter.addMessages(toStart: messages)
        if updateView {
            return synchronize(animated)
        }
        return nil
    }

    public func addMessages(toEnd messages: [Message], updateView: Bool = true, animated: Bool = true) -> Completable? {
        _adapter.addMessages(toEnd: messages)
        if updateView {
            return synchronize(animated)
        }
        return nil
    }
    
    public func synchronize(_ animated: Bool) -> Completable? {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Message>()
        
        snapshot.appendSections(_adapter.sections())
        for section in _adapter._sections {
            snapshot.appendItems(section.messages(), toSection: section)
        }
        return _view?.apply(snapshot: snapshot, animated: animated)
    }
    
    public func loadMessages() -> Single<[Message]> {
        return _delegate.loadMessages(with: _adapter.oldestMessage())
    }

//    public func nextItem(_ message: Message) -> NSObject? {
//        if let index = _messages.firstIndex(of: message) {
//            if index < _messages.count - 1 {
//                return _messages[index + 1]
//            }
//        }
//        return nil
//    }
//
//    public func previousItem(_ message: Message) -> NSObject? {
//        if let index = _messages.firstIndex(of: message) {
//            if index > 0 {
//                return _messages[index - 1]
//            }
//         }
//        return nil
//    }


    public func removeMessage(_ message: Message, animated: Bool = true) -> Completable? {
        _adapter.removeMessages([message])
        notifySelectionChanged()
        return synchronize(animated)
    }
    
    public func removeMessages(_ messages: [Message], animated: Bool = true) -> Completable? {
        _adapter.removeMessages(messages)
        notifySelectionChanged()
        return synchronize(animated)
     }
    
    public func updateMessage(id: String, animated: Bool = false) -> Completable? {
        // Get the messages
        if let message = adapter().message(for: id) {
            return _view?.reload(messages: [message], animated: animated)
        }
        return nil
    }
    
}

extension MessagesModel: ChatToolbarDelegate {
    
    public func clearSelection(_ updateView: Bool?, animated: Bool) {
        let selected = selectedMessages()
        for message in selected {
            message.setSelected(false)
        }
        notifySelectionChanged()
        if updateView ?? false {
            _ = _view?.reload(messages: selected, animated: animated).subscribe()
        }
        
    }

    public func selectedMessages() -> [Message] {
        var messages = [Message]()
        for section in _adapter.sections() {
            for message in section.messages() {
                if message.isSelected() {
                    messages.append(message)
                }
            }
        }
        return messages
    }
}

