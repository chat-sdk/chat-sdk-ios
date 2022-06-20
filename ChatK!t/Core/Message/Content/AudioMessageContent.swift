//
//  AudioMessageContent.swift
//  ChatK!t
//
//  Created by ben3 on 21/05/2021.
//

import Foundation
import FFCircularProgressView
import AVFoundation

open class AudioMessageContent: DefaultMessageContent, DownloadableContent, UploadableContent {

    open lazy var _audioMessageView: AudioMessageView = {
        AudioMessageView.fromNib()
    }()

    open var audioMessageView: AudioMessageView {
        return _audioMessageView
    }
    
    open override func view() -> UIView {
        return audioMessageView
    }

    open override func bind(_ message: AbstractMessage, model: MessagesModel) {
        super.bind(message, model: model)
        audioMessageView.bind(message, model: model)
    }
    
    open func setDownloadProgress(_ progress: Float, total: Float) {
        audioMessageView.setDownloadProgress(progress, total: total)
    }
    
    open func downloadFinished(_ url: URL?, error: Error?) {
        audioMessageView.downloadFinished(url, error: error)
    }
    
    open func downloadPaused() {
        audioMessageView.downloadPaused()
    }
    
    open func downloadStarted() {
        audioMessageView.downloadStarted()
    }
    
    open func setUploadProgress(_ progress: Float, total: Float) {
        audioMessageView.setUploadProgress(progress, total: total)
    }
    
    open func uploadFinished(_ url: URL?, error: Error?) {
        audioMessageView.uploadFinished(url, error: error)
    }
    
    open func uploadStarted() {
        audioMessageView.uploadStarted()
    }
}

open class  AudioMessageView: UIView, DownloadableContent, UploadableContent {
    
    open var message: Message?
    
    @IBOutlet weak var ibProgressView: FFCircularProgressView!
    @IBOutlet weak var ibPlayPauseButton: UIButton!
    @IBOutlet weak var ibCurrentTimeLabel: UILabel!
    @IBOutlet weak var ibTotalTimeLabel: UILabel!
    @IBOutlet weak var ibProgressSlider: UISlider!

    @IBAction func ibPlayPauseButtonPressed(_ sender: Any) {
        playPauseButtonPressed(sender)
    }

    @IBAction func ibProgressSliderValueChanged(_ sender: Any, event: Any) {
        progressSliderValueChanged(sender, event: event)
    }

    open var progressView: FFCircularProgressView? { ibProgressView }
    open var playPauseButton: UIButton? { ibPlayPauseButton }
    open var currentTimeLabel: UILabel? { ibCurrentTimeLabel }
    open var totalTimeLabel: UILabel? { ibTotalTimeLabel }
    open var progressSlider: UISlider? { ibProgressSlider }
    
    public var timer: Timer?
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        progressView?.tintColor = ChatKit.asset(color: "message_icon")
        progressView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(startStopDownload)))
