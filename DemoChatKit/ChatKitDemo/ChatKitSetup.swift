//
//  ChatKitSetup.swift
//  ChatKitDemo
//
//  Created by ben3 on 27/07/2021.
//

import Foundation
import ChatKit
import RxSwift
import LoremIpsum
import AVFoundation

public class ChatKitSetup: ChatModelDelegate {
    

    public var model: ChatModel?
    public var thread: DummyThread?
    public let me = DummyUser(name: "Alice", isMe: true)
    public let other = DummyUser(name: "Bob", isMe: false)
    public var vc: ChatViewController?
    
    public func loadMessages(with oldestMessage: AbstractMessage?) -> Single<[AbstractMessage]> {
        Single<[AbstractMessage]>.create { single in
            single(.success([]))
            return Disposables.create {}
        }
    }
    
    public func initialMessages() -> [AbstractMessage] {
        return []
    }
    
    public func onClick(_ message: AbstractMessage) -> Bool {
        return true
    }
    
    public init() {
        
    }
    
    public func chatViewController() -> UIViewController {
        thread = DummyThread()
        model = ChatModel(thread!, delegate: self)
        
        let registrations = [
            MessageCellRegistration(messageType: MessageType.text().get(), contentClass: TextMessageContent.self),
            MessageCellRegistration(messageType: MessageType.image().get(), contentClass: ImageMessageContent.self),
            MessageCellRegistration(messageType: MessageType.location().get(), contentClass: ImageMessageContent.self),
            MessageCellRegistration(messageType: MessageType.audio().get(), contentClass: AudioMessageContent.self),
            MessageCellRegistration(messageType: MessageType.video().get(), contentClass: VideoMessageContent.self),
        ]
        

        model?.messagesModel.registerMessageCells(registrations: registrations)

        let vc = ChatViewController(model: model!)
        self.vc = vc

        model?.addSendBarAction(SendBarActions.send { [weak self] in
            if let text = vc.sendBarView.text(), let me = self?.me, let other = self?.other {
                _ = self?.model?.messagesModel.addMessage(toEnd: DummyMessage(user: me, text: text)).subscribe()
                _ = self?.model?.messagesModel.addMessage(toEnd: DummyMessage(user: other, text: LoremIpsum.sentence)).subscribe()
            }
            vc.sendBarView.clear()
            vc.messagesView.scrollToBottom()
        })
        
        model?.addSendBarAction(SendBarActions.mic {
            vc.showKeyboardOverlay(name: RecordKeyboardOverlay.key)
        })

        model?.addSendBarAction(SendBarActions.plus {
            vc.showKeyboardOverlay(name: OptionsKeyboardOverlay.key)
        })
        
        let optionsOverlay = OptionsKeyboardOverlay()
        
        // Setup options
        
        let options = [
            Option(galleryOnClick: { [weak self] in
                _ = self?.model?.messagesModel.addMessage(toEnd: DummyImageMessage(user: self!.me, name: "333", ext: "jpeg")).subscribe()
                vc.messagesView.scrollToBottom()
            }),
            Option(locationOnClick: { [weak self] in
                _ = self?.model?.messagesModel.addMessage(toEnd: DummyLocationMessage(user: self!.me, lat: 52.5065117, long: 13.1438722)).subscribe()
                vc.messagesView.scrollToBottom()
            }),
        ]
        
        optionsOverlay.setOptions(options: options)
        model?.addKeyboardOverlay(name: OptionsKeyboardOverlay.key, overlay: optionsOverlay)

        let recordOverlay = RecordKeyboardOverlay.new(ExampleRecordViewDelegate(setup: self, model: model!))
        model?.addKeyboardOverlay(name: RecordKeyboardOverlay.key, overlay: recordOverlay)

        return vc
    }
    
}

public class ExampleRecordViewDelegate: RecordViewDelegate {
    
    let model: ChatModel
    let setup: ChatKitSetup
    
    init(setup: ChatKitSetup, model: ChatModel) {
        self.model = model
        self.setup = setup
    }

    public func send(audio: Data, duration: Int) {
        _ = model.messagesModel.addMessage(toEnd: DummyAudioMessage(user: setup.me, audio: audio, duration: duration)).subscribe()
        setup.vc?.messagesView.scrollToBottom()
    }
}

open class DummyMessage: AbstractMessage {
    
    let id = String(Int.random(in: 0..<999999999))
    let date = Date()
    var text: String?
    let sender: User
    var type = MessageType.text()
    
