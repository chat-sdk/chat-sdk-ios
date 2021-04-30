//
//  ChatViewModel.swift
//  AFNetworking
//
//  Created by ben3 on 18/07/2020.
//

import Foundation

public class MessagesModel: NSObject, UITableViewDataSource {
    
    public let _thread: Thread
    public let _messageTimeFormatter = DateFormatter()
    
//    public var _messages = [Message]()
    public var _selectedIndexPaths: Set<IndexPath> = []
        
    public var _onSelectionChange: (([Message]) -> Void)?
    public var _sectionNib: UINib? = ChatKit.provider().sectionNib()
    
    public var _messageCellRegistrations = [String: MessageCellRegistration]()
    public var _view: PMessagesView?
    
    public  var _messageListAdapter = MessagesListAdapter()
    
    public init(_ thread: Thread) {
        _thread = thread
        _messageTimeFormatter.setLocalizedDateFormatFromTemplate(ChatKit.config().timeFormat)
        
        super.init()
        

    }
    
    public func messageTimeFormatter() -> DateFormatter {
        return _messageTimeFormatter
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return _messageListAdapter.sectionCount()
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _messageListAdapter.section(section)?.messageCount() ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let message = _messageListAdapter.message(for: indexPath) {
            var cell: MessageCell?
            // Get the registration so we know which cell identifier to use
            if let registration = _messageCellRegistrations[message.messageType()] {
                let identifier = registration.identifier(direction: message.messageDirection())
                
                cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? MessageCell
                cell?.setContent(content: registration.content(direction: message.messageDirection()))
                cell?.bind(message: message, model: self, selected: _selectedIndexPaths.contains(indexPath))
                return cell!
            }
        }
        return UITableViewCell()
    }
    
    public func registerMessageCell(registration: MessageCellRegistration) {
        _messageCellRegistrations[registration.messageType()] = registration
    }

    public func registerMessageCells(registrations: [MessageCellRegistration]) {
        for registration in registrations {
            registerMessageCell(registration: registration)
        }
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
        return 44
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

    public func selectionChanged(paths: Set<IndexPath>) {
        _selectedIndexPaths = paths
        _onSelectionChange?(selectedMessages())
    }
    
    public func section(for index: Int) -> Section? {
        return _messageListAdapter.section(index)
    }
    
    public func setView(_ view: PMessagesView) {
        _view = view
    }
    
    public func loadMessages() {
        let messages = _thread.threadMessages()
        addMessages(toEnd: messages, notify: false)
        _view?.reloadData()
        _view?.scrollToBottom(animated: false, force: true)
    }
    
    public func messageExists(_ message: Message) -> Bool {
        _messageListAdapter.message(exists: message)
    }
    
    public func message(for id: String) -> Message? {
        _messageListAdapter.message(for: id)
    }
    
}

extension MessagesModel {

    public func addMessage(toStart message: Message, notify: Bool = true) {
        addMessages(toStart: [message], notify: notify)
    }

    public func addMessage(toEnd message: Message, notify: Bool = true) {
        addMessages(toEnd: [message], notify: notify)
        _view?.scrollToBottom(animated: true, force: message.messageSender().userIsMe())
    }

    public func addMessages(toStart messages: [Message], notify: Bool = true) {
        let update = _messageListAdapter.addMessages(toStart: messages)
        if notify {
            _view?.updateTable(update, completion: nil)
        }
    }

    public func addMessages(toEnd messages: [Message], notify: Bool = true) {
        let update = _messageListAdapter.addMessages(toEnd: messages)
        if notify {
            _view?.updateTable(update, completion: nil)
        }
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
//        }
//        return nil
//    }


    public func removeMessage(_ message: Message) {
    }
    
    public func removeMessages(_ messages: [Message]) {
        let update = _messageListAdapter.removeMessages(messages)
        update.animation = .fade
        _view?.updateTable(update, completion: nil)
    }
    
    public func updateMessage(_ message: Message) {
        if let indexPath = _messageListAdapter.indexPath(for: message)  {
            let update = TableUpdate(.update)
            update.add(indexPath: indexPath)
            _view?.updateTable(update, completion: nil)
        }
    }
}

extension MessagesModel: ChatToolbarDelegate {

    public func clearSelection() {
        _view?.clearSelection()
    }
    
    public func selectedMessages() -> [Message] {
        var messages = [Message]()
        
        for path in _selectedIndexPaths {
            if let message = _messageListAdapter.message(for: path) {
                messages.append(message)
            }
        }

        return messages
    }
}

