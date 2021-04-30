//
//  Section.swift
//  ChatK!t
//
//  Created by ben3 on 21/04/2021.
//

import Foundation

public class Section: NSObject {
        
    let _date: Date
    
    // Messages with date ascending
    var _messages = [Message]()
    var _messagesIndex = [String: Message]()

    public init(date: Date) {
        _date = date
    }
    
    public func message(for indexPath: IndexPath) -> Message? {
        if isValid(indexPath) {
            return _messages[indexPath.row]
        }
        return nil
    }
        
    public func message(for id: String) -> Message? {
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

    public func exists(_ message: Message) -> Bool {
        _messagesIndex[message.messageId()] != nil
    }

    public func addMessage(toIndex: Message) {
        _messagesIndex[toIndex.messageId()] = toIndex
    }

    public func addMessage(toStart: Message) -> Int? {
        if !exists(toStart) {
            _messages.insert(toStart, at: 0)
            addMessage(toIndex: toStart)
            return _messages.count - 1
        }
        return nil
    }
    
    public func removeMessage(_ message: Message) -> Int? {
        if let i = index(for: message) {
            _messages.remove(at: i)
            return i
        }
        return nil
    }
    
    public func index(for message: Message) -> Int? {
        return _messages.firstIndex {
            $0.messageId() == message.messageId()
        }
    }

    public func addMessage(toEnd: Message) -> Int? {
        if !exists(toEnd) {
            _messages.append(toEnd)
            addMessage(toIndex: toEnd)
            return _messages.count - 1
        }
        return nil
    }
    
    public func isEmpty() -> Bool {
        return _messages.isEmpty
    }
    
    public func addMessage(message: Message) -> Int? {
        if !exists(message) {
            _messages.append(message)
            addMessage(toIndex: message)
            sort()
            return index(for: message)
        }
        return nil
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



}
