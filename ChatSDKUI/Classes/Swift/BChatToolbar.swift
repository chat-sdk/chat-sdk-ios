//
//  ChatToolbar.swift
//  AFNetworking
//
//  Created by ben3 on 06/07/2020.
//

import Foundation

@objc public class BChatToolbar: UIToolbar {
    
    @objc public var replyListener: (() -> Void)?
    @objc public var forwardListener: (() -> Void)?
    @objc public var copyListener: (() -> Void)?
    @objc public var deleteListener: (() -> Void)?

    @objc public let copyButton = UIBarButtonItem(image: Icons.getCopy()!, style: .plain, target: self, action: #selector(_copy))
    @objc public let forwardButton = UIBarButtonItem(image: Icons.getForward()!, style: .plain, target: self, action: #selector(forward))
    @objc public let replyButton = UIBarButtonItem(barButtonSystemItem: .reply, target: self, action: #selector(reply))
    @objc public let deleteButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(_delete))

    @objc public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    @objc public convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    @objc public convenience required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc public func setup() {
        
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
    
    @objc public func isVisible() -> Bool {
        return self.alpha != 0
    }

    @objc public func show() -> Void {
        show(duration: 0.5)
    }
    
    @objc public func hide() -> Void {
        hide(duration: 0.5)
    }
    
    @objc public func show(duration: Double) {
        if !isVisible() {
            superview?.keepAnimated(withDuration: duration, layout: {
                self.alpha = 1
            })
        }
    }

    @objc public func hide(duration: Double) {
        if isVisible() {
            superview?.keepAnimated(withDuration: duration, layout: {
                self.alpha = 0
            })
        }
    }
    
    @objc public func copyToClipboard(text: String, view: UIView) {
        UIPasteboard.general.string = text
        view.makeToast(Bundle.t(bCopiedToClipboard))
    }
}
