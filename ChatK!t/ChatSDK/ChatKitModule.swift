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

    open var integration: ChatKitIntegration?
    
    open func get() -> ChatKitIntegration {
        if integration == nil {
            integration = ChatKitIntegration()
        }
        return integration!
    }

    open func with(integration: ChatKitIntegration) -> ChatKitModule {
        self.integration = integration
        return self
    }
    
    open func activate() {
        get().activate()
    }
}

open class ChatKitIntegration: NSObject, ChatViewControllerDelegate, ChatModelDelegate, ChatViewControllerTypingDelegate, RecordViewDelegate {
    
    open unowned var model: ChatModel?

    open weak var weakVC: ChatViewController?

    open var thread: PThread?
    open var locationAction: BSelectLocationAction?

    open var onCreateListeners = [OnCreateListener]()

    open var messageRegistrations = [MessageCellRegistration]()
    open var newMessageProviders = [Int: MessageProvider]()
    open var optionProviders = [OptionProvider]()
    
    open var observers = BNotificationObserverList()

    public override init() {
        super.init()
    }
    
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
    
    open func addObservers() {

        // Add a listener to add outgoing messages to the download area so we don't have to download them again...
        observers.add(BChatSDK.hook().add(BHook({ [weak self] input in
            if let message = input?[bHook_PMessage] as? PMessage, let data = input?[bHook_NSData] as? Data {
                if let m = self?.model?.messagesModel.message(for: message.entityID()) as? UploadableMessage {
                        // Get the extension
                    m.uploadFinished(data, error: nil)
                    _ = self?.model?.messagesModel.updateMessage(id: message.entityID())
                }
            }
        }), withName: bHookMessageDidUpload))

        // Add a listener to add outgoing messages to the download area so we don't have to download them again...
        observers.add(BChatSDK.hook().add(BHook(onMain: { [weak self] input in
            self?.updateConnectionStatus()
        }), withNames: [bHookInternetConnectivityDidChange, bHookServerConnectionStatusUpdated]))
                
        observers.add(BChatSDK.hook().add(BHook({ [weak self] input in
            if let message = input?[bHook_PMessage] as? PMessage {
                if let m = self?.model?.messagesModel.message(for: message.entityID()), let content = m.messageContent() as? UploadableContent {
                    content.uploadStarted()
                }
            }
        }, weight: 50), withName: bHookMessageWillUpload))
        
        observers.add(BChatSDK.hook().add(BHook({ [weak self] input in
            if let message = input?[bHook_PMessage] as? PMessage, let progress = input?[bHook_ObjectValue] as? Progress {
                if let content = self?.model?.messagesModel.message(for: message.entityID())?.messageContent() as? UploadableContent {
                    //
                    let total = Float(progress.totalUnitCount)
                    let current = Float(progress.completedUnitCount)
                    
                    content.setUploadProgress(current / total)
                }
            }
        }), withName: bHookMessageUploadProgress))
        
        observers.add(BChatSDK.hook().add(BHook({ [weak self] data in
            if let thread = data?[bHook_PThread] as? PThread, thread.isEqual(self?.thread) {
                if let text = data?[bHook_NSString] as? String {
                    self?.weakVC?.setSubtitle(text: text)
                } else {
                    self?.weakVC?.setSubtitle()
                }
            }
        }), withName: bHookTypingStateUpdated))

        observers.add(BChatSDK.hook().add(BHook({ [weak self] data in
            if let thread = self?.thread, let user = data?[bHook_PUser] as? PUser {
                if thread.contains(user) {
                    self?.weakVC?.setSubtitle()
                }
            }
        }), withName: bHookUserUpdated))
        
        observers.add(BChatSDK.hook().add(BHook({ [weak self] data in
            if  let thread = data?[bHook_PThread] as? PThread, thread.isEqual(to: self?.thread), let user = data?[bHook_PUser] as? PUser, user.isMe() {
                self?.updateViewForPermissions(user, thread: thread)
            }
        }), withName: bHookThreadUserRoleUpdated))
        
        // Add the observers
        observers.add(BChatSDK.hook().add(BHook(onMain: { [weak self] data in
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
        }), withNames: [bHookMessageWillSend, bHookMessageRecieved, bHookMessageWillUpload]))
                
        observers.add(BChatSDK.hook().add(BHook(onMain: { [weak self] data in
            if let message = data?[bHook_PMessage] as? PMessage, let t = message.thread(), let thread = self?.thread {
                if t.isEqual(thread) {
                    _ = self?.model?.messagesModel.updateMessage(id: message.entityID(), animated: false).subscribe()
                }
            }
        }), withName: bHookMessageReadReceiptUpdated))

        observers.add(BChatSDK.hook().add(BHook(onMain: { [weak self] data in
            if let id = data?[bHook_StringId] as? String, let message = CKMessageStore.shared().message(with: id) {
                _ = self?.model?.messagesModel.removeMessage(message).subscribe(onCompleted: {
                    
                })
            }
        }), withName: bHookMessageWasDeleted))
        
        observers.add(BChatSDK.hook().add(BHook(onMain: { [weak self] data in
            if let threads = data?[bHook_PThreads] as? [PThread] {
                for t in threads {
                    if t.entityID() == self?.thread?.entityID() {
                        _ = self?.model?.messagesModel.removeAllMessages(animated: false).subscribe()
                    }
                }
            }
        }), withName: bHookAllMessagesDeleted))
    }

