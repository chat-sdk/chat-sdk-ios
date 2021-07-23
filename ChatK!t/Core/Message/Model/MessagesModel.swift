//
//  ChatViewModel.swift
//  AFNetworking
//
//  Created by ben3 on 18/07/2020.
//

import Foundation
import RxSwift

public protocol MessagesModelDelegate {
    
    var model: ChatModel? {
        get set
    }
    
    // Need to be with the oldest message first
    func loadMessages(with oldestMessage: AbstractMessage?) -> Single<[AbstractMessage]>

    // Need to be with the oldest message last
    func initialMessages() -> [AbstractMessage]
    
    func onClick(_ message: AbstractMessage) -> Bool
}

public class MessagesModel {
    
    public let thread: Thread
    public let delegate: MessagesModelDelegate
    public let messageTimeFormatter = DateFormatter()
            
    public var onSelectionChange: (([AbstractMessage]) -> Void)?
    public var sectionNib: UINib? = ChatKit.provider().sectionNib()
    
    public var messageCellRegistrationsMap = [String: MessageCellRegistration]()
    public var view: PMessagesView?
    
    public var adapter = MessagesListAdapter()
    
    public init(_ thread: Thread, delegate: MessagesModelDelegate) {
        self.thread = thread
        self.delegate = delegate
        messageTimeFormatter.setLocalizedDateFormatFromTemplate(ChatKit.config().timeFormat)
    }
            
    public func registerMessageCell(registration: MessageCellRegistration) {
        messageCellRegistrationsMap[registration.messageType] = registration
    }

    public func registerMessageCells(registrations: [MessageCellRegistration]) {
        for registration in registrations {
            registerMessageCell(registration: registration)
        }
    }
    
    public func cellRegistration(_ messageType: String) -> MessageCellRegistration? {
        return messageCellRegistrationsMap[messageType]
    }

    public func messageCellRegistrations() -> [MessageCellRegistration] {
        return messageCellRegistrationsMap.map { $1 }
    }
        
    public func sectionIdentifier() -> String {
        return SectionCell.identifier
    }

    public func avatarSize() -> CGFloat {
        return 34
    }
    
    public func bubbleColor(_ message: AbstractMessage) -> UIColor {
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
    
    public func onClick(_ message: AbstractMessage) -> Bool {
        return delegate.onClick(message)
    }
    
    public func showAvatar() -> Bool {
        return thread.threadType() != .private1to1
    }
    
    public func bundle() -> Bundle {
        return Bundle(for: MessagesModel.self)
    }

    public func notifySelectionChanged() {
        onSelectionChange?(selectedMessages())
    }
    
    public func toggleSelection(_ message: AbstractMessage) {
        message.toggleSelected()
        notifySelectionChanged()
    }
    
    public func setSelectionChangeListener(_ listener: @escaping (([Message]) -> Void)) {
        onSelectionChange = listener
    }

    public func section(for index: Int) -> Section? {
        return adapter.section(index)
    }
        
    public func loadInitialMessages() {
        let messages = delegate.initialMessages()
        _ = addMessages(toEnd: messages, updateView: true, animated: false).subscribe()
    }
    
    public func messageExists(_ message: AbstractMessage) -> Bool {
        adapter.message(exists: message)
    }
    
    public func message(for id: String) -> AbstractMessage? {
        adapter.message(for: id)
    }
        
}

extension MessagesModel {

    public func addMessage(toStart message: AbstractMessage, updateView: Bool = true, animated: Bool = true) -> Completable {
        return Completable.deferred({ [weak self] in
            self?.adapter.addMessage(toStart: message)
            if updateView, let completable = self?.synchronize(animated) {
                return completable
            }
            return Completable.empty()
        })
    }

    public func addMessage(toEnd message: AbstractMessage, updateView: Bool = true, animated: Bool = true, scrollToBottom: Bool = false) -> Completable {
        return Completable.deferred({ [weak self] in
            self?.adapter.addMessage(toEnd: message)
            if updateView {
                // Get the offset
                let offset = self?.view?.offsetFromBottom() ?? 0
                let scroll = offset <= ChatKit.config().messagesViewRefreshHeight
                return self?.synchronize(animated).do(onCompleted: { [weak self] in
                    if scrollToBottom {
                        self?.view?.scrollToBottom(animated: animated, force: message.messageSender().userIsMe() || scroll)
                    }
                }) ?? Completable.empty()
            }
            return Completable.empty()
        })
    }

    public func addMessages(toStart messages: [AbstractMessage], updateView: Bool = true, animated: Bool = true) -> Completable {
        return Completable.deferred({ [weak self] in
            self?.adapter.addMessages(toStart: messages)
            if updateView, let completable = self?.synchronize(animated) {
                return completable
            }
            return Completable.empty()
        })
    }

    public func addMessages(toEnd messages: [AbstractMessage], updateView: Bool = true, animated: Bool = true) -> Completable {
        return Completable.deferred({ [weak self] in
            self?.adapter.addMessages(toEnd: messages)
            if updateView, let completable = self?.synchronize(animated) {
                return completable
            }
            return Completable.empty()
        })
    }
    
    public func loadMessages() -> Single<[AbstractMessage]> {
        return delegate.loadMessages(with: adapter.oldestMessage())
    }

    public func removeMessage(_ message: AbstractMessage, animated: Bool = true) -> Completable {
        return Completable.deferred({ [weak self] in
            self?.adapter.removeMessages([message])
            self?.notifySelectionChanged()
            return self?.synchronize(animated) ?? Completable.empty()
        })
    }
    
    public func removeMessages(_ messages: [AbstractMessage], animated: Bool = true) -> Completable {
        return Completable.deferred({ [weak self] in
            self?.adapter.removeMessages(messages)
            self?.notifySelectionChanged()
            return self?.synchronize(animated) ?? Completable.empty()
        })
     }
    
    public func synchronize(_ animated: Bool) -> Completable {
        return Completable.deferred({ [weak self] in
            var snapshot = NSDiffableDataSourceSnapshot<Section, AbstractMessage>()
            if let adapter = self?.adapter {
                snapshot.appendSections(adapter.sections())
                for section in adapter._sections {
                    snapshot.appendItems(section.messages(), toSection: section)
                }
            }
            return self?.view?.apply(snapshot: snapshot, animated: animated) ?? Completable.empty()
        })
    }
    
    public func updateMessage(id: String, animated: Bool = false) -> Completable {
        return Completable.deferred({ [weak self] in
            // Get the messages
            if let message = self?.adapter.message(for: id), let completable = self?.view?.reload(messages: [message], animated: animated) {
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
            _ = view?.reload(messages: selected, animated: animated).subscribe()
        }
    }

    public func selectedMessages() -> [AbstractMessage] {
        var messages = [AbstractMessage]()
        for section in adapter.sections() {
            for message in section.messages() {
                if message.isSelected() {
                    messages.append(message)
                }
            }
        }
        return messages
    }
}

