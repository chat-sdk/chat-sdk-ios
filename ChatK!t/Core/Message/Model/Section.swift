//
//  Section.swift
//  ChatK!t
//
//  Created by ben3 on 21/04/2021.
//

import Foundation

open class Section {
        
    let _date: Date
    
    // Messages with date ascending
    var _messages = [AbstractMessage]()
    var _messagesIndex = [String: AbstractMessage]()

    public init(date: Date) {
        _date = date
    }
    
    open func message(for indexPath: IndexPath) -> AbstractMessage? {
        if isValid(indexPath) {
            return _messages[indexPath.row]
        }
        return nil
    }
        
    open func message(for id: String) -> AbstractMessage? {
        for message in _messages {
            if message.messageId() == id {
                return message
            }
        }
        return nil
    }
    
    open func isValid(_ indexPath: IndexPath) -> Bool {
        indexPath.row < _messages.count
    }

    open func exists(_ message: AbstractMessage) -> Bool {
        _messagesIndex[message.messageId()] != nil
    }

    open func addToIndex(_ message: AbstractMessage) {
        _messagesIndex[message.messageId()] = message
    }

    open func addMessage(toStart message: AbstractMessage) {
        if !exists(message) {
            _messages.insert(message, at: 0)
            addToIndex(message)
        }
    }
    
    open func removeMessage(_ message: AbstractMessage) {
        if let i = index(of: message) {
            _messages.remove(at: i)
        }
    }
    
    open func index(of message: AbstractMessage) -> Int? {
        return _messages.firstIndex(of: message)
    }

    open func addMessage(toEnd message: AbstractMessage) {
        if !exists(message) {
            _messages.append(message)
            addToIndex(message)
        }
    }
    
    open func isEmpty() -> Bool {
        return _messages.isEmpty
    }
    
    open func addMessage(message: AbstractMessage) {
        if !exists(message) {
            _messages.append(message)
            addToIndex(message)
            sort()
        }
    }
    
    open func sort() {
        _messages.sort {
            $0.messageDate().compare($1.messageDate()) == .orderedAscending
        }
    }
    
    open func date() -> Date {
        _date
    }
    
    open func messageCount() -> Int {
        return _messages.count
    }
    
    open func messages() -> [AbstractMessage] {
        return _messages
    }

    public func removeAll() {
        _messages.removeAll()
        _messagesIndex.removeAll()
    }
}

extension Section: Hashable {

    public static func == (lhs: Section, rhs: Section) -> Bool {
        return lhs.date() == rhs.date()
    }

    open func hash(into hasher: inout Hasher) {
        hasher.combine(date().hashValue)
    }
    
}
