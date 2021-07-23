//
//  ChatHeaderView.swift
//  ChatSDK
//
//  Created by ben3 on 21/10/2020.
//

import Foundation
import KeepLayout

public class ChatHeaderView : UIView {
    
    public var titleLabel: UILabel?
    public var subtitleLabel: UILabel?
    public var tapRecognizer: UITapGestureRecognizer?
    public var onTap: (()->Void)?
       
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
        
        tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap))
        addGestureRecognizer(tapRecognizer!)
                
        titleLabel = UILabel()
        
//        titleLabel?.text = Bundle.t(bThread)
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
    
    @objc public func tap() {
        if let onTap = onTap {
            onTap()
        }
    }
}
