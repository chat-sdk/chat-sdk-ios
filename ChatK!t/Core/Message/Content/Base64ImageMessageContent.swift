//
//  Base64ImageContent.swift
//  ChatK!t
//
//  Created by ben3 on 16/09/2021.
//

import Foundation
import KeepLayout

open class Base64ImageMessageContent: ImageMessageContent {
    
    open override func bind(_ message: AbstractMessage, model: MessagesModel) {
        
        _view.message = message

        _view.imageView.keepWidth.equal = KeepHigh(size().width)
        _view.imageView.keepHeight.equal = KeepHigh(size().height)

        // Get the base 64 data
        if let base64 = message.messageMeta()?["image-data"] as? String, let data = NSData(base64Encoded: base64, options: .ignoreUnknownCharacters) {
            let image = UIImage(data: data as Data)
            _view.imageView.image = image
        } else {
            _view.imageView.image = ChatKit.asset(icon: "icn_200_image_placeholder_error")
        }

        _view.checkImageView.isHidden = !message.isSelected()

        hideBlur()
        _view.hideProgressView()
                
        _view.setMaskPosition(direction: message.messageDirection())
        _view.imageView.setMaskPosition(direction: message.messageDirection())
        _view.blurView?.setMaskPosition(direction: message.messageDirection())
    }
    
}
