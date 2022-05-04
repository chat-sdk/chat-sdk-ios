//
//  ChatHeaderView.swift
//  ChatSDK
//
//  Created by ben3 on 21/10/2020.
//

import Foundation
import KeepLayout
import UIKit

open class ChatHeaderView : UIView {
    
    open var titleLabel: UILabel?
    open var subtitleLabel: UILabel?
    open var imageView: UIImageView?
    open var tapRecognizer: UITapGestureRecognizer?
    open var onTap: (()->Void)?
       
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
        
        let viewHeight : CGFloat = 40.0
        
        tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap))
        addGestureRecognizer(tapRecognizer!)
        
        let imageEnabled = ChatKit.config().imageViewInChatHeader
                
        if imageEnabled {
            imageView = UIImageView()
            addSubview(imageView!)
            
            imageView?.keepLeftInset.equal = 0
            imageView?.keepTopInset.equal = 0
            imageView?.keepBottomInset.equal = 0
            imageView?.keepAspectRatio.equal = 1
            imageView?.layer.cornerRadius = viewHeight / 2
            imageView?.clipsToBounds = true
            imageView?.contentMode = .scaleAspectFill

        }
        
        titleLabel = UILabel()
        
        titleLabel?.textAlignment = imageEnabled ? .left : .center
        titleLabel?.font = UIFont.boldSystemFont(ofSize: titleLabel!.font.pointSize)
        
        addSubview(titleLabel!)
        
        if imageEnabled {
            titleLabel?.keepLeftOffsetTo(imageView)?.equal = 5
        } else {
            titleLabel?.keepLeftInset.equal = 0
        }
        titleLabel?.keepTopInset.equal = 0
        titleLabel?.keepRightInset.equal = 0
        titleLabel?.keepBottomInset.equal = 15
        
        subtitleLabel = UILabel()
        
        subtitleLabel?.textAlignment = imageEnabled ? .left : .center
        subtitleLabel?.font = UIFont.italicSystemFont(ofSize: 12.0)
        subtitleLabel?.textColor = .lightGray
        
        addSubview(subtitleLabel!)
        
        if imageEnabled {
            subtitleLabel?.keepLeftOffsetTo(imageView)?.equal = 5
        } else {
            subtitleLabel?.keepLeftInset.equal = 0

//            subtitleLabel?.keepWidth.equal = 200;
//            subtitleLabel?.keepHorizontalCenter.equal = 0.5;
        }
        subtitleLabel?.keepHeight.equal = 15;
        subtitleLabel?.keepBottomInset.equal = 3;
        subtitleLabel?.keepRightInset.equal = 0

//        keepWidth.equal = 180
        keepWidth.equal = 250
        keepHeight.equal = viewHeight
        
    }
    
    @objc open func tap() {
        if let onTap = onTap {
            onTap()
        }
    }
}
