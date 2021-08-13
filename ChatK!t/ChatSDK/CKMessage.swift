//
//  CKMessage.swift
//  ChatSDKSwift
//
//  Created by ben3 on 19/07/2020.
//  Copyright © 2020 deluge. All rights reserved.
//

import Foundation
import ChatSDK

open class CKMessage: AbstractMessage {

    let message: PMessage
    
    lazy var sender = CKUser(user: message.user())
    lazy var entityId = message.entityID()
    lazy var date = message.date()
    lazy var type = message.type()?.stringValue
    lazy var direction: MessageDirection = message.senderIsMe() ? .outgoing : .incoming

    public init(message: PMessage) {
        self.message = message
    }
    
    open override func messageId() -> String {
        return entityId!
    }

    open override func messageDate() -> Date {
        return date!
    }

    open override func messageText() -> String? {
        if message.isReply() {
            return message.reply()
        } else {
            return message.text()
        }
    }

    open override func messageSender() -> User {
        return sender
    }
    
    open override func messageType() -> String {
        return type!
    }
    
    open override func messageMeta() -> [AnyHashable: Any]? {
        return message.meta()
    }
    
    open override func messageDirection() -> MessageDirection {
        return direction
    }

    open override func messageReadStatus() -> MessageReadStatus {
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
    
    open override func messageReply() -> Reply? {
        if message.isReply() {
            // Get the user's name
            var originalMessage: PMessage?
            var ckMessage: CKMessage?
            if let mid = messageMeta()?[bId] as? String {
                originalMessage = BChatSDK.db().fetchEntity(withID: mid, withType: bMessageEntity) as? PMessage
                ckMessage = CKMessageStore.shared().message(with: mid)
            }
            var fromUser = originalMessage?.user()
            if fromUser == nil, let fromId = messageMeta()?[bFrom] as? String, let from = BChatSDK.db().fetchEntity(withID: fromId, withType: bUserEntity) as? PUser {
                fromUser = from
            }
                        
            return CKReply(name: fromUser?.name(), text: message.text(), imageURL: message.imageURL(), placeholder: ckMessage?.placeholder())
        }
        return nil
    }

    open func placeholder() -> UIImage? {
        if let data = message.placeholder() {
            return UIImage(data: data)
        }
        return nil
    }
}

open class CKDownloadableMessage: CKMessage, DownloadableMessage, UploadableMessage {
    
    open var isDownloading: Bool = false
    
    public override init(message: PMessage) {
        super.init(message: message)
    }
        
    open func downloadFinished(_ url: URL?, error: Error? = nil) {
        isDownloading = false
        if let content = content as? DownloadableContent {
            content.downloadFinished(url, error: error)
        }
    }

    open func startDownload() {
        isDownloading = true
    }
    
    open func downloadPaused() {
        isDownloading = false
    }

    open func isDownloaded() -> Bool {
        preconditionFailure("This method must be overridden")
    }

    open func uploadFinished(_ data: Data?, error: Error?) {
        preconditionFailure("This method must be overridden")
    }

}

open class CKImageMessage: CKMessage, ImageMessage {
    
    open func imageURL() -> URL? {
        return message.imageURL()
    }

    open func isUploaded() -> Bool {
        return message.imageURL() != nil
    }
    
    open func uploadFinished(_ data: Data?, error: Error?) {

    }

}

open class CKLocationMessage: CKImageMessage {
    
    open override func imageURL() -> URL? {
        if let longitude = messageMeta()?[bMessageLongitude] as? NSNumber, let latitude = messageMeta()?[bMessageLatitude] as? NSNumber {
//            let size = Int(ChatKit.config().imageMessageSize) * 3
            let size = ChatKit.config().imageMessageSize
            let w = Int(size.width) * 3
            let h = Int(size.height) * 3
            if let url = GoogleUtils.getMapImageURL(latitude: latitude.doubleValue, longitude: longitude.doubleValue, width: w, height: h) {
                return URL(string: url)
            }
        }
        return nil
    }

}

open class CKVideoMessage: CKDownloadableMessage, ImageMessage, VideoMessage {

