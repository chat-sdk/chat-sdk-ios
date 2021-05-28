
import UIKit
import AVFoundation
import RxSwift

public class AudioRecorder: NSObject {
    
    public enum AudioRecorderError: Error {
        case permission
    }
    
    public var audioSession:AVAudioSession = AVAudioSession.sharedInstance()
    public var audioRecorder:AVAudioRecorder!
    public let settings = [AVFormatIDKey: Int(kAudioFormatMPEG4AAC), AVSampleRateKey: 12000, AVNumberOfChannelsKey: 1, AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue]
    public var timer:Timer!
    
    var isRecording:Bool = false
    var url:URL?
    var time:Int = 0
    
    override init() {
        super.init()
    }
    
    private func recordSetup(name: String) {
        url = getDir().appendingPathComponent(name.appending(".m4a"))
        do {
            try audioSession.setCategory(AVAudioSession.Category.playAndRecord, options: .defaultToSpeaker)
            
                audioRecorder = try AVAudioRecorder(url: url!, settings: settings)
                audioRecorder.delegate = self as AVAudioRecorderDelegate
                audioRecorder.isMeteringEnabled = true
                audioRecorder.prepareToRecord()
            
        } catch {
            print("Recording update error:",error.localizedDescription)
        }
    }
    
    func record(name: String) {
        recordSetup(name: name)
        
        if let recorder = audioRecorder {
            if !isRecording {
                do {
                    try audioSession.setActive(true)
                    
                    time = 0
                    timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
                
                    recorder.record()
                    isRecording = true
   
                } catch {
                    print("Record error:",error.localizedDescription)
                }
            }
        }
    }
    
    @objc private func updateTimer() {
        if isRecording {
            time += 1
        } else {
            timer.invalidate()
        }
    }
    
    func stop() {
       audioRecorder.stop()
        do {
            try audioSession.setActive(false)
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
    
    func isAuth() -> Bool {
        return AVAudioSession.sharedInstance().recordPermission == .granted
    }

    func getTime() -> String {
        var result = ""
        if time < 60 {
            result = "\(time)"
        } else if time >= 60 {
            result = "\(time / 60):\(time % 60)"
        }
        return result
    }
        
}

extension AudioRecorder: AVAudioRecorderDelegate {
    
    public func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        isRecording = false
        url = nil
        timer.invalidate()
        print("record finish")
    }
    
    public func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        print(error.debugDescription)
    }
}
