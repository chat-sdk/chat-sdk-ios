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
    
    public func message(for indexPath: IndexPath) -> Message? {
        if isValid(indexPath) {
            return _sections[indexPath.section].message(for: indexPath)
        }
        return nil
    }
    
    public func message(exists message: Message) -> Bool {
        for section in _sections {
            if section.exists(message) {
                return true
            }
        }
        return false
    }
    
    public func sectionExists(_ section: Section) -> Bool {
//        return _sections.contains(section)
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

    public func indexPath(for message: Message) -> IndexPath? {
        if let s = section(for: message), let section = index(of: s), let row = s.index(for: message) {
            return IndexPath(row: row, section: section)
        }
        return nil
    }

    public func isValid(_ indexPath: IndexPath) -> Bool {
        indexPath.section < _sections.count
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
    
    public func addSection(for message: Message) -> Int? {
        if let day = message.messageDate().day(), _sectionsIndex[day] == nil {
            let section = Section(date: day)
            _sections.append(section)
            _sectionsIndex[day] = section
            sort()
            return _sections.firstIndex(of: section)
        }
        return nil
    }

    public func addSections(for messages: [Message]) -> [Int] {
        var sections = [Int]()
        for message in messages {
            if let section = addSection(for: message) {
                sections.append(section)
            }
        }
        return sections
    }
    
    public func addMessage(_ message: Message) -> IndexPath? {
        if let section = section(for: message), let index = _sections.firstIndex(of: section), let row = section.addMessage(message: message) {
            return IndexPath(row: row, section: index)
        }
        return nil
    }

    public func addMessages(_ messages: [Message]) -> TableUpdate {
        let update = TableUpdate(.add)
        update.sections = addSections(for: messages)
        for message in messages {
            if let indexPath = addMessage(message) {
                update.add(indexPath: indexPath)
            }
        }
        return update
    }

    public func addMessages(toStart messages: [Message]) -> TableUpdate {
        let update = TableUpdate(.add)
        update.sections = addSections(for: messages)
        
        for message in messages {
            if let indexPath = addMessage(toStart: message) {
                update.add(indexPath: indexPath)
            }
        }
        return update
    }
    
    public func addMessage(toStart message: Message) -> IndexPath? {
        if let section = section(for: message), let index = _sections.firstIndex(of: section), let row = section.addMessage(toStart: message) {
            return IndexPath(row: row, section: index)
        }
        return nil
    }
    
    public func removeMessages(_ messages: [Message]) -> TableUpdate {
        let update = TableUpdate(.remove)
        
        // First get the index paths of all the messages
        var indexPaths = [String: IndexPath]()

        for message in messages {
            indexPaths[message.messageId()] = indexPath(for: message)
        }
        
        for message in messages {
            if let section = section(for: message), let i = index(of: section), let _ = section.removeMessage(message), let ip = indexPaths[message.messageId()] {
                update.add(indexPath: ip)
                if section.isEmpty() {
                    _sections.remove(at: i)
                    update.add(section: ip.section)
                }
            }
        }
        return update
    }
    
    public func addMessages(toEnd messages: [Message]) -> TableUpdate {
        let update = TableUpdate(.add)
        update.sections = addSections(for: messages)
        
        for message in messages {
            if let indexPath = addMessage(toEnd: message) {
                update.add(indexPath: indexPath)
            }
        }
        return update
    }

    public func addMessage(toEnd message: Message) -> IndexPath? {
        if let section = section(for: message), let index = _sections.firstIndex(of: section), let row = section.addMessage(toEnd: message) {
            return IndexPath(row: row, section: index)
        }
        return nil
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
}

public class TableUpdate {
    
    public enum UpdateType {
        case add
        case remove
        case update
    }
    
    var indexPaths = [IndexPath]()
    var sections = [Int]()
    let type: UpdateType
    var animation: UITableView.RowAnimation = .none
    
    init(_ type: UpdateType) {
        self.type = type
    }
    
    public func add(indexPath: IndexPath) {
        if !indexPaths.contains(indexPath) {
            indexPaths.append(indexPath)
        }
    }

    public func add(section: Int) {
        if !sections.contains(section) {
            sections.append(section)
        }
    }
    
    public func log() {
        print("Type: ", type)
        print("sections: ", sections)
        print("indexPaths: ", indexPaths)
    }
    
    public func hasChanges() -> Bool {
        return hasRowChanges() || hasSectionChanges()
    }

    public func hasSectionChanges() -> Bool {
        return !sections.isEmpty
    }

    public func hasRowChanges() -> Bool {
        return !indexPaths.isEmpty
    }

}