//        totalTimeLabel?.textColor = ChatKit.asset(color: "message_icon")
    }
    
    @objc open func startStopDownload() {
        if let message = message as? DownloadableMessage {
            if !message.isDownloading {
                startDownloading()
            } else {
                pauseDownloading()
            }
        }
    }
    
    open func startDownloading() {
        audioMessage()?.startDownload()
        progressView?.startSpinProgressBackgroundLayer()
    }
    
    open func pauseDownloading() {
        audioMessage()?.pauseDownload()
    }
    
    open func setDownloadProgress(_ progress: Float, total: Float) {
        progressView?.progress = CGFloat(progress)
        if progress > 0 {
            progressView?.stopSpinProgressBackgroundLayer()
        }
    }

    open func downloadFinished(_ url: URL?, error: Error?) {
        // Delay a second so we have time to see the tick
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { timer in
            timer.invalidate()
            DispatchQueue.main.async { [weak self] in
                self?.implDownloadFinished(url, error: error)
            }
        })
    }
    
    open func implDownloadFinished(_ url: URL?, error: Error?) {
        if let _ = error {
            progressView?.isHidden = false
            playPauseButton?.isHidden = true
            progressView?.progress = 0
        } else {
            progressView?.isHidden = true
            progressView?.stopSpinProgressBackgroundLayer()
            playPauseButton?.isHidden = false
            if let _ = url {
                playPauseButton?.isEnabled = true
                progressSlider?.isEnabled = true
            } else {
                playPauseButton?.isEnabled = false
                progressSlider?.isEnabled = false
            }
            progressSlider?.setNeedsLayout()
            progressSlider?.layoutIfNeeded()
        }
        
    }

    open func downloadPaused() {
        progressView?.progress = 0
    }

    open func downloadStarted() {
        progressView?.stopSpinProgressBackgroundLayer()
    }

    @objc open func playPauseButtonPressed(_ sender: Any) {
        DispatchQueue.main.async { [weak self] in
            if let this = self, let button = self?.playPauseButton {
                if button.isSelected {
                    self?.pause()
                } else {
                    self?.play()
                }
            }
        }
    }
    
    open func play() {
        if let player = audioMessage()?.audioPlayer() {
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playAndRecord, options: .defaultToSpeaker)
            } catch {
                
            }
            
            player.play()
            if player.currentTime == 0 {
                player.currentTime = 0.001
            }
            
            playPauseButton?.isSelected = true

            timer?.invalidate()
            timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true, block: { [weak self] timer in

                self?.update()
                
                if(player.currentTime == 0) {
                    self?.pause()
                }
            })
        }
    }
    
    open func pause() {
        timer?.invalidate()
        if let player = audioMessage()?.audioPlayer() {
            player.pause()
        }
        playPauseButton?.isSelected = false
    }
    
    @objc open func progressSliderValueChanged(_ sender: Any, event: Any) {
        if let player = audioMessage()?.audioPlayer() {
            let pos = Double(progressSlider?.value ?? 0)
            player.currentTime = pos
            currentTimeLabel?.text = format(time: pos)
        }
    }
    
    open func bind(_ message: AbstractMessage, model: MessagesModel) {
        self.message = message
        
        progressView?.tickColor = model.bubbleColor(message)
        
        if let audioMessage = audioMessage() {
            
            // This message has not been downloaded yet
            if audioMessage.audioURL() != nil && audioMessage.localAudioURL == nil {

                playPauseButton?.isHidden = true
                progressView?.isHidden = false
                progressSlider?.isEnabled = false

            } else {
                progressView?.isHidden = true
                playPauseButton?.isHidden = false

                playPauseButton?.isEnabled = audioMessage.localAudioURL != nil
                progressSlider?.isEnabled = true

            }

            update()
        }
    }
    
    open func update() {
        let duration = audioMessage()?.audioPlayer()?.duration ?? audioMessage()?.duration() ?? 0
        totalTimeLabel?.text = format(time: duration)
        let current = audioMessage()?.audioPlayer()?.currentTime ?? 0
        currentTimeLabel?.text = format(time: current)
        
        progressSlider?.value = Float(current)
        progressSlider?.maximumValue = Float(duration)
    }

    public class func format(time: TimeInterval) -> String {
        let totalSeconds = Int(time)

        let minutes = time / 60
        let seconds = Float(totalSeconds % 60)

        return String(format: "%.0f:%02.0f", minutes, seconds)
    }

    open func format(time: TimeInterval) -> String {
        return AudioMessageView.format(time: time)
    }
    
    open func audioMessage() -> AudioMessage? {
        return message as? AudioMessage
    }
    
    open func setUploadProgress(_ progress: Float, total: Float) {
        if progress > 0 {
            showProgressView()
        }
        if progress == 1 {
            hideProgressView()
        }
        progressView?.progress = CGFloat(progress)
    }

    open func uploadFinished(_ url: URL?, error: Error?) {
        hideProgressView()
    }
    
    open func uploadStarted() {
        showProgressView()
    }

    open func hideProgressView() {
        progressView?.isHidden = true
        progressView?.progress = 0
        playPauseButton?.isHidden = false
    }

    open func showProgressView() {
        progressView?.isHidden = false
        playPauseButton?.isHidden = true
    }

}

