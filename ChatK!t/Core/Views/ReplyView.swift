//
//  ReplyView.swift
//  AFNetworking
//
//  Created by ben3 on 08/07/2020.
//

import Foundation
import KeepLayout

public class ReplyView : UIView {
    
    let topBorder = UIView()
    let divider = UIView()
    let imageView = UIImageView()
    let titleTextView = UITextView()
    let textView = UITextView()
    let closeButton = UIButton()
    
    var didClose: (() -> Void)?
   
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

    public func setup() {
        
        clipsToBounds = true
        
        addSubview(divider)
        addSubview(imageView)
        addSubview(titleTextView)
        addSubview(textView)
        addSubview(closeButton)
        addSubview(topBorder)

        divider.backgroundColor = ChatKit.shared().assets.get(color: "reply_divider")

        imageView.keepTopOffsetTo(topBorder)?.equal = 0
        imageView.keepLeftInset.equal = 0
        imageView.keepBottomInset.equal = 0
        imageView.keepWidth.equal = 50
        
        imageView.backgroundColor = .red
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        titleTextView.font = UIFont.boldSystemFont(ofSize: 12)
        titleTextView.textContainerInset = UIEdgeInsets.zero

        textView.textContainer.maximumNumberOfLines = 2
        textView.textContainerInset = UIEdgeInsets.zero
        
        closeButton.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        
//        closeButton.setPre

        divider.keepLeftOffsetTo(imageView)?.equal = 0
        
        divider.keepTopOffsetTo(topBorder)?.equal = 0
        divider.keepBottomInset.equal = 0
        divider.keepWidth.equal = 5
        
        titleTextView.keepTopOffsetTo(topBorder)?.equal = 5;
        titleTextView.keepLeftOffsetTo(divider)?.equal = 0
        titleTextView.keepRightOffsetTo(closeButton)?.equal = 0
        titleTextView.keepHeight.equal = 20

        textView.keepLeftOffsetTo(divider)?.equal = 0
        textView.keepRightOffsetTo(closeButton)?.equal = 0
        textView.keepTopOffsetTo(titleTextView)?.equal = 0
        textView.keepBottomInset.equal = 0
 
        closeButton.keepVerticalCenter.equal = 0.5
        closeButton.keepRightInset.equal = 5
        closeButton.keepHeight.equal = 36
        closeButton.keepWidth.equal = 36
        
        topBorder.keepLeftInset.equal = 0
        topBorder.keepTopInset.equal = 0
        topBorder.keepRightInset.equal = 0
        topBorder.keepHeight.equal = 1

        topBorder.backgroundColor = ChatKit.shared().assets.get(color: "reply_top_border_color")

        closeButton.setImage(ChatKit.shared().assets.get(icon: "icn_36_cross"), for: .normal)
        
//        imageView.image = Icons.defaultUserImage()
//        titleTextView.text = "Ben"
//        textView.text = "This is some test text, This is some test text, This is some test text, This is some test text"
//        textView.backgroundColor = .green

        
    }
    
    public func show(title: String, message: String?, imageURL: URL?) -> Void {
        show(title: title, message: message, imageURL: imageURL, duration: 0.5)
    }
    
    @objc public func dismiss() {
        didClose?()
        hide()
    }
    
    public func hide() {
        hide(duration: 0.5)
    }
    
    public func show(title: String, message: String?, imageURL: URL?, duration: Double) -> Void {
        
        titleTextView.text = title
        textView.text = message ?? ""
        
        if let url = imageURL {
            imageView.sd_setImage(with: url, completed: nil)
            imageView.keepWidth.equal = 50
        } else {
            imageView.keepWidth.equal = 0
        }
        
        if duration == 0 {
            self.keepHeight.equal = 51
        } else {
            superview?.keepAnimated(withDuration: duration, layout: {
                self.keepHeight.equal = 51
            })
        }
    }

    public func hide(duration: Double) -> Void {
        if duration == 0 {
            self.keepHeight.equal = 0
        } else {
            superview?.keepAnimated(withDuration: duration, layout: {
                self.keepHeight.equal = 0
            })
        }
    }
    
    public func isVisible() -> Bool {
        return self.keepHeight.equal.value != 0
    }
    
    public func setDidCloseListener(listener: @escaping (()->Void)) {
        didClose = listener
    }
    
}
