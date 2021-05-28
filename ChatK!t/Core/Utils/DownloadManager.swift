//
//  DownloadManager.swift
//  ChatK!t
//
//  Created by ben3 on 24/05/2021.
//

import Foundation
import MZDownloadManager

public protocol DownloadManagerListener: AnyObject {
    func downloadProgressUpdated(_ id: String, progress: Float)
    func downloadFinished(_ id: String, path: String)
    func downloadFailed(_ id: String, error: NSError)
    func downloadResumed(_ id: String)
    func downloadPaused(_ id: String)
}

public class DownloadManager {

    lazy var manager: MZDownloadManager = {
       return MZDownloadManager(session: "ChatKit", delegate: self)
    }()
    
    public var taskIndexMap = [String: Int]()
    
    public var listeners = [DownloadManagerListener]()
    public let path: URL
    
    public init() {
                
        let dd = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
        path = dd.appendingPathComponent(ChatKit.config().downloadFolderName)!

        do {
            try FileManager.default.removeItem(at: path)
        } catch let error as NSError {
            print("\(error.localizedDescription)")
        }

        do {
            try FileManager.default.createDirectory(atPath: path.path, withIntermediateDirectories: true, attributes: nil)
        } catch let error as NSError {
            print("\(error.localizedDescription)")
        }
        print("Dir Path = \(path)")
    }
    
    public func localURL(for id: String) -> String? {
        let path = path.appendingPathComponent(id)
        if FileManager.default.fileExists(atPath: path.path) {
            return path.path
        }
        return nil
    }
    
    public func startTask(_ id: String, url: String) {
        if let index = taskIndexMap[id] {
            manager.resumeDownloadTaskAtIndex(index)
        } else {
            manager.addDownloadTask(id, fileURL: url, destinationPath: path.path)
        }
    }

    public func pauseTask(_ id: String) {
        if let index = taskIndexMap[id] {
            manager.pauseDownloadTaskAtIndex(index)
        }
    }

    public func resumeTask(_ id: String) {
        if let index = taskIndexMap[id] {
            manager.resumeDownloadTaskAtIndex(index)
        }
    }

    public func index(for id: String) -> Int? {
        var i = 0
        for model in manager.downloadingArray {
            if model.fileName == id {
                return i
            }
            i += 1
        }
        return nil
    }
    
    public func addListener(_ listener: DownloadManagerListener) {
        listeners.append(listener)
    }
    
    public func removeListener(_ listener: DownloadManagerListener) {
        for i in 0 ..< listeners.count {
            if listeners[i] === listener {
                listeners.remove(at: i)
                break
            }
        }
    }
    
}

extension DownloadManager: MZDownloadManagerDelegate {
    
    public enum DownloadManagerError: Error {
        case cancelled
        case notFound
    }
        
    public func downloadRequestDidUpdateProgress(_ downloadModel: MZDownloadModel, index: Int) {
        let progress = downloadModel.progress
        for listener in listeners {
            listener.downloadProgressUpdated(downloadModel.fileName, progress: progress)
        }
        print("Progress:", index, progress)
    }
    
    public func downloadRequestDidPopulatedInterruptedTasks(_ downloadModel: [MZDownloadModel]) {
        
    }
    
    public func downloadRequestStarted(_ downloadModel: MZDownloadModel, index: Int) {
        taskIndexMap[downloadModel.fileName] = index
        for listener in listeners {
            listener.downloadResumed(downloadModel.fileName)
        }
        print("Started:", index)
    }

    public func downloadRequestDidPaused(_ downloadModel: MZDownloadModel, index: Int) {
        for listener in listeners {
            listener.downloadPaused(downloadModel.fileName)
        }
        print("Paused:", index)
    }

    public func downloadRequestDidResumed(_ downloadModel: MZDownloadModel, index: Int) {
        for listener in listeners {
            listener.downloadResumed(downloadModel.fileName)
        }
        print("Resumed:", index)
    }

    public func downloadRequestDidRetry(_ downloadModel: MZDownloadModel, index: Int) {
        
    }

    public func downloadRequestCanceled(_ downloadModel: MZDownloadModel, index: Int) {
        taskIndexMap[downloadModel.fileName] = nil
        for listener in listeners {
            listener.downloadFailed(downloadModel.fileName, error: DownloadManagerError.cancelled as NSError)
        }
//        listeners.removeAll()
        print("Canceled:", index)
    }

    public func downloadRequestFinished(_ downloadModel: MZDownloadModel, index: Int) {
        taskIndexMap[downloadModel.fileName] = nil
        for listener in listeners {
            listener.downloadFinished(downloadModel.fileName, path: downloadModel.destinationPath)
        }
//        listeners.removeAll()
        print("Finished:", index)
    }

    public func downloadRequestDidFailedWithError(_ error: NSError, downloadModel: MZDownloadModel, index: Int) {
        taskIndexMap[downloadModel.fileName] = nil
        for listener in listeners {
            listener.downloadFailed(downloadModel.fileName, error: error)
        }
//        listeners.removeAll()
        print("Error:", index, error.localizedDescription)
    }

    public func downloadRequestDestinationDoestNotExists(_ downloadModel: MZDownloadModel, index: Int, location: URL) {
        do {
            try FileManager.default.createDirectory(atPath: location.path, withIntermediateDirectories: true, attributes: nil)
        } catch let error as NSError {
            print("Unable to create directory \(error.debugDescription)")
        }
        
        var isDir:ObjCBool = true
        if !FileManager.default.fileExists(atPath: location.path, isDirectory: &isDir) {
            print("directory not created")
        }
        
//        for listener in listeners {
//            listener.downloadFailed(downloadModel.fileName, error: DownloadManagerError.notFound as NSError)
//        }
        print("Destination does not exist:", index, location)
    }
}

public class DefaultDownloadManagerListener: DownloadManagerListener {
    
    public let model: MessagesModel
    
    public init(_ model: MessagesModel) {
        self.model = model
    }
    
    public func downloadProgressUpdated(_ id: String, progress: Float) {
        if let message = message(for: id) {
            message.setProgress(progress)
//            update(id: id)
        }
    }
    
    public func downloadFinished(_ id: String, path: String) {
        if let message = message(for: id) {
            message.setMessageLocalURL(URL(string: path + "/" + id))
            message.downloadFinished(message.messageLocalURL(), error: nil)
        }
    }
    
    public func downloadFailed(_ id: String, error: NSError) {
        if let message = message(for: id) {
            message.downloadFinished(nil, error: error)
        }
    }
    
    public func downloadResumed(_ id: String) {
        if let message = message(for: id) {
            message.downloadStarted()
        }
    }

    public func downloadPaused(_ id: String) {
        if let message = message(for: id) {
            message.downloadPaused()
        }
    }
    
    public func message(for id: String) -> DownloadableMessage? {
        return model.message(for: id) as? DownloadableMessage
    }
    
    public func update(id: String) {
        DispatchQueue.main.async { [weak self] in
            _ = self?.model.updateMessage(id: id).subscribe()
        }
    }

}
