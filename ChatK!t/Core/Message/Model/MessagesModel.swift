//
//  ChatViewModel.swift
//  AFNetworking
//
//  Created by ben3 on 18/07/2020.
//

import Foundation
import RxSwift

public protocol ChatModelDelegate: class {
    
    var model: ChatModel? {
        get set
    }
    
    // Need to be with the oldest message first
    func loadMessages(with oldestMessage: AbstractMessage?) -> Single<[AbstractMessage]>

    // Need to be with the oldest message last
    func initialMessages() -> [AbstractMessage]
    
    func onClick(_ message: AbstractMessage) -> Bool
}

open class MessagesModel {
    
    public let conversation: Conversation
    open weak var delegate: ChatModelDelegate?
    public let messageTimeFormatter = DateFormatter()
            
    open var onSelectionChange: (([AbstractMessage]) -> Void)?
    open var sectionNib: UINib? = ChatKit.provider().sectionNib()
    
    open var messageCellRegistrationsMap = [String: MessageCellRegistration]()
    open weak var view: PMessagesView?
    
    open var adapter = MessagesListAdapter()
    
    public init(_ conversation: Conversation) {
        self.conversation = conversation
        messageTimeFormatter.setLocalizedDateFormatFromTemplate(ChatKit.config().timeFormat)
    }
    
    open func setDelegate(_ delegate: ChatModelDelegate) {
        self.delegate = delegate
    }
            
    open func registerMessageCell(registration: MessageCellRegistration) {
        messageCellRegistrationsMap[registration.messageType] = registration
    }

    open func registerMessageCells(registrations: [MessageCellRegistration]) {
        for registration in registrations {
            registerMessageCell(registration: registration)
        }
    }
    
    open func cellRegistration(_ messageType: String) -> MessageCellRegistration? {
        return messageCellRegistrationsMap[messageType]
    }

    open func messageCellRegistrations() -> [MessageCellRegistration] {
        return messageCellRegistrationsMap.map { $1 }
    }
        
    open func sectionIdentifier() -> String {
        return SectionCell.identifier
    }

    open func avatarSize() -> CGFloat {
        return 34
    }
    
    open func bubbleColor(_ message: AbstractMessage) -> UIColor {
        switch message.messageDirection() {
        case .incoming:
            return incomingBubbleColor(selected: message.isSelected())
        case .outgoing:
            return outgoingBubbleColor(selected: message.isSelected())
        }
    }
    
    open func incomingBubbleColor(selected: Bool = false) -> UIColor {
        if selected {
            return ChatKit.asset(color: ChatKit.config().incomingBubbleSelectedColor)
        } else {
            return ChatKit.asset(color: ChatKit.config().incomingBubbleColor)
        }
    }

    open func outgoingBubbleColor(selected: Bool = false) -> UIColor {
        if selected {
            return ChatKit.asset(color: ChatKit.config().outgoingBubbleSelectedColor)
        } else {
            return ChatKit.asset(color: ChatKit.config().outgoingBubbleColor)
        }
    }
    
    open func onClick(_ message: AbstractMessage) -> Bool {
        return delegate?.onClick(message) ?? false
    }
    
    open func showAvatar() -> Bool {
        return conversation.conversationType() != .private1to1
    }
    
    open func bundle() -> Bundle {
        return Bundle(for: MessagesModel.self)
    }

    open func notifySelectionChanged() {
        onSelectionChange?(selectedMessages())
    }
    
    open func toggleSelection(_ message: AbstractMessage) {
        message.toggleSelected()
        notifySelectionChanged()
    }
    
    open func setSelectionChangeListener(_ listener: @escaping (([Message]) -> Void)) {
        onSelectionChange = listener
    }

    open func section(for index: Int) -> Section? {
        return adapter.section(index)
    }
        
    open func loadInitialMessages() {
        if let messages = delegate?.initialMessages() {
            _ = addMessages(toEnd: messages, updateView: true, animated: false).subscribe()
        }
    }
    
    open func messageExists(_ message: AbstractMessage) -> Bool {
        adapter.message(exists: message)
    }
    
    open func message(for id: String) -> AbstractMessage? {
        adapter.message(for: id)
    }
        
}

extension MessagesModel {

    open func addMessage(toStart message: AbstractMessage, updateView: Bool = true, animated: Bool = true) -> Completable {
        return Completable.deferred({ [weak self] in
            self?.adapter.addMessage(toStart: message)
            if updateView, let completable = self?.synchronize(animated) {
                return completable
            }
            return Completable.empty()
        })
    }

    open func addMessage(toEnd message: AbstractMessage, updateView: Bool = true, animated: Bool = true, scrollToBottom: Bool = false) -> Completable {
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

    open func addMessages(toStart messages: [AbstractMessage], updateView: Bool = true, animated: Bool = true) -> Completable {
        return Completable.deferred({ [weak self] in
            self?.adapter.addMessages(toStart: messages)
            if updateView, let completable = self?.synchronize(animated) {
                return completable
            }
            return Completable.empty()
        })
    }

    open func addMessages(toEnd messages: [AbstractMessage], updateView: Bool = true, animated: Bool = true) -> Completable {
        return Completable.deferred({ [weak self] in
            self?.adapter.addMessages(toEnd: messages)
            if updateView, let completable = self?.synchronize(animated) {
                return completable
            }
            return Completable.empty()
        })
    }
    
    open func loadMessages() -> Single<[AbstractMessage]> {
        Single.deferred({ [weak self] in
            if let delegate = self?.delegate, let adapter = self?.adapter {
                return delegate.loadMessages(with: adapter.oldestMessage())
            }
            return Single.create(subscribe: { single in
                single(.success([]))
                return Disposables.create()
            })
        })
    }

    open func removeMessage(_ message: AbstractMessage, animated: Bool = true) -> Completable {
        return Completable.deferred({ [weak self] in
            self?.adapter.removeMessages([message])
            self?.notifySelectionChanged()
            return self?.synchronize(animated) ?? Completable.empty()
        })
    }
    
    open func removeMessages(_ messages: [AbstractMessage], animated: Bool = true) -> Completable {
        return Completable.deferred({ [weak self] in
            self?.adapter.removeMessages(messages)
            self?.notifySelectionChanged()
            return self?.synchronize(animated) ?? Completable.empty()
        })
     }

    open func removeAllMessages(animated: Bool = true) -> Completable {
        return Completable.deferred({ [weak self] in
            self?.adapter.removeAllMessages()
            self?.notifySelectionChanged()
            return self?.synchronize(animated) ?? Completable.empty()
        })
     }

    open func synchronize(_ animated: Bool) -> Completable {
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
    
    open func updateMessage(id: String, animated: Bool = false) -> Completable {
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
    
    open func clearSelection(_ updateView: Bool?, animated: Bool) {
        let selected = selectedMessages()
        for message in selected {
            message.setSelected(false)
        }
        notifySelectionChanged()
        if updateView ?? false {
            _ = view?.reload(messages: selected, animated: animated).subscribe()
        }
    }

    open func selectedMessages() -> [AbstractMessage] {
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

