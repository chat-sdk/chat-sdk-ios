//
//  Section.swift
//  ChatK!t
//
//  Created by ben3 on 21/04/2021.
//

import Foundation

public class Section {
        
    let _date: Date
    
    // Messages with date ascending
    var _messages = [AbstractMessage]()
    var _messagesIndex = [String: AbstractMessage]()

    public init(date: Date) {
        _date = date
    }
    
    public func message(for indexPath: IndexPath) -> AbstractMessage? {
        if isValid(indexPath) {
            return _messages[indexPath.row]
        }
        return nil
    }
        
    public func message(for id: String) -> AbstractMessage? {
        for message in _messages {
            if message.messageId() == id {
                return message
            }
        }
        return nil
    }
    
    public func isValid(_ indexPath: IndexPath) -> Bool {
        indexPath.row < _messages.count
    }

    public func exists(_ message: AbstractMessage) -> Bool {
        _messagesIndex[message.messageId()] != nil
    }

    public func addToIndex(_ message: AbstractMessage) {
        _messagesIndex[message.messageId()] = message
    }

    public func addMessage(toStart message: AbstractMessage) {
        if !exists(message) {
            _messages.insert(message, at: 0)
            addToIndex(message)
        }
    }
    
    public func removeMessage(_ message: AbstractMessage) {
        if let i = index(of: message) {
            _messages.remove(at: i)
        }
    }
    
    public func index(of message: AbstractMessage) -> Int? {
        return _messages.firstIndex(of: message)
    }

    public func addMessage(toEnd message: AbstractMessage) {
        if !exists(message) {
            _messages.append(message)
            addToIndex(message)
        }
    }
    
    public func isEmpty() -> Bool {
        return _messages.isEmpty
    }
    
    public func addMessage(message: AbstractMessage) {
        if !exists(message) {
            _messages.append(message)
            addToIndex(message)
            sort()
        }
    }
    
    public func sort() {
        _messages.sort {
            $0.messageDate().compare($1.messageDate()) == .orderedAscending
        }
    }
    
    public func date() -> Date {
        _date
    }
    
    public func messageCount() -> Int {
        return _messages.count
    }
    
    public func messages() -> [AbstractMessage] {
        return _messages
    }

}

extension Section: Hashable {

    public static func == (lhs: Section, rhs: Section) -> Bool {
        return lhs.date() == rhs.date()
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(date().hashValue)
    }
    
}
