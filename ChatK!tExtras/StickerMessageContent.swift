//
//  StickerMessageContent.swift
//  ChatK!t
//
//  Created by ben3 on 31/05/2021.
//

import Foundation
import MessageModules
import ChatKit

public class StickerMessageContent: ImageMessageContent {
    
    public override func bind(_ message: AbstractMessage, model: MessagesModel) {
        
        hideVideoIcon()
        imageMessageView.hideProgressView()

        imageMessageView.checkView?.isHidden = !message.isSelected()
        
        imageMessageView.imageView?.image = nil
        imageMessageView.imageView?.animatedImage = nil

        if let text = message.messageText() {
            if text.contains(".gif") {

                let image = StickerMessageModule.shared().animatedImage(text)

                // For animated gifs we want the view to match the aspect ratio of the image
                if let image = image {
                    imageMessageView.imageView?.keepWidth.equal = KeepHigh(size().width)
                    imageMessageView.imageView?.keepHeight.equal = KeepHigh(size().width * image.size.height / image.size.width)
                }
                
                imageMessageView.imageView?.animatedImage = image
                imageMessageView.imageView?.contentMode = .scaleAspectFit
                
            } else {
                
                imageMessageView.imageView?.keepWidth.equal = KeepHigh(size().width)
                imageMessageView.imageView?.keepHeight.equal = KeepHigh(size().height)

                let image = StickerMessageModule.shared().image(text)
                imageMessageView.imageView?.image = image
                imageMessageView.imageView?.contentMode = .scaleAspectFill
            }
        } else {
            imageMessageView.imageView?.image = ChatKit.asset(icon: "icn_250_icon_unavailable")
        }

        view().setMaskPosition(direction: message.messageDirection())
        imageMessageView.imageView?.setMaskPosition(direction: message.messageDirection())
    }
    
    public override func size() -> CGSize {
        return CGSize(width: 200, height: 200)
    }

}