    open func activate() {
        BChatSDK.ui().setChatViewController({ [weak self] (thread: PThread?) -> UIViewController? in
            if let thread = thread {
                return self?.chatViewController(thread)
            }
            return nil
        })
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
        
        // Create the chat view controller
        let vc = ChatKit.provider().chatViewController(model)
        weakVC = vc
        
        addObservers()

        vc.delegate = self
        vc.typingDelegate = self
        
        registerMessageCells()
        addRightBarButtonItem()

        addSendBarActions()
        addToolbarActions()
        addKeyboardOverlays()
        addNavigationBarAction()
        
        
        markRead(thread: thread)
        
        for listener in onCreateListeners {
            listener.onCreate(for: vc, model: model, thread: thread)
        }

        return vc
    }
    
    open func updateViewForPermissions(_ user: PUser, thread: PThread) {
        if thread.typeIs(bThreadFilterGroup) {
            updateRightBarButtonItem()
            let hasVoice = BChatSDK.thread().hasVoice(thread.entityID(), forUser: user.entityID())
            weakVC?.setReadOnly(!hasVoice)
        }
    }
    
    open func addRightBarButtonItem() {
        weakVC?.addRightBarButtonItem(item: UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil), action: { [weak self] item in
            if let thread = self?.thread {
                let flvc = BChatSDK.ui().friendsViewControllerWithUsers(toExclude: Array(thread.users()), onComplete: { users, name in
                    BChatSDK.thread().addUsers(users, to: thread)
                })
                flvc?.setRightBarButtonActionTitle(Bundle.t(bAdd))
                flvc?.hideGroupNameView = true
                flvc?.maximumSelectedUsers = 0
                
                self?.weakVC?.present(UINavigationController(rootViewController: flvc!), animated: true, completion: nil)
            }
        })
    }
    
    open func registerMessageCells() {
        var registrations = [
            MessageCellRegistration(messageType: String(bMessageTypeText.rawValue), contentClass: TextMessageContent.self),
            MessageCellRegistration(messageType: String(bMessageTypeImage.rawValue), contentClass: ImageMessageContent.self),
            MessageCellRegistration(messageType: String(bMessageTypeLocation.rawValue), contentClass: ImageMessageContent.self),
            MessageCellRegistration(messageType: String(bMessageTypeSystem.rawValue), nibName: "SystemMessageCell", contentClass: SystemMessageContent.self)
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

        model?.messagesModel.registerMessageCells(registrations: registrations)
    }
    
    open func addNavigationBarAction() {
        weakVC?.headerView.onTap = { [weak self] in
            if let vc = self?.weakVC, let thread = self?.thread {
                vc.present(BChatSDK.ui().usersViewNavigationController(with: thread, parentNavigationController: vc.navigationController), animated: true, completion: nil)
            }
        }
    }
    
    open func addKeyboardOverlays() {
        let optionsOverlay = OptionsKeyboardOverlay()

        var options = getOptions()
        if let vc = weakVC, let thread = thread {
            for provider in optionProviders {
                options.append(provider.provide(for: vc, thread: thread))
            }
        }
        optionsOverlay.setOptions(options: options)
        model?.addKeyboardOverlay(name: OptionsKeyboardOverlay.key, overlay: optionsOverlay)

        if BChatSDK.audioMessage() != nil {
            let recordOverlay = RecordKeyboardOverlay.new(self)
            model?.addKeyboardOverlay(name: RecordKeyboardOverlay.key, overlay: recordOverlay)
        }
    }
    
    open func markRead(thread: PThread) {
        if  weakVC != nil {
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
        let connected = BChatSDK.connectivity()?.isConnected() ?? true

        weakVC?.updateConnectionStatus(status)

        weakVC?.navigationItem.rightBarButtonItem?.isEnabled = connected
        if connected && status == .connected {
            weakVC?.goOnline()
        } else {
            weakVC?.goOffline()
        }
    }
    
    open func updateRightBarButtonItem() {
        if let thread = thread {
            weakVC?.navigationItem.rightBarButtonItem?.isEnabled = BChatSDK.thread().canAddUsers(thread.entityID())
        } else {
            weakVC?.navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    
    // ChatViewControllerDelegate
    
    open func viewDidLoad() {
        updateRightBarButtonItem()
        updateConnectionStatus()
    }
    
    open func viewWillAppear() {
        BChatSDK.ui().setLocalNotificationHandler({ [weak self] thread in
            if let thread = thread {
                var enable = BLocalNotificationHandler().showLocalNotification(thread)
                if enable, let current = self?.thread, thread.entityID() != current.entityID() {
                    return true
                }
            }
            return false
        })
        if let thread = thread {
            updateViewForPermissions(BChatSDK.currentUser(), thread: thread)
        }
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
        if let thread = thread {
            if thread.typeIs(bThreadFilterPublic) && (!BChatSDK.config().publicChatAutoSubscriptionEnabled || thread.meta()[bMute] != nil) {
                BChatSDK.thread().removeUsers([BChatSDK.currentUserID()], fromThread: thread.entityID())
            }
        }
    }
    
    open func viewDidDestroy() {
        ChatKit.downloadManager().removeAllListeners()
        observers.dispose()
        print("Destroy")
    }
    
    // ChatModel Delegate
    
    open func loadMessages(with oldestMessage: AbstractMessage?) -> Single<[AbstractMessage]> {
        return Single<[AbstractMessage]>.create { [weak self] single in
            if let model = self?.model?.messagesModel, let thread = BChatSDK.db().fetchEntity(withID: model.conversation.conversationId(), withType: bThreadEntity) as? PThread {
                _ = BChatSDK.thread().loadMoreMessages(from: oldestMessage?.messageDate(), for: thread).thenOnMain({ success in
                    if let messages = success as? [PMessage] {
                        single(.success(ChatKitIntegration.convert(messages)))
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
                    weakVC?.present(playerController, animated: true, completion: nil)
                } catch {
                    
                }
            }
            
            return true
        }
        if message.messageType() == String(bMessageTypeImage.rawValue) {
            // get the image URL
            
            if let ivc = BChatSDK.ui().imageViewController(), let message = message as? ImageMessage, let url = message.imageURL() {
                ivc.setImageURL(url)
                weakVC?.present(UINavigationController(rootViewController: ivc), animated: true, completion: nil)
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
                    weakVC?.present(UINavigationController(rootViewController: nvc), animated: true, completion: nil)
                }
            }
            return true
        }
        return false
    }
    
    // Typing delegate
    
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
    
    open func getOptions() -> [Option] {
        return [
            Option(galleryOnClick: { [weak self] in
                if let vc = self?.weakVC, let thread = self?.thread {
                    let action = BSelectMediaAction(type: bPictureTypeAlbumImage, viewController: vc)
                    _ = action?.execute()?.thenOnMain({ success in
                        if let imageMessage = BChatSDK.imageMessage(), let photo = action?.photo {
                            imageMessage.sendMessage(with: photo, withThreadEntityID: thread.entityID())
                        }
                        return success
                    }, nil)
                }
            }),
            Option(locationOnClick: { [weak self] in
                if let vc = self?.weakVC, let thread = self?.thread {
                    self?.locationAction = BSelectLocationAction()
                    _ = self?.locationAction?.execute()?.thenOnMain({ location in
                        if let locationMessage = BChatSDK.locationMessage(), let location = location as? CLLocation {
                            locationMessage.sendMessage(with: location, withThreadEntityID: thread.entityID())
                        }
                        return location
                    }, nil)
                }
            }),
            Option(videoOnClick: { [weak self] in
                if let vc = self?.weakVC, let thread = self?.thread {
                    let action = BSelectMediaAction(type: bPictureTypeAlbumVideo, viewController: vc)
                    _ = action?.execute()?.thenOnMain({ success in
                        if let videoMessage = BChatSDK.videoMessage(), let data = action?.videoData, let coverImage = action?.coverImage {
                            // Set the local url of the message
                            videoMessage.sendMessage(withVideo: data, cover: coverImage, withThreadEntityID: thread.entityID())
                        }
                        return success
                    }, nil)
                }
            }),
        ]
    }
    
    open func addSendBarActions() {
            model?.addSendBarAction(SendBarActions.send { [weak self] in
                if let thread = self?.thread {
                    if let text = self?.weakVC?.sendBarView.trimmedText(), !text.isEmpty {
                        if let message = self?.weakVC?.replyToMessage(), let m = BChatSDK.db().fetchEntity(withID: message.messageId(), withType: bMessageEntity) as? PMessage {
                            BChatSDK.thread().reply(to: m, withThreadID: thread.entityID(), reply: text)
                            self?.weakVC?.hideReplyView()
                        } else {
                            BChatSDK.thread().sendMessage(withText: text, withThreadEntityID: thread.entityID())
                        }
                        self?.weakVC?.sendBarView.clear()
                    }
                }
            })

            if BChatSDK.audioMessage() != nil {
                model?.addSendBarAction(SendBarActions.mic { [weak self] in
                    self?.weakVC?.showKeyboardOverlay(name: RecordKeyboardOverlay.key)
                })
            }

            model?.addSendBarAction(SendBarActions.plus { [weak self] in
                self?.weakVC?.showKeyboardOverlay(name: OptionsKeyboardOverlay.key)
            })
            
            model?.addSendBarAction(SendBarActions.camera { [weak self] in
                if let vc = self?.weakVC, let thread = self?.thread {
                    let type = BChatSDK.videoMessage() == nil ? bPictureTypeCameraImage : bPictureTypeCameraVideo

                    let action = BSelectMediaAction(type: type, viewController: vc)
                    _ = action?.execute()?.thenOnMain({ success in
                        if let imageMessage = BChatSDK.imageMessage(), let photo = action?.photo {
                            imageMessage.sendMessage(with: photo, withThreadEntityID: thread.entityID())
                        }
                        if let videoMessage = BChatSDK.videoMessage(), let video = action?.videoData, let coverImage = action?.coverImage {
                            videoMessage.sendMessage(withVideo: video, cover: coverImage, withThreadEntityID: thread.entityID())
                        }
                        return success
                    }, nil)
                }
            })
        }
    
    open func addToolbarActions() {

        model?.addToolbarAction(ToolbarAction.copyAction(onClick: { [weak self] messages in
            let formatter = DateFormatter()
            formatter.dateFormat = ChatKit.config().messageHistoryTimeFormat
            
            var text = ""
            for message in messages {
                text += String(format: "%@ - %@ %@\n", formatter.string(from: message.messageDate()), message.messageSender().userName(), message.messageText() ?? "")
            }
            
            UIPasteboard.general.string = text
            self?.weakVC?.view.makeToast(Strings.t(Strings.copiedToClipboard))

            return true
        }))

        model?.addToolbarAction(ToolbarAction.trashAction(visibleFor: { messages in
            var visible = true
            for message in messages {
                if let m = CKMessageStore.shared().message(with: message.messageId()) {
                    visible = visible && BChatSDK.thread().canDelete(m.message)
                }
            }
            return visible
        }, onClick: { [weak self] messages in
            for message in messages {
                _ = BChatSDK.thread().deleteMessage(message.messageId()).thenOnMain({ success in
                    _ = self?.model?.messagesModel.removeMessages([message]).subscribe()
                    return success
                }, nil)
            }
            return false
        }))

        model?.addToolbarAction(ToolbarAction.forwardAction(visibleFor: { messages in
            return messages.count == 1
        }, onClick: { [weak self] messages in
            if let message = messages.first as? CKMessage {
                let forwardViewController = ForwardViewController()
                forwardViewController.message = message.message
                self?.weakVC?.present(UINavigationController(rootViewController: forwardViewController), animated: true, completion: nil)
            }
            return true
        }))

        model?.addToolbarAction(ToolbarAction.replyAction(visibleFor: { messages in
            return messages.count == 1
        }, onClick: { [weak self] messages in
            if let message = messages.first {
                self?.weakVC?.showReplyView(message)
            }
            return true
        }))
        
    }
    
    // Record view delegate
    public func send(audio: Data, duration: Int) {
        // Save this file to the standard directory
        if let thread = thread {
            BChatSDK.audioMessage()?.sendMessage(withAudio: audio, duration: Double(duration), withThreadEntityID: thread.entityID())
        }
    }


}
