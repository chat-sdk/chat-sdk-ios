//
//  StickerMessageContent.swift
//  ChatK!t
//
//  Created by ben3 on 31/05/2021.
//

import Foundation
import MessageModules
import ChatKit
import FLAnimatedImage

open class StickerMessageContent: ImageMessageContent {
    
//    override public func bind2(_ message: AbstractMessage, model: MessagesModel) {
//
//        hideVideoIcon()
//        _view.hideProgressView()
//
//        _view.checkImageView.isHidden = !message.isSelected()
//
//        _view.imageView.image = nil
//        _view.imageView.animatedImage = nil
//
//        if let text = message.messageText(), !text.isEmpty {
//            if text.contains(".gif") {
//
//                let image = StickerMessageModule.shared().animatedImage(text)
//
//                // For animated gifs we want the view to match the aspect ratio of the image
//                if let image = image {
//                    _view.imageView.keepWidth.equal = KeepHigh(size().width)
//                    _view.imageView.keepHeight.equal = KeepHigh(size().width * image.size.height / image.size.width)
//                }
//
//                _view.imageView.animatedImage = image
//                _view.imageView.contentMode = .scaleAspectFit
//
//            } else {
//
//                _view.imageView.keepWidth.equal = KeepHigh(size().width)
//                _view.imageView.keepHeight.equal = KeepHigh(size().height)
//
//                let image = StickerMessageModule.shared().image(text)
//                _view.imageView.image = image
//                _view.imageView.contentMode = .scaleAspectFill
//            }
//        } else {
//            if let stickerMessage = message as? StickerMessage, let url = stickerMessage.imageURL() {
//                do {
//                    _view.imageView.sd_setImage(with: url)
////
////                    let data = try Data(contentsOf: url)
////                    _view.imageView.animatedImage = FLAnimatedImage(animatedGIFData: data)
//                    _view.imageView.keepWidth.equal = KeepHigh(size().width)
//                    _view.imageView.keepHeight.equal = KeepHigh(size().height)
//                    _view.imageView.contentMode = .scaleAspectFill
//                } catch {
//                    _view.imageView.image = ChatKit.asset(icon: "icn_250_icon_unavailable")
//                }
//            } else {
//                _view.imageView.image = ChatKit.asset(icon: "icn_250_icon_unavailable")
//            }
//        }
//
//        view().setMaskPosition(direction: message.messageDirection())
//        _view.imageView.setMaskPosition(direction: message.messageDirection())
//    }
    
        
    open override func bind(_ message: AbstractMessage, model: MessagesModel) {
        
        hideVideoIcon()
        imageMessageView.hideProgressView()

        imageMessageView.checkView?.isHidden = !message.isSelected()
        
        imageMessageView.imageView?.image = nil
        imageMessageView.imageView?.animatedImage = nil
        
        if let stickerMessage = message as? StickerMessage, let url = stickerMessage.imageURL(), !url.absoluteString.contains("android.resource://") {
            do {
                imageMessageView.imageView?.sd_setImage(with: url)
                imageMessageView.imageView?.keepWidth.equal = KeepHigh(size().width)
                imageMessageView.imageView?.keepHeight.equal = KeepHigh(size().height)
                imageMessageView.imageView?.contentMode = .scaleAspectFill
            } catch {
                imageMessageView.imageView?.image = ChatKit.asset(icon: "icn_250_icon_unavailable")
            }
        } else if let text = message.messageText(), !text.isEmptyOrBlank() {
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
            
    open override func size() -> CGSize {
        return CGSize(width: 200, height: 200)
    }
    
}
