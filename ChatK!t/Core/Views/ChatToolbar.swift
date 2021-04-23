//
//  ChatToolbar.swift
//  AFNetworking
//
//  Created by ben3 on 06/07/2020.
//

import Foundation

@objc public class ChatToolbar: UIToolbar {
    
    public var replyListener: (() -> Void)?
    public var forwardListener: (() -> Void)?
    public var copyListener: (() -> Void)?
    public var deleteListener: (() -> Void)?
    
    public var copyButton: UIBarButtonItem?
    public var forwardButton: UIBarButtonItem?
    public var replyButton: UIBarButtonItem?
    public var deleteButton: UIBarButtonItem?

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
        update(count: 1)
    }
    
    public func update(count: Int, animated: Bool = false) {
        var items = [UIBarButtonItem]()
        
        let fixedSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil);
        fixedSpace.width = 10
        
        copyButton = UIBarButtonItem(image: ChatKit.asset(icon: "icn_24_copy"), style: .plain, target: self, action: #selector(_copy))
        forwardButton = UIBarButtonItem(image: ChatKit.asset(icon: "icn_24_forward"), style: .plain, target: self, action: #selector(forward))
        replyButton = UIBarButtonItem(image: ChatKit.asset(icon: "icn_24_reply"), style: .plain, target: self, action: #selector(reply))
        deleteButton = UIBarButtonItem(image: ChatKit.asset(icon: "icn_24_trash"), style: .plain, target: self, action: #selector(del))

        items.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
        items.append(copyButton!)
        items.append(fixedSpace)
        items.append(deleteButton!)
        if count == 1 {
            items.append(fixedSpace)
            items.append(forwardButton!)
            items.append(fixedSpace)
            items.append(replyButton!)
        }
        setItems(items, animated: animated)
    }
    
    @objc public func reply() {
        replyListener?()
    }

    @objc public func forward() {
        forwardListener?()
    }

    @objc public func _copy() {
        copyListener?()
    }

    @objc public func del() {
        deleteListener?()
    }
    
    public func setSelectedMessageCount(count: Int) {
        update(count: count, animated: true)
    }
    
    public func isVisible() -> Bool {
        return self.alpha != 0
    }

    public func show() -> Void {
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
    
    public func copyToClipboard(text: String, view: UIView) {
        UIPasteboard.general.string = text
        view.makeToast(t(Strings.copiedToClipboard))
    }
}
