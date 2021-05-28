//
//  AudioMessageContent.swift
//  ChatK!t
//
//  Created by ben3 on 21/05/2021.
//

import Foundation
import FFCircularProgressView
import AVFoundation

public class AudioMessageContent: DefaultMessageContent, DownloadableContent {

    public let _view: AudioMessageView = .fromNib()
    
    public override func view() -> UIView {
        return _view
    }
        
    public override func bind(_ message: Message, model: MessagesModel) {
        super.bind(message, model: model)
        _view.bind(message, model: model)
    }
    
    public func setProgress(_ progress: Float) {
        _view.setProgress(progress)
    }
    
    public func downloadFinished(_ url: URL?, error: Error?) {
        _view.downloadFinished(url, error: error)
    }
    
    public func downloadPaused() {
        _view.downloadPaused()
    }
    
    public func downloadStarted() {
        _view.downloadStarted()
    }
    
}

public class AudioMessageView: UIView {
    
    public var message: Message?
    
    @IBOutlet weak var progressView: FFCircularProgressView!
    @IBOutlet weak var playPauseButton: UIButton!
    
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var progressSlider: UISlider!
    
    var timer: Timer?
    
    public override func awakeFromNib() {
        super.awakeFromNib()

        progressView.tintColor = ChatKit.asset(color: "message_icon")
        progressView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(startStopDownload)))
    }
    
    @objc public func startStopDownload() {
        if let audioMessage = audioMessage() {
            if !audioMessage.isDownloading() {
                startDownloading()
            } else {
                pauseDownloading()
            }
        }
    }
    
    public func startDownloading() {
        audioMessage()?.startDownload()
        progressView.startSpinProgressBackgroundLayer()
    }
    
    public func pauseDownloading() {
        audioMessage()?.pauseDownload()
    }
    
    public func setProgress(_ progress: Float) {
        progressView.progress = CGFloat(progress)
        if progress > 0 {
            progressView.stopSpinProgressBackgroundLayer()
        }
    }
    
    public func downloadFinished(_ url: URL?, error: Error?) {
        // Delay a second so we have time to see the tick
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { timer in
            timer.invalidate()
            DispatchQueue.main.async { [weak self] in
                self?.implDownloadFinished(url, error: error)
            }
        })
    }
    
    public func implDownloadFinished(_ url: URL?, error: Error?) {
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

    public func downloadPaused() {
        progressView.progress = 0
    }

    public func downloadStarted() {
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
    
    public func play() {
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
    
    public func pause() {
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
    
    public func bind(_ message: Message, model: MessagesModel) {
        self.message = message
        
        progressView.tickColor = model.bubbleColor(message)
        
        if let audioMessage = message as? IAudioMessage {
            
            // This message has not been downloaded yet
            if message.messageRemoteURL() != nil && audioMessage.messageLocalURL() == nil {
                setProgress(audioMessage.downloadProgress())

                playPauseButton.isHidden = true
                progressView.isHidden = false
                progressSlider.isEnabled = false
                                
            } else {
                progressView.isHidden = true
                playPauseButton.isHidden = false

                playPauseButton.isEnabled = audioMessage.messageLocalURL() != nil
                progressSlider.isEnabled = true

            }

            update()
        }
    }
    
    public func update() {
        let duration = audioMessage()?.audioPlayer()?.duration ?? audioMessage()?.duration() ?? 0
        totalTimeLabel.text = format(time: duration)
        let current = audioMessage()?.audioPlayer()?.currentTime ?? 0
        currentTimeLabel.text = format(time: current)
        
        progressSlider?.value = Float(current)
        progressSlider?.maximumValue = Float(duration)
    }
        
    public func format(time: TimeInterval) -> String {
        let totalSeconds = Int(time)

        let minutes = time / 60
        let seconds = Float(totalSeconds % 60)

        return String(format: "%.0f:%02.0f", minutes, seconds)
    }
    
    public func audioMessage() -> IAudioMessage? {
        return message as? IAudioMessage
    }
    
}