    init(user: User, text: String?) {
        self.text = text
        self.sender = user
    }
    
    open override func messageId() -> String {
        return id
    }

    open override func messageDate() -> Date {
        return date
    }

    open override func messageText() -> String? {
        return text
    }

    open override func messageSender() -> User {
        return sender
    }
    
    open override func messageType() -> String {
        return type.get()
    }

    open override func messageDirection() -> MessageDirection {
        return sender.userIsMe() ? .outgoing : .incoming
    }

    open override func messageReadStatus() -> MessageReadStatus {
        return .none
    }

}

open class DummyAudioMessage: DummyMessage, AudioMessage {

    public var localAudioURL: URL?
    
    public let user: User
    let audio: Data
    let dur: Int
    
    var player: AVAudioPlayer?
    
    init(user: User, audio: Data, duration: Int) {

        self.isDownloading = false
        self.user = user
        self.audio = audio
        self.dur = duration

        super.init(user: user, text: nil)
        
        self.type = MessageType.audio()
        
        do {
            let url = try ChatKit.downloadManager().save(audio, messageId: messageId())
            localAudioURL = url
        } catch {
        }

    }
    
    public func duration() -> Double? {
        return Double(dur)
    }
    
    public func audioPlayer() -> AVAudioPlayer? {
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
    
    public func audioURL() -> URL? {
        return localAudioURL
    }
    
    public var isDownloading: Bool
    
    public func startDownload() {
        
    }
    
    public func isDownloaded() -> Bool {
        return true
    }
    
    public func downloadFinished(_ url: URL?, error: Error?) {
        
    }
    
    public func uploadFinished(_ data: Data?, error: Error?) {

    }
    
//    public func placeholder() -> UIImage? {
//        return nil
//    }
    
}

open class DummyImageMessage: DummyMessage, ImageMessage {
    
    public let url: URL?
    
    public init(user: User, name: String, ext: String) {
        url = Bundle.main.url(forResource: name, withExtension: ext)
        
        super.init(user: user, text: nil)
        
        self.type = MessageType.image()

    }

    public init(user: User, url: URL) {
        self.url = url
        super.init(user: user, text: nil)
        self.type = MessageType.image()
    }

    open func imageURL() -> URL? {
        return url
    }

    open func isUploaded() -> Bool {
        return false
    }
    
    open func uploadFinished(_ data: Data?, error: Error?) {

    }
    
    public func placeholder() -> UIImage? {
        return ChatKit.asset(icon: "icn_200_image_placeholder")
    }
    
}

open class DummyLocationMessage: DummyImageMessage {
    
    init(user: User, lat: Double, long: Double) {

        let googleMapsApiKey = "AIzaSyCwwtZrlY9Rl8paM0R6iDNBEit_iexQ1aE"
        let api = "https://maps.googleapis.com/maps/api/staticmap"
        let markers = String(format: "markers=%f,%f", lat, long)
        let size = String(format: "zoom=18&size=%ix%i", 300, 300)
        let key = String(format: "key=%@", googleMapsApiKey)
        let path = String(format: "%@?%@&%@&%@", api, markers, size, key)
        let url = URL(string: path)!

        super.init(user: user, url: url)
    }

}

public class DummyUser: User {
    

    let id = String(Int.random(in: 0..<999999999))
    let isMe: Bool
    let name: String

    init(name: String, isMe: Bool) {
        self.isMe = isMe
        self.name = name
    }
    
    public func userId() -> String {
        return id
    }
    
    public func userName() -> String {
        return name
    }
    
    public func userImageUrl() -> URL? {
        return nil
    }
    
    public func userImage() -> UIImage? {
        return nil
    }
    
    public func userIsMe() -> Bool {
        return isMe
    }
    
    public func userIsOnline() -> Bool {
        return true
    }
    
    public func userName() -> String? {
        "Dummy"
    }
    
}

public class DummyThread: Conversation {

    let id = String(Int.random(in: 0..<999999999))
   
    public func conversationId() -> String {
        return id
    }
    
    public func conversationName() -> String {
        return "Dummy"
    }
    
    public func conversationImageUrl() -> URL? {
        return nil
    }
    
    public func conversationUsers() -> [User] {
        return []
    }
    
    public func conversationType() -> ConversationType {
        return .private1to1
    }
    
    public func onAvatarClick(_ message: AbstractMessage) -> Bool {
        return false
    }

}
