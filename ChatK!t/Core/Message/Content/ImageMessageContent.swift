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

    open func setDownloadProgress(_ progress: Float) {
        _view.setDownloadProgress(progress)
    }

    open func setUploadProgress(_ progress: Float) {
        _view.setUploadProgress(progress)
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

open class ImageMessageView: UIView, DownloadableContent, UploadableContent {
    
    @IBOutlet public weak var imageView: FLAnimatedImageView!
    @IBOutlet public weak var checkImageView: UIImageView!
    @IBOutlet public weak var videoImageView: UIImageView!
    @IBOutlet public weak var progressView: FFCircularProgressView!
    
    open var blurView: UIView?
    open var message: Message?
    open var videoIconVisible = false

    override open func awakeFromNib() {
        super.awakeFromNib()
        blurView = ChatKit.provider().makeBackground(blur: true, effect: UIBlurEffect(style: .systemUltraThinMaterial))
        insertSubview(blurView!, belowSubview: progressView)
        blurView?.keepInsets.equal = 0
        blurView?.layer.cornerRadius = ChatKit.config().bubbleCornerRadius
        blurView?.clipsToBounds = true

        progressView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(startStopDownload)))
        
        bringSubviewToFront(checkImageView)
    }

    open func setDownloadProgress(_ progress: Float) {
        showProgressView()
        progressView.progress = CGFloat(progress)
    }

    open func setUploadProgress(_ progress: Float) {
        showProgressView()
        progressView.progress = CGFloat(progress)
    }

    @objc open func startStopDownload() {
        if let message = message as? DownloadableMessage {
            if !message.isDownloading {
                message.startDownload()
            } else {
                message.pauseDownload()
            }
        }
    }
    
    open func downloadFinished(_ url: URL?, error: Error?) {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { timer in
            timer.invalidate()
            DispatchQueue.main.async { [weak self] in
                self?.implDownloadFinished(url, error: error)
            }
        })
    }
    
    open func implDownloadFinished(_ url: URL?, error: Error?) {
        hideProgressView()
        progressView.stopSpinProgressBackgroundLayer()
    }
    
    open func downloadPaused() {
        progressView.progress = 0
    }
    
    open func downloadStarted() {
        showProgressView()
        progressView.stopSpinProgressBackgroundLayer()
    }
    
    open func uploadFinished(_ url: URL?, error: Error?) {
        hideProgressView()
    }
    
    open func uploadStarted() {
        showProgressView()
    }

    open func hideProgressView() {
        progressView.isHidden = true
        progressView.progress = 0
        blurView?.isHidden = true
        updateVideoIcon()
    }

    open func showProgressView() {
        progressView.isHidden = false
        blurView?.isHidden = false
        videoImageView.isHidden = true
    }
    
    open func updateVideoIcon() {
        videoImageView.isHidden = !videoIconVisible
    }

}
