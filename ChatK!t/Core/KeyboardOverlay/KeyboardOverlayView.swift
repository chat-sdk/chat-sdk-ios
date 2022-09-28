//
//  KeyboardOverlayView.swift
//  ChatK!t
//
//  Created by Ben on 27/09/2022.
//

import Foundation

public class KeyboardOverlayView: UIInputView {
    
    @objc
    public let contentView = UIView()

    @objc
    public init() {
        super.init(frame: .zero, inputViewStyle: .default)

        addSubview(contentView)
        contentView.keepInsets.equal = 0

        translatesAutoresizingMaskIntoConstraints = true

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func setSize(frame: CGRect?, height: CGFloat) {
        if let frame = frame {
            self.frame = CGRectMake(0, 0, 0, 0)

            keepWidth.equal = frame.size.width
            
            
            allowsSelfSizing = true
//            frame = value
        } else {
            allowsSelfSizing = false
        }
        keepHeight.equal = height


        setNeedsLayout()
        layoutIfNeeded()
        
        print("View dimensions: ", frame)
    }

    public func setHeight(value: CGFloat) {
        if value > 0 {
            allowsSelfSizing = true
            keepHeight.equal = value
        } else {
            allowsSelfSizing = false
        }
        setNeedsLayout()
        layoutIfNeeded()
        
        
        print("View dimensions: ", frame)
    }
    
    
}
