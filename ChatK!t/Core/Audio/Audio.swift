
import UIKit
import AVFoundation
import RxSwift

public class AudioRecorder: NSObject {
    
    public enum AudioRecorderError: Error {
        case permission
    }
    
    public var _audioSession:AVAudioSession = AVAudioSession.sharedInstance()
    public var _audioRecorder:AVAudioRecorder!
    public let _settings = [AVFormatIDKey: Int(kAudioFormatMPEG4AAC), AVSampleRateKey: 12000, AVNumberOfChannelsKey: 1, AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue]
    public var _timer:Timer!
    
    var _isRecording:Bool = false
    var _url:URL?
    var _time:Int = 0
    
    override init() {
        super.init()
    }
    
    private func recordSetup(name: String) {
        _url = getDir().appendingPathComponent(name.appending(".m4a"))
        do {
            try _audioSession.setCategory(AVAudioSession.Category.playAndRecord, options: .defaultToSpeaker)
            
                _audioRecorder = try AVAudioRecorder(url: _url!, settings: _settings)
                _audioRecorder.delegate = self as AVAudioRecorderDelegate
                _audioRecorder.isMeteringEnabled = true
                _audioRecorder.prepareToRecord()
            
        } catch {
            print("Recording update error:",error.localizedDescription)
        }
    }
    
    func record(name: String) {
        recordSetup(name: name)
        
        if let recorder = _audioRecorder {
            if !_isRecording {
                do {
                    try _audioSession.setActive(true)
                    
                    _time = 0
                    _timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
                
                    recorder.record()
                    _isRecording = true
   
                } catch {
                    print("Record error:",error.localizedDescription)
                }
            }
        }
    }
    
    @objc private func updateTimer() {
        if _isRecording {
            _time += 1
        } else {
            _timer.invalidate()
        }
    }
    
    func stop() {
       _audioRecorder.stop()
        do {
            try _audioSession.setActive(false)
        } catch {
            print("stop()",error.localizedDescription)
        }
    }
    
    func delete(name:String) {
        
        let bundle = getDir().appendingPathComponent(name.appending(".m4a"))
        let manager = FileManager.default
        
        if manager.fileExists(atPath: bundle.path) {
            
            do {
                try manager.removeItem(at: bundle)
            } catch {
                print("delete()",error.localizedDescription)
            }
            
        } else {
            print("File is not exist.")
        }
    }
    
    private func getDir() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths.first!
    }
    
    func requestAuth() -> Completable {
        return Completable.create { emitter in
            AVAudioSession.sharedInstance().requestRecordPermission { (res) in
                if res == true {
                    emitter(.completed)
                } else {
                    emitter(.error(AudioRecorderError.permission))
                }
            }
            return Disposables.create {}
        }
    }
    
    public func url() -> URL? {
        return _url
    }

    func isAuth() -> Bool {
        return AVAudioSession.sharedInstance().recordPermission == .granted
    }

    func getTime() -> String {
        var result = ""
        if _time < 60 {
            result = "\(_time)"
        } else if _time >= 60 {
            result = "\(_time / 60):\(_time % 60)"
        }
        return result
    }
    
    public func time() -> Int {
        return _time
    }
    
}

extension AudioRecorder: AVAudioRecorderDelegate {
    
    public func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        _isRecording = false
        _url = nil
        _timer.invalidate()
        print("record finish")
    }
    
    public func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        print(error.debugDescription)
    }
}

//public class AudioItem {
//    let player: AVAudioPlayer
//}

//public class AudioPlayer: NSObject {
//
////    public var _audioPlayer: AVAudioPlayer
//
//    public var _players = [Message: AVAudioPlayer]()
//
//    public override init() {
//        super.init()
////        _audioPlayer.delegate = self
//    }
//
//    public var _audioSession:AVAudioSession = AVAudioSession.sharedInstance()
//
//    public func play(message: Message) -> Bool {
//        do {
//            try _audioSession.setCategory(AVAudioSession.Category.playAndRecord, options: .defaultToSpeaker)
//            if _audioPlayer.isPlaying {
//                _audioPlayer.stop()
//            }
//            if let url = message.messageLocalPath() {
//                _audioPlayer = try AVAudioPlayer(contentsOf: url)
//                _audioPlayer.delegate = self
////                _audioPlayer.play(atTime: message.seekPosition())
////                _audioPlayer.play(atTime: seek(message))
//                _audioPlayer.play()
//                return true
//            }
//        } catch {
//            print("Play Exception", error.localizedDescription)
//        }
//        return false
//    }
//
//    public func updateSeek(_ message: Message) {
//        if _audioPlayer.isPlaying {
//            _seek[message] = _audioPlayer.currentTime
//        }
//    }
//
//    public func seek(_ message: Message) -> TimeInterval {
//        return _seek[message] ?? 0
//    }
//
//    public func seekTo(position: TimeInterval) {
//        _audioPlayer.currentTime = position
//    }
//
//    public func time(_ message: Message) -> TimeInterval {
//        return _players[message]?.currentTime ?? 0
//    }
//
//    public func duration() -> TimeInterval {
//        return _audioPlayer.duration
//    }
//
//    public func pause() {
//        _audioPlayer.pause()
//    }
//
//    public  func getDir() -> URL {
//        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//        return paths.first!
//    }
//
//    public func isHeadsetPluggedIn() -> Bool {
//        let route = AVAudioSession.sharedInstance().currentRoute
//        for desc in route.outputs {
//            if desc.portType == .headphones {
//                return true
//            }
//        }
//        return false
//    }
//}

//extension AudioPlayer: AVAudioPlayerDelegate {
//    
//    public func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
//        print("playing finish")
//    }
//    
//    public func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
//        print(error.debugDescription)
//    }
//}

