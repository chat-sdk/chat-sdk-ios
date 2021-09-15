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
        _view.hideProgressView()
                
        _view.checkImageView.isHidden = !message.isSelected()
        
        _view.imageView.image = nil
        _view.imageView.animatedImage = nil
                
        if let text = message.messageText() {
            if text.contains(".gif") {

                let image = StickerMessageModule.shared().animatedImage(text)

                // For animated gifs we want the view to match the aspect ratio of the image
                if let image = image {
                    _view.imageView.keepWidth.equal = KeepHigh(size().width)
                    _view.imageView.keepHeight.equal = KeepHigh(size().width * image.size.height / image.size.width)
                }
                
                _view.imageView.animatedImage = image
                _view.imageView.contentMode = .scaleAspectFit
                
            } else {
                
                _view.imageView.keepWidth.equal = KeepHigh(size().width)
                _view.imageView.keepHeight.equal = KeepHigh(size().height)

                let image = StickerMessageModule.shared().image(text)
                _view.imageView.image = image
                _view.imageView.contentMode = .scaleAspectFill
            }
        } else {
            _view.imageView.image = ChatKit.asset(icon: "icn_250_icon_unavailable")
        }

        view().setMaskPosition(direction: message.messageDirection())
        _view.imageView.setMaskPosition(direction: message.messageDirection())
    }
    
    public override func size() -> CGSize {
        return CGSize(width: 200, height: 200)
    }

    
}
