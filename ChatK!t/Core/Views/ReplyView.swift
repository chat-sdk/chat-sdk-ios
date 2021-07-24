//
//  ReplyView.swift
//  AFNetworking
//
//  Created by ben3 on 08/07/2020.
//

import Foundation
import KeepLayout
import SDWebImage

open class ReplyView : UIView {
    
    let topBorder = UIView()
    let divider = UIView()
    let imageView = UIImageView()
    let titleTextView = UITextView()
    let textView = UITextView()
    let closeButton = UIButton()
    var willHideListener: ((Double) -> Void)?
    var didHideListener: (() -> Void)?
    var _message: Message?

    var willShow = false
    var willHide = false
   
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    public convenience required init?(coder: NSCoder) {
        self.init()
    }

    open func setup() {
        
        clipsToBounds = true
        
        addSubview(divider)
        addSubview(imageView)
        addSubview(titleTextView)
        addSubview(textView)
        addSubview(closeButton)
        addSubview(topBorder)

        imageView.keepTopOffsetTo(topBorder)?.equal = 0
        imageView.keepLeftInset.equal = 0
        imageView.keepBottomInset.equal = 0
        imageView.keepWidth.equal = 0
        
//        imageView.backgroundColor = .red
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
//        imageView.layer.borderColor = UIColor.red.cgColor
//        imageView.layer.borderWidth = 1

        
        titleTextView.font = UIFont.boldSystemFont(ofSize: 12)
        titleTextView.textContainerInset = UIEdgeInsets.zero

        textView.textContainer.maximumNumberOfLines = 2
        textView.textContainerInset = UIEdgeInsets.zero
        
        closeButton.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        
        divider.keepLeftOffsetTo(imageView)?.equal = 0
        
        divider.keepTopOffsetTo(topBorder)?.equal = 0
        divider.keepBottomInset.equal = 0
        divider.keepWidth.equal = 5
        
        titleTextView.keepTopOffsetTo(topBorder)?.equal = 1;
        titleTextView.keepLeftOffsetTo(divider)?.equal = 0
        titleTextView.keepRightOffsetTo(closeButton)?.equal = 0
        titleTextView.keepHeight.equal = 19
        titleTextView.backgroundColor = .clear

        textView.keepLeftOffsetTo(divider)?.equal = 0
        textView.keepRightOffsetTo(closeButton)?.equal = 0
        textView.keepTopOffsetTo(titleTextView)?.equal = 0
        textView.keepBottomInset.equal = 0
        textView.backgroundColor = .clear

        closeButton.keepVerticalCenter.equal = 0.5
        closeButton.keepRightInset.equal = 5
        closeButton.keepHeight.equal = 36
        closeButton.keepWidth.equal = 36
        
        topBorder.keepLeftInset.equal = 0
        topBorder.keepTopInset.equal = 0
        topBorder.keepRightInset.equal = 0
        topBorder.keepHeight.equal = 1

        updateColors()
        
    }
    
    open func updateColors() {
        divider.backgroundColor = ChatKit.asset(color: "reply_divider")
        backgroundColor = ChatKit.asset(color: "gray_5")
        topBorder.backgroundColor = ChatKit.asset(color: "gray_4")
        closeButton.setImage(ChatKit.asset(icon: "icn_36_cross"), for: .normal)
    }
    
    open func show(message: AbstractMessage, duration: Double) {
        _message = message
        
        var url: URL? = nil
        var placeholder: UIImage? = nil
        if let message = message as? HasImage {
            url = message.imageURL()
        }
        if let message = message as? HasPlaceholder {
            placeholder = message.placeholder()
        }
        show(title: message.messageSender().userName(), message: message.messageText(), imageURL: url, placeholder: placeholder, duration: duration)
    }
    
    open func message() -> Message? {
        return _message
    }

    @objc open func dismiss() {
        hide(duration: ChatKit.config().animationDuration)
    }
    
    @objc open func hide() {
        hide(duration: ChatKit.config().animationDuration)
    }
    
    private func show(title: String, message: String?, imageURL: URL?, placeholder: UIImage?, duration: Double) -> Void {
        
        titleTextView.text = title
        textView.text = message ?? ""
        
        if let url = imageURL {
            imageView.sd_setImage(with: url, placeholderImage: placeholder, options: .scaleDownLargeImages, completed: nil)
            imageView.keepWidth.equal = ChatKit.config().chatReplyViewHeight
        } else if let placeholder = placeholder {
            imageView.image = placeholder
            imageView.keepWidth.equal = ChatKit.config().chatReplyViewHeight
        } else {
            imageView.keepWidth.equal = 0
        }
        
        if duration == 0 {
            alpha = 1
        } else {
            willShow = true
            superview?.keepAnimated(withDuration: duration, layout: { [weak self] in
                self?.alpha = 1
                self?.willShow = false
            })
        }
    }

    open func hide(duration: Double = 0, notify: Bool = true) -> Void {
        willHide = true
        willHideListener?(duration)
        _message = nil

        if duration == 0 {
            alpha = 0
            self.willHide = false
            didHideListener?()
        } else {
            if notify {
                willHideListener?(duration)
            }
            superview?.keepAnimated(withDuration: duration, layout: { [weak self] in
                self?.alpha = 0
                self?.willHide = false
                self?.didHideListener?()
            })
        }
    }
    
    open func isVisible() -> Bool {
        return alpha != 0
    }
    
    open func setWillHideListener(listener: @escaping ((Double)->Void)) {
        willHideListener = listener
    }
    
}
