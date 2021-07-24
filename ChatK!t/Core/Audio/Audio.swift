
import UIKit
import AVFoundation
import RxSwift

open class AudioRecorder: NSObject {
    
    public enum AudioRecorderError: Error {
        case permission
    }
    
    open var audioSession = AVAudioSession.sharedInstance()
    open var audioRecorder:AVAudioRecorder?
    public let settings = [AVFormatIDKey: Int(kAudioFormatMPEG4AAC), AVSampleRateKey: 12000, AVNumberOfChannelsKey: 1, AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue]
    open var timer:Timer!
    
    open var isRecording:Bool = false
    open var url:URL?
    open var time:Int = 0
    open var fileName = "audio_file"
    
    override init() {
        super.init()
    }
    
    open func prepare(name: String? = nil) {
 
        if !isAuth() {
            return
        }
        
        url = getDir().appendingPathComponent((name ?? fileName).appending(".m4a"))
        do {
            try audioSession.setCategory(AVAudioSession.Category.playAndRecord, options: .defaultToSpeaker)
            
                audioRecorder = try AVAudioRecorder(url: url!, settings: settings)
                audioRecorder?.delegate = self as AVAudioRecorderDelegate
                audioRecorder?.isMeteringEnabled = true
                audioRecorder?.prepareToRecord()
            
        } catch {
            print("Recording update error:",error.localizedDescription)
        }
    }
    
    func record() {
        
        if url == nil {
            prepare()
        }
        
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
    
    func stop() throws -> (Data?, Int) {
 
        if audioRecorder?.isRecording ?? false {
            audioRecorder?.stop()
        }
        
        var data: Data?
        
        if let url = url {
            data = try Data(contentsOf: url)
        }

        url = nil
        return (data, time)
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
    
    open func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        isRecording = false
        timer.invalidate()
        print("record finish")
    }
    
    open func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        print(error.debugDescription)
    }
}
