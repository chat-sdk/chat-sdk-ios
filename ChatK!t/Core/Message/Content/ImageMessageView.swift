//
//  ImageMessageView.swift
//  ChatK!t
//
//  Created by ben3 on 16/09/2021.
//

import Foundation
import FFCircularProgressView
import FLAnimatedImage

open class ImageMessageView: UIView, DownloadableContent, UploadableContent {
    
    @IBOutlet public weak var imageView: FLAnimatedImageView!
    @IBOutlet public weak var checkImageView: UIImageView!
    @IBOutlet public weak var videoImageView: UIImageView!
    @IBOutlet public weak var progressView: FFCircularProgressView!
    @IBOutlet public weak var detailLabel: UILabel!
    
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

        detailLabel.isHidden = true
        detailLabel.textColor = ChatKit.asset(color: "message_icon")

        progressView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(startStopDownload)))
        
        bringSubviewToFront(checkImageView)
    }

    open func setDownloadProgress(_ progress: Float, total: Float) {
        showProgressView()
        progressView.progress = CGFloat(progress)
        updateTotal(total, progress: progress)
    }

    open func setUploadProgress(_ progress: Float, total: Float) {
        if progress > 0 {
            showProgressView()
        }
        if progress == 1 {
            hideProgressView()
        }
        progressView.progress = CGFloat(progress)
        updateTotal(total, progress: progress)
    }
    
    open func updateTotal(_ total: Float, progress: Float) {
        if total > 0 {
            detailLabel.isHidden = false
            
            var percentage = ""
            if ChatKit.config().showFileTransferPercentage {
                percentage = String(format: "%.0f%%, ", progress * 100)
            }

            if total < 1000 {
                detailLabel.text = String(format: "%@%.0fKB", percentage, total)
            } else {
                let total = total / 1000
                detailLabel.text = String(format: "%@%.0fMB", percentage, total)
            }
        } else {
            detailLabel.text = ""
            detailLabel.isHidden = true
        }
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
//        showProgressView()
    }

    open func hideProgressView() {
        progressView.isHidden = true
        progressView.progress = 0
        blurView?.isHidden = true
        detailLabel.isHidden = true
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
