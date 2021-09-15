//
//  StickerKeyboardOverlay.swift
//  ChatK!t
//
//  Created by ben3 on 01/06/2021.
//

import Foundation
import MessageModules
import ChatKit

public class StickerKeyboardOverlay: UIView, KeyboardOverlay {
    
    public static let key = "sticker"
    
    public var stickerView: BStickerView?
    
    public convenience init() {
        self.init(frame: .zero)
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public convenience required init?(coder: NSCoder) {
        self.init()
        setup()
    }

    public func setup() {
        stickerView = BStickerView()
        stickerView?.topLineView.isHidden = true
        stickerView?.enableBackButton = false
        addSubview(stickerView!)
        stickerView?.keepInsets.equal = 0
    }

    public func viewWillLayoutSubviews(view: UIView) {
        keepBottomInset.equal = 0
    }
    
}
