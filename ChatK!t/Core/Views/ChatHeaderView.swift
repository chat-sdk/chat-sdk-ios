//
//  ChatHeaderView.swift
//  ChatSDK
//
//  Created by ben3 on 21/10/2020.
//

import Foundation
import KeepLayout

open class ChatHeaderView : UIView {
    
    open var titleLabel: UILabel?
    open var subtitleLabel: UILabel?
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
        
        tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap))
        addGestureRecognizer(tapRecognizer!)
                
        titleLabel = UILabel()
        
        titleLabel?.textAlignment = .center
        titleLabel?.font = UIFont.boldSystemFont(ofSize: titleLabel!.font.pointSize)
        
        addSubview(titleLabel!)
        
        titleLabel?.keepInsets.equal = 0
        titleLabel?.keepBottomInset.equal = 15
        
        subtitleLabel = UILabel()
        
        subtitleLabel?.textAlignment = .center
        subtitleLabel?.font = UIFont.italicSystemFont(ofSize: 12.0)
        subtitleLabel?.textColor = .lightGray
        
        addSubview(subtitleLabel!)
        
        subtitleLabel?.keepHeight.equal = 15;
        subtitleLabel?.keepWidth.equal = 200;
        subtitleLabel?.keepBottomInset.equal = 0;
        subtitleLabel?.keepHorizontalCenter.equal = 0.5;

        keepWidth.equal = 180
        keepHeight.equal = 40
    }
    
    @objc open func tap() {
        if let onTap = onTap {
            onTap()
        }
    }
}
