//
//  Message.swift
//  AFNetworking
//
//  Created by ben3 on 18/07/2020.
//

import Foundation
import AVFoundation

public protocol IMessage {
    
    func messageId() -> String
    func messageType() -> String
    func messageDate() -> Date
    func messageText() -> String?
    func messageSender() -> User
    func messageImageUrl() -> URL?
    func messageMeta() -> [AnyHashable: Any]?
    func messageDirection() -> MessageDirection
    func messageReadStatus() -> MessageReadStatus
    func messageReply() -> Reply?
    func messageRemoteURL() -> URL?
    func messageContent() -> MessageContent?

}

public protocol DownloadableMessage: IMessage {
    
    func downloadFinished(_ url: URL?, error: Error?)
    
    func isDownloading() -> Bool
    func setIsDownloading(_ downloading: Bool)

    func downloadProgress() -> Float
    func setProgress(_ progress: Float)

    func messageLocalURL() -> URL?
    func setMessageLocalURL(_ url: URL?)
}

public extension DownloadableMessage {

    func startDownload() {
         if let url = messageRemoteURL() {
            ChatKit.downloadManager().startTask(messageId(), url: url.absoluteString)
        }
    }
    
    func pauseDownload() {
        ChatKit.downloadManager().pauseTask(messageId())
    }
    
    func downloadStarted() {
        setIsDownloading(true)
        if let content = messageContent() as? DownloadableContent {
            content.downloadStarted()
        }
    }

    func downloadPaused() {
        setIsDownloading(false)
        if let content = messageContent() as? DownloadableContent {
            content.downloadPaused()
        }
    }
}

public protocol IAudioMessage: DownloadableMessage {
    func duration() -> Double?
    func audioPlayer() -> AVAudioPlayer?
}

public class Message: IMessage, Hashable, Equatable {
    
    public var selected = false
    
    public var content: MessageContent?
    
    public func setContent(_ content: MessageContent) {
        self.content = content
    }
    
    public func sameDayAs(_ message: Message) -> Bool {
        return Calendar.current.isDate(messageDate(), inSameDayAs: message.messageDate())
    }
        
    public func messageId() -> String {
        preconditionFailure("This method must be overridden")
    }

    public func messageType() -> String {
        preconditionFailure("This method must be overridden")
    }

    public func messageDate() -> Date {
        preconditionFailure("This method must be overridden")
    }

    public func messageText() -> String? {
        return nil
    }

    public func messageSender() -> User {
        preconditionFailure("This method must be overridden")
    }

    public func messageImageUrl() -> URL? {
        return nil
    }

    public func messageMeta() -> [AnyHashable: Any]? {
        return nil
    }

    public func messageDirection() -> MessageDirection {
        preconditionFailure("This method must be overridden")
    }

    public func messageReadStatus() -> MessageReadStatus {
        preconditionFailure("This method must be overridden")
    }
    
    public func messageReply() -> Reply? {
        return nil
    }
    
    public func isSelected() -> Bool {
        return selected
    }
    
    public func setSelected(_ selected: Bool) {
        self.selected = selected
    }

    public func toggleSelected() {
        selected = !selected
    }
    
    public static func == (lhs: Message, rhs: Message) -> Bool {
        return lhs.messageId() == rhs.messageId()
    }
        
    public func messageRemoteURL() -> URL? {
        return nil
    }
    
//    public func messageLocalURL() -> URL? {
//        return nil
//    }
//    
//    public func setMessageLocalURL(_ url: URL?) {
//        preconditionFailure("This method must be overridden")
//    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(messageId())
    }
    
    public func messageContent() -> MessageContent? {
        return content
    }

}
