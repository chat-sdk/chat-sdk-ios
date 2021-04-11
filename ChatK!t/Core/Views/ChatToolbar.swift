//
//  ChatToolbar.swift
//  AFNetworking
//
//  Created by ben3 on 06/07/2020.
//

import Foundation

public class ChatToolbar : UIToolbar {
    
    public var replyListener: (() -> Void)?
    public var forwardListener: (() -> Void)?
    public var copyListener: (() -> Void)?
    public var deleteListener: (() -> Void)?

    public let copyButton = UIBarButtonItem(image: ChatKit.shared().assets.get(icon: "icn_24_copy"), style: .plain, target: self, action: #selector(_copy))
    public let forwardButton = UIBarButtonItem(image: ChatKit.shared().assets.get(icon: "icn_24_forward"), style: .plain, target: self, action: #selector(forward))
    public let replyButton = UIBarButtonItem(barButtonSystemItem: .reply, target: self, action: #selector(reply))
    public let deleteButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(_delete))

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    public convenience required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func setup() {
        
        var items = [UIBarButtonItem]()
        
        let fixedSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil);
        fixedSpace.width = 10
        
        items.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
        items.append(copyButton)
        items.append(fixedSpace)
        items.append(deleteButton)
        items.append(fixedSpace)
        items.append(forwardButton)
        items.append(fixedSpace)
        items.append(replyButton)

        setItems(items, animated: false)
        
    }
    
    @objc public func reply() {
        if let listener = replyListener {
            listener()
        }
    }

    @objc public func forward() {
        if let listener = forwardListener {
            listener()
        }
    }

    @objc public func _copy() {
        if let listener = copyListener {
            listener()
        }
    }

    @objc public func _delete() {
        if let listener = deleteListener {
            listener()
        }
    }
    
    public func isVisible() -> Bool {
        return self.alpha != 0
    }

    public func show() -> Void {
        show(duration: 0.5)
    }
    
    public func hide() -> Void {
        hide(duration: 0.5)
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
    
    public func copyToClipboard(text: String, view: UIView) {
        UIPasteboard.general.string = text
        view.makeToast(t(Strings.copiedToClipboard))
    }
}
