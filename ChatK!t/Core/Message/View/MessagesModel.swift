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
    
    public var _items = [NSObject]()
    public var _selectedIndexPaths: Set<IndexPath> = []
        
    public var _onSelectionChange: (([Message]) -> Void)?
    public var _sectionNib: UINib? = ChatKit.provider().sectionNib()
    
    public var _messageCellRegistrations = [String: MessageCellRegistration]()
    public var _view: PMessagesView?
    
    public init(thread: Thread) {
        _thread = thread
        _messageTimeFormatter.setLocalizedDateFormatFromTemplate(ChatKit.config().timeFormat)

        for message in _thread.threadMessages() {
            _items.append(message)
        }
    }
    
//     public func itemCount() -> Int {
//        return _thread.threadMessages().count
//    }
    
//     public func message(indexPath: IndexPath) -> Message {
//        return _thread.threadMessages()[indexPath.row]
//    }
    
    public func messageTimeFormatter() -> DateFormatter {
        return _messageTimeFormatter
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _items.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // Get the message
        if let message = _items[indexPath.row] as? Message {
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
        if let section = _items[indexPath.row] as? Section {
            var cell: SectionCell?
            
            return cell!
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
    
    public func selectedMessages() -> [Message] {
        var messages = [Message]()
        
        for path in _selectedIndexPaths {
            if let message = _items[path.row] as? Message {
                messages.append(message)
            }
        }

        return messages
    }
    
    public func isSameDay(m1: Message, m2: Message) -> Bool {
        return Calendar.current.isDate(m1.messageDate(), inSameDayAs: m2.messageDate())
    }
    
    public func copyToClipboard() {
        
        let formatter = DateFormatter()
        formatter.dateFormat = ChatKit.config().messageHistoryTimeFormat
        
        var text = ""
        
        for message in selectedMessages() {
            text += String(format: "%@ - %@ %@\n", formatter.string(from: message.messageDate()), message.messageSender().userName(), message.messageText() ?? "")
        }
        
        UIPasteboard.general.string = text
        
    }
    
    public func setView(_ view: PMessagesView) {
        _view = view
    }
    
    public func messageExists(_ message: Message) -> Bool {
        return self._items.firstIndex(of: message) != nil
    }
    
    public func message(for id: String) -> Message? {
        for item in _items {
            if let m = item as? Message, m.messageId() == id {
                return m
            }
        }
        return nil
    }
    
}

extension MessagesModel {

    public func addMessage(toStart: Message) {
        if !messageExists(toStart) {
            // Check to see if the next message 
            
            _items.insert(toStart, at: 0)
            let indexPath = IndexPath(row: 0, section: 0)
            _view?.insertItems(at: [indexPath], completion: nil)
        }
    }
    
    public func nextItem(_ message: Message) -> NSObject? {
        if let index = _items.firstIndex(of: message) {
            if index < _items.count - 1 {
                return _items[index + 1]
            }
        }
        return nil
    }

    public func previousItem(_ message: Message) -> NSObject? {
        if let index = _items.firstIndex(of: message) {
            if index > 0 {
                return _items[index - 1]
            }
        }
        return nil
    }

    public func addMessage(toEnd: Message) {
        if !messageExists(toEnd) {
            _items.append(toEnd)
            let indexPath = IndexPath(row: _items.count - 1, section: 0)
            _view?.insertItems(at: [indexPath], completion: { [weak self] success in
                if success {
                    self?._view?.scrollToBottom(animated: true, force: toEnd.messageSender().userIsMe())
                }
            })
        }
    }
    
    public func addMessages(toStart: [Message]) {
    }
    
    public func addMessages(toEnd: [Message]) {
    }
    
    public func removeMessage(_message: Message) {
    }
    
    public func removeMessages(_message: [Message]) {
    }
    
    public func updateMessage(_ id: String) {
        if let message = message(for: id), let index = _items.firstIndex(of: message) {
            let indexPath = IndexPath(row: index, section: 0)
            _view?.updateItems(at: [indexPath], completion: nil)
        }
    }
}

