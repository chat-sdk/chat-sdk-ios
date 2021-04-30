//
//  ToolbarAction.swift
//  AFNetworking
//
//  Created by ben3 on 24/04/2021.
//

import Foundation

public class ToolbarAction {
    
    public let barButtonItem: UIBarButtonItem
    public var visibleFor: (([Message]) -> Bool)?
    public let onClick: ([Message]) -> Bool
    public var implOnClick: (() -> Void)?

    public init(item: UIBarButtonItem, visibleFor: (([Message]) -> Bool)? = nil, onClick: @escaping (([Message]) -> Bool)) {
        self.onClick = onClick
        self.visibleFor = visibleFor
        barButtonItem = item
        barButtonItem.target = self
        barButtonItem.action = #selector(click)
    }
    
    @objc public func click() {
        implOnClick?()
    }
        
    public func isVisible(for messages: [Message]) -> Bool {
        if let visibleFor = visibleFor {
            return visibleFor(messages)
        }
        return true
    }
    
    public func notify(_ messages: [Message]) -> Bool {
        return onClick(messages)
    }
}
