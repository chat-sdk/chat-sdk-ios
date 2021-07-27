//
//  ChatKitSetup.swift
//  ChatSDKSwift
//
//  Created by ben3 on 18/04/2021.
//  Copyright © 2021 deluge. All rights reserved.
//

import Foundation
import ChatSDK
import AVKit

public protocol MessageProvider {
    func new(for message: PMessage) -> CKMessage
}

public protocol OnCreateListener {
    func onCreate(for vc: ChatViewController, model: ChatModel, thread: PThread)
}

public protocol OptionProvider {
    func provide(for vc: ChatViewController, thread: PThread) -> Option
}

@objc open class ChatKitModule: NSObject, PModule {
    
    static let instance = ChatKitModule()
    @objc public static func shared() -> ChatKitModule {
        return instance
    }

    open var model: ChatModel?
    open var vc: ChatViewController?
    open var thread: PThread?
    open var locationAction: BSelectLocationAction?

    open var onCreateListeners = [OnCreateListener]()

    open var messageRegistrations = [MessageCellRegistration]()
    open var newMessageProviders = [Int: MessageProvider]()
    open var optionProviders = [OptionProvider]()

    open func add(optionProvider: OptionProvider) {
        optionProviders.append(optionProvider)
    }

    open func add(messageRegistration: MessageCellRegistration) {
        messageRegistrations.append(messageRegistration)
    }

    open func add(newMessageProvider: MessageProvider, type: Int) {
        newMessageProviders[type] = newMessageProvider
    }

    open func add(onCreateListener: OnCreateListener) {
        onCreateListeners.append(onCreateListener)
    }

