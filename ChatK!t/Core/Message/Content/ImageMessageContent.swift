//
//  ImageMessageContent.swift
//  ChatK!t
//
//  Created by ben3 on 27/05/2021.
//

import Foundation
import KeepLayout
import FLAnimatedImage
import FFCircularProgressView

open class ImageMessageContent: DefaultMessageContent, DownloadableContent, UploadableContent {
    
    open lazy var _imageMessageView: ImageMessageView = {
        let view: ImageMessageView = .fromNib()
        view.imageView?.layer.cornerRadius = ChatKit.config().bubbleCornerRadius
        view.imageView?.clipsToBounds = true
        view.clipsToBounds = true
        return view
    }()

    open var imageMessageView: ImageMessageView {
        return _imageMessageView
    }

    open override func view() -> UIView {
        return imageMessageView
    }

    open override func bind(_ message: AbstractMessage, model: MessagesModel) {
        super.bind(message, model: model)
        
        imageMessageView.message = message
        
        imageMessageView.updateVideoIcon()
        
        imageMessageView.imageView?.keepWidth.equal = KeepHigh(size().width)
        imageMessageView.imageView?.keepHeight.equal = KeepHigh(size().height)
        
        imageMessageView.checkView?.isHidden = !message.isSelected()
        imageMessageView.progressView?.hideProgressIcons = false
        
        var placeholder: UIImage?
        if let message = message as? HasPlaceholder {
            placeholder = message.placeholder()
        }
        if placeholder == nil {
            placeholder = ChatKit.asset(icon: "icn_200_image_placeholder")
        }
        
        if let message = message as? ImageMessage, let url = message.imageURL() {
            imageMessageView.imageView?.sd_cancelCurrentImageLoad()
            imageMessageView.imageView?.sd_setImage(with: url, placeholderImage: placeholder, completed: nil)
        } else {
            imageMessageView.imageView?.image = placeholder
        }

        if let message = message as? DownloadableMessage, !message.isDownloaded() {
            imageMessageView.showProgressView()
        } else {
            imageMessageView.hideProgressView()
        }
        
        imageMessageView.setMaskPosition(direction: message.messageDirection())
        imageMessageView.imageView?.setMaskPosition(direction: message.messageDirection())
        imageMessageView.blurView?.setMaskPosition(direction: message.messageDirection())
    }
    
    open override func showBubble() -> Bool {
        return false
    }
    
    open func showVideoIcon() {
        imageMessageView.videoView?.isHidden = false
    }
    
    open func hideVideoIcon() {
        imageMessageView.videoView?.isHidden = true
    }

    open func hideBlur() {
        imageMessageView.blurView?.isHidden = true
    }

    open func showBlur() {
        imageMessageView.blurView?.isHidden = false
    }

    open func setDownloadProgress(_ progress: Float, total: Float) {
        imageMessageView.setDownloadProgress(progress, total: total)
    }

    open func setUploadProgress(_ progress: Float, total: Float) {
        imageMessageView.setUploadProgress(progress, total: total)
    }

    open func downloadFinished(_ url: URL?, error: Error?) {
        if error == nil {
            //            imageMessageView.imageView.sd_setImage(with: url, placeholderImage: ChatKit.asset(icon: "icn_200_image_placeholder"), completed: nil)
        } else {
            imageMessageView.downloadFinished(url, error: nil)
        }
        imageMessageView.hideProgressView()
    }
    
    open func downloadPaused() {
        imageMessageView.downloadPaused()
    }
    
    open func minSize() -> CGSize {
        return CGSize(width: 200, height: 200)
    }

    open func size() -> CGSize {
        return ChatKit.config().imageMessageSize
        //return CGSize(width: size, height: size)
    }

    open func downloadStarted() {
        imageMessageView.downloadStarted()
    }
    
    open func uploadFinished(_ url: URL?, error: Error?) {
        imageMessageView.uploadFinished(url, error: error)
    }
    
    open func uploadStarted() {
        imageMessageView.uploadStarted()
    }

}
