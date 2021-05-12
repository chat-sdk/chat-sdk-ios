//
//  MessagesListAdapter.swift
//  ChatK!t
//
//  Created by ben3 on 23/04/2021.
//

import Foundation

public class MessagesListAdapter {
    
    var _sections = [Section]()
    var _sectionsIndex = [Date: Section]()
    
    public func message(exists message: Message) -> Bool {
        for section in _sections {
            if section.exists(message) {
                return true
            }
        }
        return false
    }
    
    public func sectionExists(_ section: Section) -> Bool {
        return _sectionsIndex[section.date()] != nil
    }
    
    public func message(for id: String) -> Message? {
        for section in _sections {
            if let message = section.message(for: id) {
                return message
            }
        }
        return nil
    }
    
    public func sectionCount() -> Int {
        _sections.count
    }
    
    public func section(for message: Message) -> Section? {
        if let day = message.messageDate().day() {
            return _sectionsIndex[day]
        }
        return nil
    }
    
    public func addSection(for message: Message) -> Section? {
        if let day = message.messageDate().day() {
            if let section = _sectionsIndex[day] {
                return section
            } else {
                let section = Section(date: day)
                _sections.append(section)
                _sectionsIndex[day] = section
                sort()
                return section
            }
        }
        return nil
    }
    
    public func addMessage(_ message: Message) {
        if let section = addSection(for: message) {
            section.addMessage(message: message)
        }
    }

    public func addMessages(_ messages: [Message]) {
        for message in messages {
            addMessage(message)
        }
    }

    public func addMessages(toStart messages: [Message]) {
        for message in messages {
            addMessage(toStart: message)
        }
    }
    
    public func addMessage(toStart message: Message) {
        if let section = addSection(for: message) {
            section.addMessage(toStart: message)
        }
    }
    
    public func addMessages(toEnd messages: [Message]) {
        for message in messages {
            addMessage(toEnd: message)
        }
    }
    
    public func addMessage(toEnd message: Message) {
        if let section = addSection(for: message) {
            section.addMessage(toEnd: message)
        }
    }
    
    public func oldestMessage() -> Message? {
        return _sections.first?.messages().first
    }
    
    public func removeMessages(_ messages: [Message]) {
        for message in messages {
            if let section = section(for: message) {
                section.removeMessage(message)
            }
        }
    }
    
    public func removeSection(_ section: Section) {
        if let index = _sections.firstIndex(of: section) {
            _sections.remove(at: index)
            if let day = section.date().day() {
                _sectionsIndex.removeValue(forKey: day)
            }
        }
    }
    
    public func sort() {
        _sections.sort {
            $0.date().compare($1.date()) == .orderedAscending
        }
    }
    
    public func section(_ index: Int) -> Section? {
        if index < _sections.count {
            return _sections[index]
        }
        return nil
    }
    
    public func index(of section: Section) -> Int? {
        return _sections.firstIndex(of: section)
    }
    
    public func sections() -> [Section] {
        return _sections
    }
    
    public func indexPath(for message: Message) -> IndexPath? {
        if let section = section(for: message), let index = index(of: section), let row = section.index(of: message) {
            return IndexPath(row: row, section: index)
        }
        return nil
    }
    
    public func message(for indexPath: IndexPath) -> Message? {
        return section(indexPath.section)?.message(for: indexPath)
    }
    
}

