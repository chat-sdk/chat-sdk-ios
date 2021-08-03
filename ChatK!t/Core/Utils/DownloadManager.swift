//
//  DownloadManager.swift
//  ChatK!t
//
//  Created by ben3 on 24/05/2021.
//

import Foundation
import MZDownloadManager

public protocol DownloadManagerListener: AnyObject {
    func downloadProgressUpdated(_ id: String, pathExtension: String?, progress: Float)
    func downloadFinished(_ id: String, pathExtension: String?, path: String)
    func downloadFailed(_ id: String, pathExtension: String?, error: NSError)
    func downloadResumed(_ id: String, pathExtension: String?)
    func downloadPaused(_ id: String, pathExtension: String?)
}

open class DownloadManager {

    lazy var manager: MZDownloadManager = {
       return MZDownloadManager(session: "ChatKit", delegate: self)
    }()
    
    open var taskIndexMap = [String: Int]()
    
    open var listeners = [DownloadManagerListener]()
    public let path: URL
    
    public init() {
                
        path = DownloadManager.downloadPath()

//        do {
//            try FileManager.default.removeItem(at: path)
//        } catch let error as NSError {
//            print("\(error.localizedDescription)")
//        }

        do {
            try FileManager.default.createDirectory(atPath: path.path, withIntermediateDirectories: true, attributes: nil)
        } catch let error as NSError {
            print("\(error.localizedDescription)")
        }
        print("Dir Path = \(path)")
        
    }
    
    open func save(_ data: Data, messageId: String, pathExtension: String? = nil) throws -> URL? {
        var path = DownloadManager.downloadPath().appendingPathComponent(messageId)
        if let ext = pathExtension {
            path.appendPathExtension(ext)
        }
        try data.write(to: path)
        return path
    }
    
    public static func downloadPath() -> URL {
        let dd = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
        return dd.appendingPathComponent(ChatKit.config().downloadFolderName)!
    }
    
    open func localURL(for id: String, pathExtension: String? = nil) -> URL? {
        var path = path.appendingPathComponent(id)
        if let ext = pathExtension {
            path.appendPathExtension(ext)
        }
        if FileManager.default.fileExists(atPath: path.path) {
            return path
        }
        return nil
    }
    
    open func fileName(_ id: String, pathExtension: String? = nil) -> String {
        var fileName = id
        if let ext = pathExtension {
            fileName += "." + ext
        }
        return fileName
    }
    
    open func startTask(_ id: String, pathExtension: String? = nil, url: String) {
        let name = fileName(id, pathExtension: pathExtension)
        if let index = taskIndexMap[name] {
            manager.resumeDownloadTaskAtIndex(index)
        } else {
            manager.addDownloadTask(name, fileURL: url, destinationPath: path.path)
        }
    }

    open func pauseTask(_ id: String, pathExtension: String? = nil) {
        let name = fileName(id, pathExtension: pathExtension)
        if let index = taskIndexMap[name] {
            manager.pauseDownloadTaskAtIndex(index)
        }
    }

    open func resumeTask(_ id: String, pathExtension: String? = nil) {
        let name = fileName(id, pathExtension: pathExtension)
        if let index = taskIndexMap[name] {
            manager.resumeDownloadTaskAtIndex(index)
        }
    }

    open func index(for id: String, pathExtension: String? = nil) -> Int? {
        let name = fileName(id, pathExtension: pathExtension)
        var i = 0
        for model in manager.downloadingArray {
            if model.fileName == name {
                return i
            }
            i += 1
        }
        return nil
    }
    
    open func addListener(_ listener: DownloadManagerListener) {
        listeners.append(listener)
    }
    
    open func removeListener(_ listener: DownloadManagerListener) {
        for i in 0 ..< listeners.count {
            if listeners[i] === listener {
                listeners.remove(at: i)
                break
            }
        }
    }
    
    open func removeAllListeners() {
        listeners.removeAll()
    }
    
}

extension DownloadManager: MZDownloadManagerDelegate {
    
    public enum DownloadManagerError: Error {
        case cancelled
        case notFound
    }
        
    open func downloadRequestDidUpdateProgress(_ downloadModel: MZDownloadModel, index: Int) {
        let progress = downloadModel.progress
        let name = bareName(fileName: downloadModel.fileName)
        let ext = pathExtension(fileName: downloadModel.fileName)
        
        for listener in listeners {
            listener.downloadProgressUpdated(name, pathExtension: ext, progress: progress)
        }
        print("Progress:", index, progress)
    }
    
