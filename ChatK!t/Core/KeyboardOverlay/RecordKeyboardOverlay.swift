//
//  RecordKeyboardOverlay.swift
//  ChatK!t
//
//  Created by ben3 on 18/04/2021.
//

import Foundation
import DateTools
import RxSwift

public class RecordKeyboardOverlay: UIView, KeyboardOverlay {
    
    public static let key = "record"
    
    public var recordView: RecordView = .fromNib()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }

    public convenience init(delegate: RecordViewDelegate) {
        self.init(frame: CGRect.zero)
        setup(delegate)
    }

    public convenience init(frame: CGRect, delegate: RecordViewDelegate) {
        self.init(frame: frame)
        setup(delegate)
    }

    public convenience required init?(coder: NSCoder) {
        self.init()
    }

    public func setup(_ delegate: RecordViewDelegate) {
        addSubview(recordView)
        recordView.setDelegate(delegate)
        recordView.keepInsets.equal = 0
    }

    public func viewWillLayoutSubviews(view: UIView) {
        keepBottomInset.equal = view.safeAreaHeight() + ChatKit.config().chatOptionsBottomMargin
    }
    
    public static func new(_ delegate: RecordViewDelegate) -> RecordKeyboardOverlay {
        return RecordKeyboardOverlay(delegate: delegate)
    }
    
}

public protocol RecordViewDelegate {
//    func permissionGranted() -> Bool
//    func requestAudioPermission() -> Completable
//
//    func startRecording()
//    func finishRecording() -> Data?
//
    func send(audio: Data, duration: Int)
}

public class RecordView: UIView {
    
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var micImageView: UIImageView!
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var lockButton: UIButton!
    
    @IBOutlet weak var infoLabel: UILabel!
    public var delegate: RecordViewDelegate?
    
    public var recording = false
    public var locked = false
    
    public var timer: Timer?
    public var startTime: NSDate?
        
    public var panGestureRecognizer: UIPanGestureRecognizer?
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        micImageView.image = ChatKit.asset(icon: "icn_30_mic").withRenderingMode(.alwaysTemplate)
        micImageView.tintColor = ChatKit.asset(color: "red")
        lockButton.isUserInteractionEnabled = false
        
        cancel()
        
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPan(sender:)))
        
        addGestureRecognizer(panGestureRecognizer!)
        
        updateMicButtonForPermission()

    }
    
    public func updateMicButtonForPermission(error: Error? = nil) {
        if ChatKit.audioRecorder().isAuth() {
            recordButton.setImage(ChatKit.asset(icon: "icn_60_mic_button"), for: .normal)
            recordButton.setImage(ChatKit.asset(icon: "icn_100_mic_button_red"), for: .highlighted)
            infoLabel.text = ""
        } else {
            recordButton.setImage(ChatKit.asset(icon: "icn_60_mic_unlock_button"), for: .normal)
            recordButton.setImage(ChatKit.asset(icon: "icn_60_mic_unlock_button"), for: .highlighted)
            if let text = error?.localizedDescription {
                infoLabel.text = text
            } else {
                infoLabel.text = t(Strings.requestAudioPermission)
            }
        }
    }
    
    @objc public func didPan(sender: UIPanGestureRecognizer) {
        DispatchQueue.main.async { [weak self] in
            if let this = self {
                let point = sender.location(in: this)
                if this.recordButton.isSelected {
                    if this.lockButton.frame.contains(point) && !this.lockButton.isSelected {
                        this.lock()
                    }
                }
                if this.recording {
                    this.recordButton.isSelected = true
                }
            }
        }
    }
    
    public func setDelegate(_ delegate: RecordViewDelegate) {
        self.delegate = delegate
    }
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        DispatchQueue.main.async { [weak self] in
            self?.send()
        }
    }
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        DispatchQueue.main.async { [weak self] in
            self?.cancel()
        }
    }
    
    @IBAction func recordButtonDown(_ sender: Any) {
        DispatchQueue.main.async { [weak self] in
            self?.start()
        }
    }
    
    @IBAction func recordButtonDragExit(_ sender: Any) {
        DispatchQueue.main.async { [weak self] in
            self?.recordButton.isSelected = true
        }
    }

    @IBAction func recordButtonUpInside(_ sender: Any) {
        DispatchQueue.main.async { [weak self] in
            if let this = self {
                if !this.lockButton.isSelected {
                    this.recordButton.isSelected = false
                    this.send()
                }
            }
        }
    }
    
    @IBAction func recordButtonUpOutside(_ sender: Any) {
        DispatchQueue.main.async { [weak self] in
            if let this = self {
                if !this.lockButton.isSelected {
                    this.recordButton.isSelected = false
                    this.send()
                }
            }
        }
    }
    
    public func lock() {
        lockButton.isSelected = true
        recordButton.isUserInteractionEnabled = false
        
        sendButton.isHidden = false
        deleteButton.isHidden = false
    }
        
    public func send() {
        ChatKit.audioRecorder().stop()
        do {
            if let url = ChatKit.audioRecorder().url {
                let data = try Data(contentsOf: url)
                delegate?.send(audio: data, duration: ChatKit.audioRecorder().time)
            }
        } catch {
            
        }
        
        cancel()
    }
    
    public func cancel() {
        recording = false
        
        infoLabel.text = ""
        lockButton.isSelected = false
        recordButton.isSelected = false
        recordButton.isUserInteractionEnabled = true

        sendButton.isHidden = true
        deleteButton.isHidden = true
        micImageView.isHidden = true

        timeLabel.isHidden = true
        timeLabel.text = ""
        timer?.invalidate()
    }
    
    public func start() {
        if !ChatKit.audioRecorder().isAuth() {
            _ = ChatKit.audioRecorder().requestAuth().subscribe(onCompleted: { [weak self] in
                self?.updateMicButtonForPermission()
            }, onError: { [weak self] error in
                self?.updateMicButtonForPermission(error: error)
            })
        } else {
            recording = true
            
            ChatKit.audioRecorder().record(name: "audio_file")
            
            startTime = NSDate()
            
            micImageView.isHidden = false
            timeLabel.isHidden = false
            
            timer?.invalidate()
            timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { [weak self] timer in
                DispatchQueue.main.async {
                    if let start = self?.startTime {
                        let min = floor(start.minutesAgo())
                        let sec = floor(start.secondsAgo()) - min * 60
                        self?.timeLabel.text = String(format: "%.0f:%02.0f", min, sec)
                    } else {
                        self?.timeLabel.text = ""
                    }
                }
            })
        }
    }
    
}
