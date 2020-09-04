//
//  ReplyView.swift
//  AFNetworking
//
//  Created by ben3 on 08/07/2020.
//

import Foundation
import KeepLayout

@objc public class ReplyView : UIView {
    
    let topBorder = UIView()
    let divider = UIView()
    let imageView = UIImageView()
    let titleTextView = UITextView()
    let textView = UITextView()
    let closeButton = UIButton()
   
    @objc public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    @objc public convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    @objc public convenience required init?(coder: NSCoder) {
        self.init()
    }

    @objc public func setup() {
        
        addSubview(divider)
        addSubview(imageView)
        addSubview(titleTextView)
        addSubview(textView)
        addSubview(closeButton)
        addSubview(topBorder)

        divider.backgroundColor = Colors.get(name: Colors.replyDividerColor)

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
        
//        closeButton.setPre

        divider.keepLeftOffsetTo(imageView)?.equal = 0
        
        divider.keepTopOffsetTo(topBorder)?.equal = 0
        divider.keepBottomInset.equal = 0
        divider.keepWidth.equal = 5
        
        titleTextView.keepTopOffsetTo(topBorder)?.equal = 0;
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

        topBorder.backgroundColor = Colors.get(name: Colors.replyTopBorderColor)

        closeButton.setImage(Icons.get(name: "icn_36_cross"), for: .normal)
        
        imageView.image = Icons.defaultUserImage()
        titleTextView.text = "Ben"
        textView.text = "This is some test text, This is some test text, This is some test text, This is some test text"
        textView.backgroundColor = .green

//        imageView.keepLeftIn
        
    }
    
    @objc public func show(duration: Double) -> Void {
        superview?.keepAnimated(withDuration: duration, layout: {
            self.keepHeight.equal = 51
            self.closeButton.alpha = 1
        })
    }

    @objc public func hide(duration: Double) -> Void {
        superview?.keepAnimated(withDuration: duration, layout: {
            self.keepHeight.equal = 0
            self.closeButton.alpha = 0
        })
    }
    
    @objc public func isVisible() -> Bool {
        return self.keepHeight.equal.value != 0
    }

}