    open var localVideoURL: URL?
    
    public override init(message: PMessage) {
        super.init(message: message)
        // Get the file type
        
        if let url = ChatKit.downloadManager().localURL(for: messageId(), pathExtension: pathExtension()) {
            localVideoURL = url
        }

    }
    
    open func videoURL() -> URL? {
        if let url = messageMeta()?[bMessageVideoURL] as? String {
            return URL(string: url)
        }
        return nil
    }

    open func imageURL() -> URL? {
        return message.imageURL()
    }

    open override func startDownload() {
        if let path = messageMeta()?[bMessageVideoURL] as? String {
            ChatKit.downloadManager().startTask(messageId(), pathExtension: pathExtension(), url: path)
        }
    }
    
    open override func downloadFinished(_ url: URL?, error: Error? = nil) {
        localVideoURL = url
        super.downloadFinished(url, error: error)
    }
    
    open override func uploadFinished(_ data: Data?, error: Error?) {
        // Get the local video URL
        if let content = messageContent() as? UploadableContent {
            if let data = data {
                do {
                    let url = try ChatKit.downloadManager().save(data, messageId: messageId(), pathExtension: pathExtension())
                    localVideoURL = url
                    content.uploadFinished(url, error: nil)
                } catch {
                    content.uploadFinished(nil, error: error)
                }
            } else {
                content.uploadFinished(nil, error: error)
            }
        }
    }
        
    open func pathExtension() -> String? {
        if let path = messageMeta()?[bMessageVideoURL] as? String, let url = URL(string: path) {
            return url.pathExtension
        }
        return nil
    }
    
    open override func isDownloaded() -> Bool {
        return localVideoURL != nil
    }

}

open class CKAudioMessage: CKDownloadableMessage, AudioMessage {

    open var localAudioURL: URL?

    open var player: AVAudioPlayer?
    
    public override init(message: PMessage) {
        super.init(message: message)
        localAudioURL = ChatKit.downloadManager().localURL(for: messageId())
    }
    
    open func audioPlayer() -> AVAudioPlayer? {
        return player ?? {
            if let url = localAudioURL {
                do {
                    player = try AVAudioPlayer(contentsOf: url)
                    player?.prepareToPlay()
                } catch {
                    
                }
            }
            return player
        }()
    }
    
    open func duration() -> Double? {
        if let length = messageMeta()?[bMessageAudioLength] as? NSNumber {
            return length.doubleValue
        }
        return nil
    }
    
    open func seekPosition() -> TimeInterval {
        if let position = messageMeta()?["seek"] as? TimeInterval {
            return position
        }
        return 0
    }

    open func setSeekPosition(_ position: TimeInterval) {
        message.setMetaValue?(position, forKey: "seek")
    }

    open func audioURL() -> URL? {
        if let path = messageMeta()?[bMessageAudioURL] as? String {
            return URL(string: path)
        }
        return nil
    }
    
    open override func downloadFinished(_ url: URL?, error: Error? = nil) {
        localAudioURL = url
        super.downloadFinished(url, error: error)
    }

    open override func startDownload() {
         if let url = messageMeta()?[bMessageAudioURL] as? String {
            ChatKit.downloadManager().startTask(messageId(), url: url)
        }
    }
    
    open override func uploadFinished(_ data: Data?, error: Error?) {
        // Get the local video URL
        if let content = messageContent() as? UploadableContent {
            if let data = data {
                do {
                    let url = try ChatKit.downloadManager().save(data, messageId: messageId())
                    localAudioURL = url
                    content.uploadFinished(url, error: nil)
                } catch {
                    content.uploadFinished(nil, error: error)
                }
            } else {
                content.uploadFinished(nil, error: error)
            }
        }
    }
    
    open override func isDownloaded() -> Bool {
        return localAudioURL != nil
    }
            
    open override func placeholder() -> UIImage? {
        return ChatKit.asset(icon: "icn_100_audio_reply")
    }

}