    open func bareName(fileName: String) -> String {
        if let ext = pathExtension(fileName: fileName) {
            return fileName.replacingOccurrences(of: "." + ext, with: "")
        }
        return fileName
    }

    open func pathExtension(fileName: String) -> String? {
        if let url = URL(string: fileName) {
            return url.pathExtension
        }
        return nil
    }

    open func downloadRequestDidPopulatedInterruptedTasks(_ downloadModel: [MZDownloadModel]) {
        
    }
    
    open func downloadRequestStarted(_ downloadModel: MZDownloadModel, index: Int) {
        taskIndexMap[downloadModel.fileName] = index
        let name = bareName(fileName: downloadModel.fileName)
        let ext = pathExtension(fileName: downloadModel.fileName)

        for listener in listeners {
            listener.downloadResumed(name, pathExtension: ext)
        }
        print("Started:", index)
    }

    open func downloadRequestDidPaused(_ downloadModel: MZDownloadModel, index: Int) {
        let name = bareName(fileName: downloadModel.fileName)
        let ext = pathExtension(fileName: downloadModel.fileName)
        
        for listener in listeners {
            listener.downloadPaused(name, pathExtension: ext)
        }
        print("Paused:", index)
    }

    open func downloadRequestDidResumed(_ downloadModel: MZDownloadModel, index: Int) {
        let name = bareName(fileName: downloadModel.fileName)
        let ext = pathExtension(fileName: downloadModel.fileName)
        
        for listener in listeners {
            listener.downloadResumed(name, pathExtension: ext)
        }
        print("Resumed:", index)
    }

    open func downloadRequestDidRetry(_ downloadModel: MZDownloadModel, index: Int) {
        
    }

    open func downloadRequestCanceled(_ downloadModel: MZDownloadModel, index: Int) {
        taskIndexMap[downloadModel.fileName] = nil
        let name = bareName(fileName: downloadModel.fileName)
        let ext = pathExtension(fileName: downloadModel.fileName)

        for listener in listeners {
            listener.downloadFailed(name, pathExtension: ext, error: DownloadManagerError.cancelled as NSError)
        }
//        listeners.removeAll()
        print("Canceled:", index)
    }

    open func downloadRequestFinished(_ downloadModel: MZDownloadModel, index: Int) {
        taskIndexMap[downloadModel.fileName] = nil
        let name = bareName(fileName: downloadModel.fileName)
        let ext = pathExtension(fileName: downloadModel.fileName)

        for listener in listeners {
            listener.downloadFinished(name, pathExtension: ext, path: downloadModel.destinationPath)
        }
//        listeners.removeAll()
        print("Finished:", index)
    }

    open func downloadRequestDidFailedWithError(_ error: NSError, downloadModel: MZDownloadModel, index: Int) {
        taskIndexMap[downloadModel.fileName] = nil
        let name = bareName(fileName: downloadModel.fileName)
        let ext = pathExtension(fileName: downloadModel.fileName)

        for listener in listeners {
            listener.downloadFailed(name, pathExtension: ext, error: error)
        }
//        listeners.removeAll()
        print("Error:", index, error.localizedDescription)
    }

    open func downloadRequestDestinationDoestNotExists(_ downloadModel: MZDownloadModel, index: Int, location: URL) {
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

open class DefaultDownloadManagerListener: DownloadManagerListener {
    
    public unowned let model: MessagesModel
    
    public init(_ model: MessagesModel) {
        self.model = model
    }
    
    open func downloadProgressUpdated(_ id: String, pathExtension: String?, progress: Float) {
        if var message = message(for: id) {
            message.setDownloadProgress(progress)
        }
    }
    
    open func downloadFinished(_ id: String, pathExtension: String?, path: String) {
        if let message = message(for: id) {
            var url = URL(string: path + "/" + id)
            if let ext = pathExtension {
                url?.appendPathExtension(ext)
            }
            message.downloadFinished(url, error: nil)
        }
    }
    
    open func downloadFailed(_ id: String, pathExtension: String?, error: NSError) {
        if let message = message(for: id) {
            message.downloadFinished(nil, error: error)
        }
    }
    
    open func downloadResumed(_ id: String, pathExtension: String?) {
        if let message = message(for: id) {
            message.downloadStarted()
        }
    }

    open func downloadPaused(_ id: String, pathExtension: String?) {
        if let message = message(for: id) {
            message.downloadPaused()
        }
    }
    
    open func message(for id: String) -> DownloadableMessage? {
        return model.message(for: id) as? DownloadableMessage
    }
    
    open func update(id: String) {
        DispatchQueue.main.async { [weak self] in
            _ = self?.model.updateMessage(id: id).subscribe()
        }
    }

}
