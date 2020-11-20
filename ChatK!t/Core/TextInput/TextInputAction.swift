//
//  TextInputAction.swift
//  AFNetworking
//
//  Created by ben3 on 16/09/2020.
//

import Foundation
import KeepLayout

public class TextInputAction: NSObject {
    
    let action: (()->Void)
    var text: String?
    var image: UIImage?
    var size: CGSize?
    public var textColor: UIColor?
    
    var button: UIButton?
        
    public init(text: String, action: @escaping (() -> Void), textColor: UIColor? = nil) {
        self.action = action
        self.text = text
        if let color = textColor {
            self.textColor = color
        } else {
            if #available(iOS 13, *) {
                self.textColor = .systemBlue
            } else {
                self.textColor = .blue
            }
        }
        super.init()
    }

    public init(image: UIImage, action: @escaping (() -> Void), size: CGSize? = CGSize(width: 30, height: 30)) {
        self.action = action
        self.image = image
        self.size = size
        super.init()
    }
    
    public func getButton() -> UIButton {
        if let button = button {
            return button
        }

        button = image != nil ? UIButton(type: .custom) : UIButton()
        if let image = self.image {
            button!.setImage(image, for: .normal)
            button!.keepWidth.equal = size!.width
            button!.keepHeight.equal = size!.height
        }
        if let text = self.text {
            button!.setTitle(text, for: .normal)
            button!.setTitleColor(textColor, for: .normal)
            button!.keepWidth.equal = button!.intrinsicContentSize.width
            button!.keepHeight.equal = button!.intrinsicContentSize.height
            button!.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        }
        
        button!.addTarget(self, action: #selector(execute), for: .touchUpInside)
        
        return button!
    }

    @objc public func execute() {
        action()
    }
    
}
