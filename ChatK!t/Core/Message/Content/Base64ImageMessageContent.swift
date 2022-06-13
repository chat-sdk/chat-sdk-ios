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
        
        imageMessageView.message = message

        imageMessageView.imageView?.keepWidth.equal = KeepHigh(size().width)
        imageMessageView.imageView?.keepHeight.equal = KeepHigh(size().height)

        // Get the base 64 data
        if let base64 = message.messageMeta()?["image-data"] as? String, let data = NSData(base64Encoded: base64, options: .ignoreUnknownCharacters) {
            let image = UIImage(data: data as Data)
            imageMessageView.imageView?.image = image
        } else {
            imageMessageView.imageView?.image = ChatKit.asset(icon: "icn_200_image_placeholder_error")
        }

        imageMessageView.checkView?.isHidden = !message.isSelected()

        hideBlur()
        imageMessageView.hideProgressView()
                
        imageMessageView.setMaskPosition(direction: message.messageDirection())
        imageMessageView.imageView?.setMaskPosition(direction: message.messageDirection())
        imageMessageView.blurView?.setMaskPosition(direction: message.messageDirection())
    }
    
}