    open func activate() {
        
        BChatSDK.ui().setChatViewController({ [weak self] (thread: PThread?) -> UIViewController? in
            if let thread = thread {
                return self?.chatViewController(thread)
            }
            return nil
        })

        // Add a listener to add outgoing messages to the download area so we don't have to download them again...
        BChatSDK.hook().add(BHook({ [weak self] input in
            if let message = input?[bHook_PMessage] as? PMessage, let data = input?[bHook_NSData] as? Data {
                if let m = self?.model?.messagesModel.message(for: message.entityID()) as? UploadableMessage {
                        // Get the extension
                    m.uploadFinished(data, error: nil)
                    _ = self?.model?.messagesModel.updateMessage(id: message.entityID())
                }
            }
        }), withName: bHookMessageDidUpload)

        // Add a listener to add outgoing messages to the download area so we don't have to download them again...
        BChatSDK.hook().add(BHook(onMain: { [weak self] input in
            self?.updateConnectionStatus()
        }), withNames: [bHookInternetConnectivityDidChange, bHookServerConnectionStatusUpdated])
                
        BChatSDK.hook().add(BHook({ [weak self] input in
            if let message = input?[bHook_PMessage] as? PMessage {
                if let m = self?.model?.messagesModel.message(for: message.entityID()), let content = m.messageContent() as? UploadableContent {
                    content.uploadStarted()
                }
            }
        }, weight: 50), withName: bHookMessageWillUpload)
        
        BChatSDK.hook().add(BHook({ [weak self] input in
            if let message = input?[bHook_PMessage] as? PMessage, let progress = input?[bHook_ObjectValue] as? Progress {
                if let content = self?.model?.messagesModel.message(for: message.entityID())?.messageContent() as? UploadableContent {
                    //
                    let total = Float(progress.totalUnitCount)
                    let current = Float(progress.completedUnitCount)
                    
                    content.setUploadProgress(current / total)
                }
            }
        }), withName: bHookMessageUploadProgress)
        
        _ = BChatSDK.hook().add(BHook({ [weak self] data in
            if let thread = data?[bHook_PThread] as? PThread, thread.isEqual(self?.thread) {
                if let text = data?[bHook_NSString] as? String {
                    self?.vc?.setSubtitle(text: text)
                } else {
                    self?.vc?.setSubtitle()
                }
            }
        }), withName: bHookTypingStateUpdated)

        _ = BChatSDK.hook().add(BHook({ [weak self] data in
            if let thread = self?.thread, let user = data?[bHook_PUser] as? PUser {
                if thread.contains(user) {
                    self?.vc?.setSubtitle()
                }
            }
        }), withName: bHookUserUpdated)
        
        _ = BChatSDK.hook().add(BHook({ [weak self] data in
            if  let thread = data?[bHook_PThread] as? PThread, thread.isEqual(to: self?.thread), let user = data?[bHook_PUser] as? PUser, user.isMe() {
                self?.updateRightBarButtonItem()
                let hasVoice = BChatSDK.thread().hasVoice(thread.entityID(), forUser: user.entityID())
                self?.vc?.setReadOnly(!hasVoice)
            }
        }), withName: bHookThreadUserRoleUpdated)
        
        // Add the observers
        BChatSDK.hook().add(BHook(onMain: { [weak self] data in
            if let message = data?[bHook_PMessage] as? PMessage, let t = message.thread(), let user = message.userModel(), let thread = self?.thread {
                if (t.isEqual(thread)) {
                    if !user.isMe() {
                        self?.markRead(thread: thread)
                    } else {
                        message.setDelivered(true)
                    }
                    if let message = CKMessageStore.shared().message(with: message.entityID()) {
                        _ = self?.model?.messagesModel.updateMessage(id: message.messageId(), animated: false).subscribe()
                    } else {
                        _ = self?.model?.messagesModel.addMessage(toEnd: CKMessageStore.shared().message(for: message), animated: true, scrollToBottom: true).subscribe()
                    }
                }
            }
        }), withNames: [bHookMessageWillSend, bHookMessageRecieved, bHookMessageWillUpload])
                
        BChatSDK.hook().add(BHook(onMain: { [weak self] data in
            if let message = data?[bHook_PMessage] as? PMessage, let t = message.thread(), let thread = self?.thread {
                if t.isEqual(thread) {
                    _ = self?.model?.messagesModel.updateMessage(id: message.entityID(), animated: false).subscribe()
                }
            }
        }), withName: bHookMessageReadReceiptUpdated)

        BChatSDK.hook().add(BHook(onMain: { [weak self] data in
            if let id = data?[bHook_StringId] as? String, let message = CKMessageStore.shared().message(with: id) {
                _ = self?.model?.messagesModel.removeMessage(message).subscribe(onCompleted: {
                    
                })
            }
        }), withName: bHookMessageWasDeleted)
    }
    
    open func chatViewController(_ thread: PThread) -> UIViewController? {
        let ckThread = CKThread(thread)

        let model = ChatModel(ckThread, delegate: self)
        self.model = model
        self.thread = thread
        
        // Connect up the download manager so we can update the cell when
        // the message download updates
        ChatKit.downloadManager().addListener(DefaultDownloadManagerListener(model.messagesModel))
        
        //
        // Cell registrations
        //
        
        // Map the message type to a content view type
        var registrations = [
            MessageCellRegistration(messageType: String(bMessageTypeText.rawValue), contentClass: TextMessageContent.self),
            MessageCellRegistration(messageType: String(bMessageTypeImage.rawValue), contentClass: ImageMessageContent.self),
            MessageCellRegistration(messageType: String(bMessageTypeLocation.rawValue), contentClass: ImageMessageContent.self),
        ]
        
        if BChatSDK.audioMessage() != nil {
            registrations.append(MessageCellRegistration(messageType: String(bMessageTypeAudio.rawValue), contentClass: AudioMessageContent.self))
        }
        if BChatSDK.videoMessage() != nil {
            registrations.append(MessageCellRegistration(messageType: String(bMessageTypeVideo.rawValue), contentClass: VideoMessageContent.self))
        }

        for reg in self.messageRegistrations {
            registrations.append(reg)
        }

        model.messagesModel.registerMessageCells(registrations: registrations)
        
        // Create the chat view controller
        let vc = ChatViewController(model: model)
        vc.delegate = self
        vc.typingDelegate = self
        
        self.vc = vc
        
        vc.addRightBarButtonItem(item: UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil), action: { [weak self] item in
            if let thread = self?.thread {
                let flvc = BChatSDK.ui().friendsViewControllerWithUsers(toExclude: Array(thread.users()), onComplete: { users, name in
                    BChatSDK.thread().addUsers(users, to: thread)
                })
                flvc?.setRightBarButtonActionTitle(Bundle.t(bAdd))
                flvc?.hideGroupNameView = true
                flvc?.maximumSelectedUsers = 0
                
                vc.present(UINavigationController(rootViewController: flvc!), animated: true, completion: nil)
            }
        })

