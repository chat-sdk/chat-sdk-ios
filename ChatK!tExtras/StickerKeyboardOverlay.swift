//
//  StickerKeyboardOverlay.swift
//  ChatK!t
//
//  Created by ben3 on 01/06/2021.
//

import Foundation
import MessageModules
import ChatKit

open class StickerKeyboardOverlay: UIView, KeyboardOverlay {
    
    public static let key = "sticker"
    
    open var stickerView: BStickerView?
    
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

    open func getStickerView() -> BStickerView {
        return BStickerView()
    }
    
    open func setup() {
        stickerView = getStickerView()
        stickerView?.topLineView.isHidden = true
        stickerView?.enableBackButton = false
        addSubview(stickerView!)
        stickerView?.keepInsets.equal = 0
    }

    open func viewWillLayoutSubviews(view: UIView) {
        keepBottomInset.equal = 0
    }
    
}
