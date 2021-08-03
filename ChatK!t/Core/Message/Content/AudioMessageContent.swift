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

    public let _view: AudioMessageView = .fromNib()
    
    open override func view() -> UIView {
        return _view
    }
        
    open override func bind(_ message: AbstractMessage, model: MessagesModel) {
        super.bind(message, model: model)
        _view.bind(message, model: model)
    }
    
    open func setDownloadProgress(_ progress: Float) {
        _view.setDownloadProgress(progress)
    }
    
    open func downloadFinished(_ url: URL?, error: Error?) {
        _view.downloadFinished(url, error: error)
    }
    
    open func downloadPaused() {
        _view.downloadPaused()
    }
    
    open func downloadStarted() {
        _view.downloadStarted()
    }
    
    open func setUploadProgress(_ progress: Float) {
        _view.setUploadProgress(progress)
    }
    
    open func uploadFinished(_ url: URL?, error: Error?) {
        _view.uploadFinished(url, error: error)
    }
    
    open func uploadStarted() {
        _view.uploadStarted()
    }
}

 open class AudioMessageView: UIView, DownloadableContent, UploadableContent {
    
    open var message: Message?
    
    @IBOutlet weak var progressView: FFCircularProgressView!
    @IBOutlet weak var playPauseButton: UIButton!
    
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var progressSlider: UISlider!
    
    public var timer: Timer?
    
    open override func awakeFromNib() {
        super.awakeFromNib()

        progressView.tintColor = ChatKit.asset(color: "message_icon")
        progressView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(startStopDownload)))
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
        progressView.startSpinProgressBackgroundLayer()
    }
    
    open func pauseDownloading() {
        audioMessage()?.pauseDownload()
    }
    
    open func setDownloadProgress(_ progress: Float) {
        progressView.progress = CGFloat(progress)
        if progress > 0 {
            progressView.stopSpinProgressBackgroundLayer()
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
            progressView.isHidden = false
            playPauseButton.isHidden = true
            progressView.progress = 0
        } else {
            progressView.isHidden = true
            progressView.stopSpinProgressBackgroundLayer()
            playPauseButton.isHidden = false
            if let _ = url {
                playPauseButton.isEnabled = true
                progressSlider.isEnabled = true
            } else {
                playPauseButton.isEnabled = false
                progressSlider.isEnabled = false
            }
            progressSlider.setNeedsLayout()
            progressSlider.layoutIfNeeded()
        }
        
    }

    open func downloadPaused() {
        progressView.progress = 0
    }

    open func downloadStarted() {
        progressView.stopSpinProgressBackgroundLayer()
    }

    @IBAction func playPauseButtonPressed(_ sender: Any) {
        DispatchQueue.main.async { [weak self] in
            if let this = self {
                if !this.playPauseButton.isSelected {
                    self?.play()
                } else {
                    self?.pause()
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
            
            playPauseButton.isSelected = true

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
        playPauseButton.isSelected = false
    }
    
    @IBAction func progressSliderValueChanged(_ sender: Any) {
        if let player = audioMessage()?.audioPlayer() {
            let pos = Double(progressSlider.value)
            player.currentTime = pos
            currentTimeLabel.text = format(time: pos)
        }
    }
    
    open func bind(_ message: AbstractMessage, model: MessagesModel) {
        self.message = message
        
        progressView.tickColor = model.bubbleColor(message)
        
        if let audioMessage = audioMessage() {
            
            // This message has not been downloaded yet
            if audioMessage.audioURL() != nil && audioMessage.localAudioURL == nil {

                playPauseButton.isHidden = true
                progressView.isHidden = false
                progressSlider.isEnabled = false
                                
            } else {
                progressView.isHidden = true
                playPauseButton.isHidden = false

                playPauseButton.isEnabled = audioMessage.localAudioURL != nil
                progressSlider.isEnabled = true

            }

            update()
        }
    }
    
    open func update() {
        let duration = audioMessage()?.audioPlayer()?.duration ?? audioMessage()?.duration() ?? 0
        totalTimeLabel.text = format(time: duration)
        let current = audioMessage()?.audioPlayer()?.currentTime ?? 0
        currentTimeLabel.text = format(time: current)
        
        progressSlider?.value = Float(current)
        progressSlider?.maximumValue = Float(duration)
    }
        
    open func format(time: TimeInterval) -> String {
        let totalSeconds = Int(time)

        let minutes = time / 60
        let seconds = Float(totalSeconds % 60)

        return String(format: "%.0f:%02.0f", minutes, seconds)
    }
    
    open func audioMessage() -> AudioMessage? {
        return message as? AudioMessage
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
