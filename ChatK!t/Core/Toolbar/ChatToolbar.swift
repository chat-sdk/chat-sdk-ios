//
//  ChatToolbar.swift
//  AFNetworking
//
//  Created by ben3 on 06/07/2020.
//

import Foundation

public protocol ChatToolbarDelegate {
    func selectedMessages() -> [Message]
    func clearSelection(_ updateView: Bool?)
}

public protocol ChatToolbarActionsDelegate {
    func toolbarActions() -> [ToolbarAction]
}

public class ChatToolbar: UIToolbar {
    
    public var _delegate: ChatToolbarDelegate?
    public var _actionsDelegate: ChatToolbarActionsDelegate?

    public override init(frame: CGRect) {
        super.init(frame: frame)
        update()
    }

    public convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    public convenience required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    public func setDelegate(_ delegate: ChatToolbarDelegate) {
        _delegate = delegate
    }

    public func setActionsDelegate(_ delegate: ChatToolbarActionsDelegate) {
        _actionsDelegate = delegate
    }

    public func update(animated: Bool = false) {
        var items = [UIBarButtonItem]()
        
        let fixedSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil);
        fixedSpace.width = 10
        items.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
        
        if let delegate = _delegate, let actionsDelegate = _actionsDelegate {
            let actions = actionsDelegate.toolbarActions()
            for i in 0 ..< actions.count {
                let action = actions[i]

                action.implOnClick = {
                    if action.notify(delegate.selectedMessages()) {
                        delegate.clearSelection(true)
                    }
                }
                
                if action.isVisible(for: delegate.selectedMessages()) {
                    items.append(action.barButtonItem)
                    if i < actions.count - 1 {
                        items.append(fixedSpace)
                    }
                }
            }
        }
        
        setItems(items, animated: animated)

    }
    
    public func isVisible() -> Bool {
        return self.alpha != 0
    }

    public func show() -> Void {
        update()
        show(duration: ChatKit.config().animationDuration)
    }
    
    public func hide() -> Void {
        hide(duration: ChatKit.config().animationDuration)
    }
    
    public func show(duration: Double) {
        if !isVisible() {
            superview?.keepAnimated(withDuration: duration, layout: {
                self.alpha = 1
            })
        }
    }

    public func hide(duration: Double) {
        if isVisible() {
            superview?.keepAnimated(withDuration: duration, layout: {
                self.alpha = 0
            })
        }
    }
    
}
