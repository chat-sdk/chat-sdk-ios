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
    
    func messageRemotePath() -> URL?
    func messageLocalPath() -> URL?
}

public protocol Downloadable {
    func startDownload()
    func pauseDownload()
    func isDownloading() -> Bool
    func downloadProgress() -> Float
}

public protocol IAudioMessage: IMessage, Downloadable {
    func duration() -> Double?
//    func seekPosition() -> TimeInterval
//    func setSeekPosition(_ position: TimeInterval)
    func audioPlayer() -> AVAudioPlayer?
}

public class Message: IMessage, Hashable, Equatable {
    
    var selected = false
    
    var content: MessageContent?
    
    func setContent(_ content: MessageContent) {
        self.content = content
    }
    
    func sameDayAs(_ message: Message) -> Bool {
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
        
    public func messageRemotePath() -> URL? {
        return nil
    }
    
    public func messageLocalPath() -> URL? {
        return nil
    }

//
////    public var hashValue: Int {
////        return self.messageId().hashValue
////    }
//
//    public static func == (lhs: Message, rhs: Message) -> Bool {
//        return lhs.messageId() == rhs.messageId()
//    }
//
    public func hash(into hasher: inout Hasher) {
        hasher.combine(messageId())
    }

}

//public class AudioMessage: Message, IAudioMessage {
//
//    public func duration() -> Double? {
//        preconditionFailure("This method must be overridden")
//    }
//
//    public func startDownload() {
//        preconditionFailure("This method must be overridden")
//    }
//
//    public func pauseDownload() {
//        preconditionFailure("This method must be overridden")
//    }
//
//    public func localPath() -> URL? {
//        return nil
//    }
//
//}

//extension Message: Hashable, Equatable {
//
//}
