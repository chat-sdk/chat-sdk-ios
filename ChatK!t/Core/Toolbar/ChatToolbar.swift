//
//  ChatToolbar.swift
//  AFNetworking
//
//  Created by ben3 on 06/07/2020.
//

import Foundation

public protocol ChatToolbarDelegate: class {
    func selectedMessages() -> [AbstractMessage]
    func clearSelection(_ updateView: Bool?, animated: Bool)
}

public protocol ChatToolbarActionsDelegate: class {
    var toolbarActions: [ToolbarAction] {
        get
    }
}

open class ChatToolbar: UIToolbar {
    
    open weak var toolbarDelegate: ChatToolbarDelegate?
    open weak var toolbarActionsDelegate: ChatToolbarActionsDelegate?

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
        
    open func setDelegate(_ delegate: ChatToolbarDelegate) {
        self.toolbarDelegate = delegate
    }

    open func setActionsDelegate(_ delegate: ChatToolbarActionsDelegate) {
        self.toolbarActionsDelegate = delegate
    }

    open func update(animated: Bool = false) {
        var items = [UIBarButtonItem]()
        
        let fixedSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil);
        fixedSpace.width = 10
        items.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
        
        if let delegate = toolbarDelegate, let actionsDelegate = toolbarActionsDelegate {
            let actions = actionsDelegate.toolbarActions
            for i in 0 ..< actions.count {
                let action = actions[i]

                action.implOnClick = {
                    if action.notify(delegate.selectedMessages()) {
                        delegate.clearSelection(true, animated: true)
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
    
    open func isVisible() -> Bool {
        return self.alpha != 0
    }

    open func show() -> Void {
        update()
        show(duration: ChatKit.config().animationDuration)
    }
    
    open func hide() -> Void {
        hide(duration: ChatKit.config().animationDuration)
    }
    
    open func show(duration: Double) {
        if !isVisible() {
            superview?.keepAnimated(withDuration: duration, layout: {
                self.alpha = 1
            })
        }
    }

    open func hide(duration: Double) {
        if isVisible() {
            superview?.keepAnimated(withDuration: duration, layout: {
                self.alpha = 0
            })
        }
    }
    
}
