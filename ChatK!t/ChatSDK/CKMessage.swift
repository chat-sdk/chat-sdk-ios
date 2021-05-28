//
//  CKMessage.swift
//  ChatSDKSwift
//
//  Created by ben3 on 19/07/2020.
//  Copyright © 2020 deluge. All rights reserved.
//

import Foundation
import ChatSDK

public class CKMessage: Message {

    let message: PMessage
    
    lazy var sender = CKUser(user: message.user())
    lazy var text = message.text()
    lazy var entityId = message.entityID()
    lazy var date = message.date()
    lazy var type = message.type()?.stringValue
    lazy var meta = message.meta()
    lazy var imageUrl = message.imageURL()
    lazy var direction: MessageDirection = message.senderIsMe() ? .outgoing : .incoming

    public init(message: PMessage) {
        self.message = message
    }
    
    public override func messageId() -> String {
        return entityId!
    }

    public override func messageDate() -> Date {
        return date!
    }

    public override func messageText() -> String? {
        return text
    }

    public override func messageSender() -> User {
        return sender
    }

    public override func messageImageUrl() -> URL? {
        return imageUrl
    }
    
    public override func messageType() -> String {
        return type!
    }
    
    public override func messageMeta() -> [AnyHashable: Any]? {
        return meta!
    }
    
    public override func messageDirection() -> MessageDirection {
        return direction
    }

    public override func messageReadStatus() -> MessageReadStatus {
        if BChatSDK.readReceipt() != nil && messageDirection() == .outgoing {
            if let status = message.messageReadStatus?() {
                if status == bMessageReadStatusRead {
                    return .read
                }
                else if status == bMessageReadStatusDelivered {
                    return .delivered
                }
                else {
                    return .sent
                }
            }
        }
        return .none
    }
    
    public override func messageReply() -> Reply? {
        if message.isReply() {
            // Get the user's name
            var fromUser: PUser?
            if let fromId = message.meta()[bFrom] as? String, let from = BChatSDK.db().fetchEntity(withID: fromId, withType: bUserEntity) as? PUser {
                fromUser = from
            }
            if fromUser == nil {
                if let fromId = message.meta()[bId] as? String, let originalMessage = BChatSDK.db().fetchEntity(withID: fromId, withType: bMessageEntity) as? PMessage {
                    fromUser = originalMessage.user()
                }
            }
            return CKReply(name: fromUser?.name(), text: message.reply(), imageURL: message.imageURL())
        }
        return nil
    }

    public static func new(for message: PMessage) -> CKMessage {
        if message.type().intValue == bMessageTypeAudio.rawValue {
            return CKAudioMessage(message: message)
        }
        if message.type().intValue == bMessageTypeImage.rawValue {
            return CKDownloadableMessage(message: message)
        }
        return CKMessage(message: message)
    }

}

public class CKDownloadableMessage: CKMessage, DownloadableMessage {
    
    public var downloading = false
    public var progress: Float = 0 {
        willSet {
            print("Hi")
        }
    }
    
    public override init(message: PMessage) {
        super.init(message: message)
        if let url = ChatKit.downloadManager().localURL(for: message.entityID()) {
            setMessageLocalURL(URL(string: url))
        }
    }

    public func setIsDownloading(_ downloading: Bool) {
        self.downloading = downloading
    }

    public func downloadProgress() -> Float {
        return progress
    }
    
    public func setProgress(_ progress: Float) {
        self.progress = progress
        if let content = content as? DownloadableContent {
            content.setProgress(progress)
        }
    }

    public func isDownloading() -> Bool {
        return downloading
    }
    
    public func setMessageLocalURL(_ url: URL?) {
        message.setMetaValue?(url?.path, forKey: "local-url")
    }
    
    public func messageLocalURL() -> URL? {
        if let local = message.meta()["local-url"] as? String, let url = URL(string: local) {
            return url
        }
        return nil
    }
    
    public func downloadFinished(_ url: URL?, error: Error? = nil) {
        downloading = false
        if let content = content as? DownloadableContent {
            content.downloadFinished(url, error: error)
        }
    }
            
}

public class TestDownload: CKDownloadableMessage {
    
    public override var progress: Float {
        willSet {
            print("Hi")
        }
    }
    
}

public class CKAudioMessage: CKDownloadableMessage, IAudioMessage {

    var player: AVAudioPlayer?
    
    public func audioPlayer() -> AVAudioPlayer? {
        return player ?? {
            if let url = messageLocalURL() {
                do {
                    player = try AVAudioPlayer(contentsOf: url)
                    player?.prepareToPlay()
                } catch {
                    
                }
            }
            return player
        }()
    }
    
    public func duration() -> Double? {
        if let length = message.meta()[bMessageAudioLength] as? NSNumber {
            return length.doubleValue
        }
        return nil
    }
    
    public func seekPosition() -> TimeInterval {
        if let position = message.meta()["seek"] as? TimeInterval {
            return position
        }
        return 0
    }

    public func setSeekPosition(_ position: TimeInterval) {
        message.setMetaValue?(position, forKey: "seek")
    }

    public override func messageRemoteURL() -> URL? {
        if let path = message.meta()[bMessageAudioURL] as? String {
            return URL(string: path)
        }
        return nil
    }

}

