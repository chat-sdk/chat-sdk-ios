//
//  ChatHeaderView.swift
//  ChatSDK
//
//  Created by ben3 on 21/10/2020.
//

import Foundation
import KeepLayout

@objc public class BChatHeaderView : UIView {
    
    @objc public var titleLabel: UILabel?
    @objc public var subtitleLabel: UILabel?
       
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
        
        titleLabel = UILabel()
        
        titleLabel?.text = Bundle.t(bThread)
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
    
}
