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
    
    public func message(exists message: AbstractMessage) -> Bool {
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
    
    public func message(for id: String) -> AbstractMessage? {
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
    
    public func section(for message: AbstractMessage) -> Section? {
        if let day = message.messageDate().day() {
            return _sectionsIndex[day]
        }
        return nil
    }
    
    public func addSection(for message: AbstractMessage) -> Section? {
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
    
    public func addMessage(_ message: AbstractMessage) {
        if let section = addSection(for: message) {
            section.addMessage(message: message)
        }
    }

    public func addMessages(_ messages: [AbstractMessage]) {
        for message in messages {
            addMessage(message)
        }
    }

    public func addMessages(toStart messages: [AbstractMessage]) {
        for message in messages {
            addMessage(toStart: message)
        }
    }
    
    public func addMessage(toStart message: AbstractMessage) {
        if let section = addSection(for: message) {
            section.addMessage(toStart: message)
        }
    }
    
    public func addMessages(toEnd messages: [AbstractMessage]) {
        for message in messages {
            addMessage(toEnd: message)
        }
    }
    
    public func addMessage(toEnd message: AbstractMessage) {
        if let section = addSection(for: message) {
            section.addMessage(toEnd: message)
        }
    }
    
    public func oldestMessage() -> AbstractMessage? {
        return _sections.first?.messages().first
    }
    
    public func removeMessages(_ messages: [AbstractMessage]) {
        var sectionsToRemove = [Section]()
        for message in messages {
            if let section = section(for: message) {
                section.removeMessage(message)
                if section.isEmpty() {
                    sectionsToRemove.append(section)
                }
            }
        }
        for section in sectionsToRemove {
            removeSection(section)
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
    
    public func indexPath(for message: AbstractMessage) -> IndexPath? {
        if let section = section(for: message), let index = index(of: section), let row = section.index(of: message) {
            return IndexPath(row: row, section: index)
        }
        return nil
    }
    
    public func message(for indexPath: IndexPath) -> AbstractMessage? {
        return section(indexPath.section)?.message(for: indexPath)
    }
    
}

