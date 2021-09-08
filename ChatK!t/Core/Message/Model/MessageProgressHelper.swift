//
//  MessageProgressHelper.swift
//  ChatK!t
//
//  Created by ben3 on 08/09/2021.
//

import Foundation
import FFCircularProgressView

public protocol MessageProgressHelperDelegate : AnyObject {
    func startDownload()
    func pauseDownload()
    func isDownloading() -> Bool
    func downloadFinished()
}

open class MessageProgressHelper: DownloadableContent, UploadableContent {
    
    open var downloadEnabled = true
    open var uploadEnabled = true
    
    public let progressView: FFCircularProgressView
    open var timer: Timer?

    open weak var delegate: MessageProgressHelperDelegate?
    
    public init(_ progressView: FFCircularProgressView, delegate: MessageProgressHelperDelegate? = nil) {
        self.progressView = progressView
        self.delegate = delegate
        
        progressView.tintColor = ChatKit.asset(color: "message_icon")
        progressView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(startStopDownload)))

    }
    
    open func setDownloaded(_ isDownloaded: Bool) {
        progressView.isHidden = isDownloaded
    }
    
    open func setTick(color: UIColor) {
        progressView.tickColor = color
    }
    
    @objc open func startStopDownload() {
        if let delegate = delegate {
            if delegate.isDownloading() {
                pauseDownload()
            } else {
                startDownload()
            }
        }
    }
    
    open func startDownload() {
        delegate?.startDownload()
        progressView.startSpinProgressBackgroundLayer()
    }
    
    open func pauseDownload() {
        delegate?.pauseDownload()
    }
    
    
    open func setDownloadProgress(_ progress: Float) {
        progressView.progress = CGFloat(progress)
        if progress > 0 {
            progressView.stopSpinProgressBackgroundLayer()
        }
    }

    open func downloadFinished(_ url: URL?, error: Error?) {
        // Delay a second so we have time to see the tick
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { [weak self] timer in
            timer.invalidate()
            DispatchQueue.main.async { [weak self] in
                if let _ = error {
                    self?.progressView.isHidden = false
                    self?.progressView.progress = 0
                } else {
                    self?.progressView.isHidden = true
                    self?.progressView.stopSpinProgressBackgroundLayer()
                }
                self?.delegate?.downloadFinished()
            }
        })
    }
    
    open func downloadPaused() {
        progressView.progress = 0
    }

    open func downloadStarted() {
        progressView.stopSpinProgressBackgroundLayer()
    }
    
    open func setUploadProgress(_ progress: Float) {
        progressView.progress = CGFloat(progress)
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
    }

    open func showProgressView() {
        progressView.isHidden = false
    }

    
}
