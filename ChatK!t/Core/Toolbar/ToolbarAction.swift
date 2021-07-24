//
//  ToolbarAction.swift
//  AFNetworking
//
//  Created by ben3 on 24/04/2021.
//

import Foundation

open class ToolbarAction {
    
    public let barButtonItem: UIBarButtonItem
    open var visibleFor: (([AbstractMessage]) -> Bool)?
    public let onClick: ([AbstractMessage]) -> Bool
    open var implOnClick: (() -> Void)?

    public init(item: UIBarButtonItem, visibleFor: (([AbstractMessage]) -> Bool)? = nil, onClick: @escaping (([AbstractMessage]) -> Bool)) {
        self.onClick = onClick
        self.visibleFor = visibleFor
        barButtonItem = item
        barButtonItem.target = self
        barButtonItem.action = #selector(click)
    }
    
    @objc open func click() {
        implOnClick?()
    }
        
    open func isVisible(for messages: [AbstractMessage]) -> Bool {
        if let visibleFor = visibleFor {
            return visibleFor(messages)
        }
        return true
    }
    
    open func notify(_ messages: [AbstractMessage]) -> Bool {
        return onClick(messages)
    }
    
    public static func copyAction(visibleFor: (([AbstractMessage]) -> Bool)? = nil, onClick: @escaping (([AbstractMessage]) -> Bool)) -> ToolbarAction {
        return ToolbarAction(item: UIBarButtonItem(image: ChatKit.asset(icon: "icn_24_copy"), style: .plain, target: nil, action: nil), visibleFor: visibleFor, onClick: onClick)
    }

    public static func trashAction(visibleFor: (([AbstractMessage]) -> Bool)? = nil, onClick: @escaping (([AbstractMessage]) -> Bool)) -> ToolbarAction {
        return ToolbarAction(item: UIBarButtonItem(image: ChatKit.asset(icon: "icn_24_trash"), style: .plain, target: nil, action: nil), visibleFor: visibleFor, onClick: onClick)
    }

    public static func forwardAction(visibleFor: (([AbstractMessage]) -> Bool)? = nil, onClick: @escaping (([AbstractMessage]) -> Bool)) -> ToolbarAction {
        return ToolbarAction(item: UIBarButtonItem(image: ChatKit.asset(icon: "icn_24_forward"), style: .plain, target: nil, action: nil), visibleFor: visibleFor, onClick: onClick)
    }

    public static func replyAction(visibleFor: (([AbstractMessage]) -> Bool)? = nil, onClick: @escaping (([AbstractMessage]) -> Bool)) -> ToolbarAction {
        return ToolbarAction(item: UIBarButtonItem(image: ChatKit.asset(icon: "icn_24_reply"), style: .plain, target: nil, action: nil), visibleFor: visibleFor, onClick: onClick)
    }
    
    
}
