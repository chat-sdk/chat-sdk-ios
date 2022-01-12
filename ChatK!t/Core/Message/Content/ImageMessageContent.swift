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
    
    open lazy var _view: ImageMessageView = {

        let view: ImageMessageView = .fromNib()
        view.imageView.layer.cornerRadius = ChatKit.config().bubbleCornerRadius
        view.imageView.clipsToBounds = true
        view.clipsToBounds = true
                        
        return view
    }()

    open override func view() -> UIView {
        return _view
    }
    
    open override func bind(_ message: AbstractMessage, model: MessagesModel) {
        super.bind(message, model: model)
        
        _view.message = message
        
        _view.updateVideoIcon()
        
        _view.imageView.keepWidth.equal = KeepHigh(size().width)
        _view.imageView.keepHeight.equal = KeepHigh(size().height)
        
        _view.checkImageView.isHidden = !message.isSelected()
        _view.progressView.hideProgressIcons = false
        
        var placeholder: UIImage?
        if let message = message as? HasPlaceholder {
            placeholder = message.placeholder()
        }
        if placeholder == nil {
            placeholder = ChatKit.asset(icon: "icn_200_image_placeholder")
        }
        
        if let message = message as? ImageMessage, let url = message.imageURL() {
            _view.imageView.sd_cancelCurrentImageLoad()
            _view.imageView.sd_setImage(with: url, placeholderImage: placeholder, completed: nil)
        } else {
            _view.imageView.image = placeholder
        }

        if let message = message as? DownloadableMessage, !message.isDownloaded() {
            _view.showProgressView()
        } else {
            _view.hideProgressView()
        }
        
        _view.setMaskPosition(direction: message.messageDirection())
        _view.imageView.setMaskPosition(direction: message.messageDirection())
        _view.blurView?.setMaskPosition(direction: message.messageDirection())
    }
    
    open override func showBubble() -> Bool {
        return false
    }
    
    open func showVideoIcon() {
        _view.videoImageView.isHidden = false
    }
    
    open func hideVideoIcon() {
        _view.videoImageView.isHidden = true
    }

    open func hideBlur() {
        _view.blurView?.isHidden = true
    }

    open func showBlur() {
        _view.blurView?.isHidden = false
    }

    open func setDownloadProgress(_ progress: Float, total: Float) {
        _view.setDownloadProgress(progress, total: total)
    }

    open func setUploadProgress(_ progress: Float, total: Float) {
        _view.setUploadProgress(progress, total: total)
    }

    open func downloadFinished(_ url: URL?, error: Error?) {
        if error == nil {
//            _view.imageView.sd_setImage(with: url, placeholderImage: ChatKit.asset(icon: "icn_200_image_placeholder"), completed: nil)
        } else {
            _view.downloadFinished(url, error: nil)
        }
        _view.hideProgressView()
    }
    
    open func downloadPaused() {
        _view.downloadPaused()
    }
    
    open func minSize() -> CGSize {
        return CGSize(width: 200, height: 200)
    }

    open func size() -> CGSize {
        return ChatKit.config().imageMessageSize
        //return CGSize(width: size, height: size)
    }

    open func downloadStarted() {
        _view.downloadStarted()
    }
    
    open func uploadFinished(_ url: URL?, error: Error?) {
        _view.uploadFinished(url, error: error)
    }
    
    open func uploadStarted() {
        _view.uploadStarted()
    }

}


