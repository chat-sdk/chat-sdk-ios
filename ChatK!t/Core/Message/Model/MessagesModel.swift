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

    public func avatarSize() -> CGFloat {
        return 34
    }
    
    public func bubbleColor(_ message: Message) -> UIColor {
        switch message.messageDirection() {
        case .incoming:
            return incomingBubbleColor(selected: message.isSelected())
        case .outgoing:
            return outgoingBubbleColor(selected: message.isSelected())
        }
    }
    
    public func incomingBubbleColor(selected: Bool = false) -> UIColor {
        if selected {
            return ChatKit.asset(color: ChatKit.config().incomingBubbleSelectedColor)
        } else {
            return ChatKit.asset(color: ChatKit.config().incomingBubbleColor)
        }
    }

    public func outgoingBubbleColor(selected: Bool = false) -> UIColor {
        if selected {
            return ChatKit.asset(color: ChatKit.config().outgoingBubbleSelectedColor)
        } else {
            return ChatKit.asset(color: ChatKit.config().outgoingBubbleColor)
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
        _ = addMessages(toEnd: messages, updateView: true, animated: false).subscribe(onCompleted: { [weak self] in
//            self?._view?.layout()
//            self?._view?.scrollToBottom(animated: false, force: true)
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

    public func addMessage(toStart message: Message, updateView: Bool = true, animated: Bool = true) -> Completable {
        return Completable.deferred({ [weak self] in
            self?._adapter.addMessage(toStart: message)
            if updateView, let completable = self?.synchronize(animated) {
                return completable
            }
            return Completable.empty()
        })
    }

    public func addMessage(toEnd message: Message, updateView: Bool = true, animated: Bool = true, scrollToBottom: Bool = false) -> Completable {
        return Completable.deferred({ [weak self] in
            self?._adapter.addMessage(toEnd: message)
            if updateView {
                return self?.synchronize(animated).do(onCompleted: { [weak self] in
                    if scrollToBottom {
                        self?._view?.scrollToBottom(animated: animated, force: message.messageSender().userIsMe())
                    }
                }) ?? Completable.empty()
            }
            return Completable.empty()
        })
    }

    public func addMessages(toStart messages: [Message], updateView: Bool = true, animated: Bool = true) -> Completable {
        return Completable.deferred({ [weak self] in
            self?._adapter.addMessages(toStart: messages)
            if updateView, let completable = self?.synchronize(animated) {
                return completable
            }
            return Completable.empty()
        })
    }

    public func addMessages(toEnd messages: [Message], updateView: Bool = true, animated: Bool = true) -> Completable {
        return Completable.deferred({ [weak self] in
            self?._adapter.addMessages(toEnd: messages)
            if updateView, let completable = self?.synchronize(animated) {
                return completable
            }
            return Completable.empty()
        })
    }
    
    public func loadMessages() -> Single<[Message]> {
        return _delegate.loadMessages(with: _adapter.oldestMessage())
    }

    public func removeMessage(_ message: Message, animated: Bool = true) -> Completable {
        return Completable.deferred({ [weak self] in
            self?._adapter.removeMessages([message])
            self?.notifySelectionChanged()
            return self?.synchronize(animated) ?? Completable.empty()
        })
    }
    
    public func removeMessages(_ messages: [Message], animated: Bool = true) -> Completable {
        return Completable.deferred({ [weak self] in
            self?._adapter.removeMessages(messages)
            self?.notifySelectionChanged()
            return self?.synchronize(animated) ?? Completable.empty()
        })
     }
    
    public func synchronize(_ animated: Bool) -> Completable {
        return Completable.deferred({ [weak self] in
            var snapshot = NSDiffableDataSourceSnapshot<Section, Message>()
            if let adapter = self?._adapter {
                snapshot.appendSections(adapter.sections())
                for section in adapter._sections {
                    snapshot.appendItems(section.messages(), toSection: section)
                }
            }
            return self?._view?.apply(snapshot: snapshot, animated: animated) ?? Completable.empty()
        })
    }
    
    public func updateMessage(id: String, animated: Bool = false) -> Completable {
        return Completable.deferred({ [weak self] in
            // Get the messages
            if let message = self?.adapter().message(for: id), let completable = self?._view?.reload(messages: [message], animated: animated) {
                return completable
            }
            return Completable.empty()
        })
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