        addSendBarActions(model: model, vc: vc, thread: thread)
        addToolbarActions(model: model, vc: vc, thread: thread)

        let optionsOverlay = OptionsKeyboardOverlay()

        var options = getOptions(vc: vc, thread: thread)
        for provider in optionProviders {
            options.append(provider.provide(for: vc, thread: thread))
        }
        optionsOverlay.setOptions(options: options)
        model.addKeyboardOverlay(name: OptionsKeyboardOverlay.key, overlay: optionsOverlay)

        let recordOverlay = RecordKeyboardOverlay.new(ChatSDKRecordViewDelegate(thread.entityID()))
        
        model.addKeyboardOverlay(name: RecordKeyboardOverlay.key, overlay: recordOverlay)
                
        vc.headerView.onTap = {
            vc.present(BChatSDK.ui().usersViewNavigationController(with: thread, parentNavigationController: vc.navigationController), animated: true, completion: nil)
        }
        
        markRead(thread: thread)
        
        for listener in onCreateListeners {
            listener.onCreate(for: vc, model: model, thread: thread)
        }

        return vc
    }
    
    open func markRead(thread: PThread) {
        if vc != nil {
            if let rr = BChatSDK.readReceipt() {
                rr.markRead(thread)
            } else {
                thread.markRead()
            }
        }
    }
        
    open func updateConnectionStatus() {
        let connectionStatus = BChatSDK.core().connectionStatus?() ?? bConnectionStatusConnected
        let status = ConnectionStatus.init(rawValue: Int(connectionStatus.rawValue))
        let connected = BChatSDK.connectivity().isConnected()

        vc?.updateConnectionStatus(status)

        vc?.navigationItem.rightBarButtonItem?.isEnabled = connected
        if connected && status == .connected {
            vc?.goOnline()
        } else {
            vc?.goOffline()
        }
    }
    
    open func updateRightBarButtonItem() {
        if let thread = thread {
            vc?.navigationItem.rightBarButtonItem?.isEnabled = BChatSDK.thread().canAddUsers(thread.entityID())
        } else {
            vc?.navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    
}

open class ChatSDKRecordViewDelegate: RecordViewDelegate {
    let threadEntityID: String
    init(_ threadEntityID: String) {
        self.threadEntityID = threadEntityID
    }
    open func send(audio: Data, duration: Int) {
        // Save this file to the standard directory
        BChatSDK.audioMessage().sendMessage(withAudio: audio, duration: Double(duration), withThreadEntityID: threadEntityID)
    }
}

extension ChatKitModule: ChatModelDelegate {
        
    open func loadMessages(with oldestMessage: AbstractMessage?) -> Single<[AbstractMessage]> {
        return Single<[AbstractMessage]>.create { [weak self] single in
            if let model = self?.model?.messagesModel, let thread = BChatSDK.db().fetchEntity(withID: model.conversation.conversationId(), withType: bThreadEntity) as? PThread {
                _ = BChatSDK.thread().loadMoreMessages(from: oldestMessage?.messageDate(), for: thread).thenOnMain({ success in
                    if let messages = success as? [PMessage] {
                        single(.success(ChatKitModule.convert(messages)))
                    } else {
                        single(.success([]))
                    }
                    return success
                }, { error in
                    single(.success([]))
                    return error
                })
            }
            return Disposables.create {}
        }
    }
    
    open func initialMessages() -> [AbstractMessage] {
        var messages = [AbstractMessage]()
        if let model = model?.messagesModel, let thread = BChatSDK.db().fetchEntity(withID: model.conversation.conversationId(), withType: bThreadEntity) as? PThread {
            if let msgs = BChatSDK.db().loadMessages(for: thread, newest: 25) {
                for message in msgs {
                    if let message = message as? PMessage {
                        messages.insert(CKMessageStore.shared().message(for: message), at: 0)
                    }
                }
            }
        }
        return messages
    }
        
    public static func convert(_ messages: [PMessage]) -> [AbstractMessage] {
        var output = [AbstractMessage]()
        for message in messages {
            output.append(CKMessage(message: message))
        }
        return output
    }
    
    open func onClick(_ message: AbstractMessage) -> Bool {
        if message.messageType() == String(bMessageTypeVideo.rawValue) {
            
            if let message = message as? VideoMessage, let url = message.localVideoURL {
                do {
                    try AVAudioSession.sharedInstance().setCategory(.playback)
                    let fileURL = URL(fileURLWithPath: url.path)
                    
                    let player = AVPlayer(url: fileURL.absoluteURL)
                    let playerController = AVPlayerViewController()
                    playerController.player = player
                    vc?.present(playerController, animated: true, completion: nil)
                } catch {
                    
                }
            }
            
            return true
        }
        if message.messageType() == String(bMessageTypeImage.rawValue) {
            // get the image URL
            
            if let ivc = BChatSDK.ui().imageViewController(), let message = message as? ImageMessage, let url = message.imageURL() {
                ivc.setImageURL(url)
                vc?.present(UINavigationController(rootViewController: ivc), animated: true, completion: nil)
            }
            return true
        }
        if message.messageType() == String(bMessageTypeFile.rawValue) {
            
            return true
        }
        if message.messageType() == String(bMessageTypeLocation.rawValue) {
            if let longitude = message.messageMeta()?[bMessageLongitude] as? NSNumber, let latitude = message.messageMeta()?[bMessageLatitude] as? NSNumber {
                if let nvc = BChatSDK.ui().locationViewController() {
                    nvc.setLatitude(latitude.doubleValue, longitude: longitude.doubleValue)
                    vc?.present(UINavigationController(rootViewController: nvc), animated: true, completion: nil)
                }
            }
            return true
        }
        return false
    }
}

extension ChatKitModule: ChatViewControllerTypingDelegate {

    open func didStartTyping() {
        if let thread = thread, let indicator = BChatSDK.typingIndicator() {
            indicator.setChatState(bChatStateComposing, for: thread)
        }
    }
    
    open func didStopTyping() {
        if let thread = thread, let indicator = BChatSDK.typingIndicator() {
            indicator.setChatState(bChatStateActive, for: thread)
        }
    }
    
}

extension ChatKitModule: ChatViewControllerDelegate {
    open func viewDidLoad() {
        updateRightBarButtonItem()
        updateConnectionStatus()
    }
    
    open func viewWillAppear() {

    }
    
    open func viewDidAppear() {
        if let thread = thread {
            if thread.typeIs(bThreadFilterPublic) {
                BChatSDK.thread().addUsers([BChatSDK.currentUser()], to: thread)
            }
        }
    }

    open func viewWillDisappear() {
        
    }
    
    open func viewDidDisappear() {
        vc = nil
        if let thread = thread {
            if thread.typeIs(bThreadFilterPublic) && (!BChatSDK.config().publicChatAutoSubscriptionEnabled || thread.meta()[bMute] != nil) {
                BChatSDK.thread().removeUsers([BChatSDK.currentUserID()], fromThread: thread.entityID())
            }
        }
    }
    
}

