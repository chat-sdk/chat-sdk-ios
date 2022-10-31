//
//  ChatViewController.swift
//  AFNetworking
//
//  Created by ben3 on 18/07/2020.
//

import Foundation
import UIKit
import KeepLayout
import AudioToolbox
import RxCocoa

//public protocol PChatViewController {
//    func add(message: Message)
//}

public protocol ChatViewControllerTypingDelegate: class {
    func didStartTyping()
    func didStopTyping()
}

public protocol ChatViewControllerDelegate: class {
    func viewDidLoad()
    func viewWillAppear()
    func viewDidAppear()
    func viewWillDisappear()
    func viewDidDisappear()
    func viewDidDestroy()
}

public class NavBarButton {
    let item: UIBarButtonItem
    let action: ((UIBarButtonItem) -> Void)
    public init(_ item: UIBarButtonItem, action: @escaping ((UIBarButtonItem) -> Void)) {
        self.item = item
        self.action = action
    }
}

open class ChatViewController: UIViewController {
    
    // View that contains the message list
    open var messagesView = ChatKit.provider().messagesView()
    open var headerView = ChatKit.provider().chatHeaderView()
    open var reconnectingView = ChatKit.provider().reconnectingView()
        
    open var hiddenTextField: KeyboardOverlayTextView?

    open var keyboardOverlayView = ChatKit.provider().keyboardOverlayView()

    open var replyView = ChatKit.provider().replyView()
    open var toolbar: ChatToolbar
    open var subtitleTimer: Timer?
    
    open var messagesModel: MessagesModel?
    
    open var keyboardListener = KeyboardListener()
    
    open var afterLayoutQueue = [AfterLayoutAction]()
    
    open var initialLoad = true
    open var isMeasuringKeyboardHeight = false
    
    open var keyboardInfoCache = KeyboardInfoCache()
    

    // Text input bar
    open lazy var sendBarView = {
        return ChatKit.provider().sendBarView()
    }()
    // This view bridges between the bottom of the text input view and the bottom of the safe area
    open var sendBarViewFooter: UIView?
    open var sendBarViewBottomConstraint: NSLayoutConstraint?
    open var sendBarViewFooterBottomConstraint: NSLayoutConstraint?

    // Gesture recognizers
    var tapRecognizer: UITapGestureRecognizer?
    
    open var rightBarButtonItems = [NavBarButton]()
    
//    open var rightBarButtonItems = [UIBarButtonItem: ((UIBarButtonItem) -> Void)]()
    
//    var rightBarButtonItem: UIBarButtonItem?
//    var rightBarButtonAction: ((UIBarButtonItem) -> Void)?
    
    // Data model
    public let model: ChatModel
    open weak var typingDelegate: ChatViewControllerTypingDelegate?
    open weak var delegate: ChatViewControllerDelegate?

    public init(model: ChatModel) {
        self.model = model
        toolbar = ChatKit.provider().chatToolbar(model.messagesModel, actions: model)
        toolbar.setActionsDelegate(model)
        super.init(nibName: nil, bundle: nil)

        // Hide the tab bar when the messages are shown
        hidesBottomBarWhenPushed = true
        navigationItem.largeTitleDisplayMode = .never
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()

        setup()
        setupMessageModel()
        setupMessagesView()
        setupSendBarView()

        updateNavigationBar()

        setupReplyView()
        setuptoolbar()
        setupKeyboardOverlay()
        
        setupKeyboardListener()
        setupKeyboardOverlays()

        var items = [UIBarButtonItem]()
        for button in rightBarButtonItems {
            button.item.target = self
            button.item.action = #selector(rightBarButtonAction(sender:))
            items.append(button.item)
        }
        navigationItem.rightBarButtonItems = items
        
        delegate?.viewDidLoad()
        
    }
    
//    open func addRightBarButtonItem(item: UIBarButtonItem, action: @escaping ((UIBarButtonItem) -> Void)) {
//        item.target = self
//        item.action = #selector(rightBarButtonAction(sender:))
//        rightBarButtonItem = item
//        rightBarButtonAction = action
//    }
    
    @objc open func rightBarButtonAction(sender: UIBarButtonItem) {
        for button in rightBarButtonItems {
            if button.item == sender {
                button.action(sender)
            }
        }
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        initialLoad = false
        delegate?.viewDidAppear()
        
        measureKeyboardHeight()
                
    }
    
    override open func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        for overlay in model.keyboardOverlays() {
            if let _ = overlay.superview {
                overlay.viewWillLayoutSubviews(view: self.view)
            }
        }
        messagesView.willSetBottomInset()
    }
    
    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateMessageViewBottomInset()
        popAllAfterLayoutActions()
        
        let frame = keyboardOverlayView.frame
        
        keyboardOverlayView.frame = CGRectMake(0, 0, view.frame.width, frame.height)

        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(didFinishAutoLayout), object: nil)
        self.perform(#selector(didFinishAutoLayout))
        
        print("Chat View - overlay dimensions: ", frame)

    }
    
    @objc open func didFinishAutoLayout() {
        if initialLoad {
            messagesView.scrollToBottom(animated: false, force: true)
        }
    }
    
    open func showResendDialog(callback: @escaping (Bool) -> Void) {
        
        let alert = UIAlertController(title: nil, message: t(Strings.resendMessage), preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: t(Strings.resend), style: .default , handler:{ [weak self] (UIAlertAction)in
            callback(true)
        }))
                       
        alert.addAction(UIAlertAction(title: t(Strings.dismiss), style: .cancel, handler:{ (UIAlertAction) in
            callback(false)
        }))
        alert.popoverPresentationController?.sourceView = self.view

        self.present(alert, animated: true, completion: nil)
        
    }
    
    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        sendBarView.updateColors()
        replyView.updateColors()
    }
    
    open func updateMessageViewBottomInset(keyboardHeight: CGFloat? = nil) {
        let height = calculateMessageViewBottomInset(keyboardHeight: keyboardHeight)
        messagesView.setBottomInset(height: height)
    }

    open func calculateMessageViewBottomInset(keyboardHeight: CGFloat? = nil) -> CGFloat {
        var height = keyboardHeight ?? -(sendBarViewBottomConstraint?.constant ?? 0)
        if (replyView.isVisible() || replyView.willShow) && !replyView.willHide {
            height += replyView.frame.size.height
        }
        height += sendBarView.frame.size.height
        return height
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        model.loadInitialMessages()

        if let text = model.initialSubtitle() {
            setSubtitle(text: text)
            subtitleTimer = Timer.scheduledTimer(withTimeInterval: ChatKit.config().initialSubtitleInterval, repeats: false, block: { [weak self] timer in
                timer.invalidate()
                self?.setSubtitle()
            })
        }
        
        addObservers()
        
        delegate?.viewWillAppear()

    }
    
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObservers()
        hideKeyboardOverlay()
        delegate?.viewWillDisappear()
        
    }
    
    override open func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        delegate?.viewDidDisappear()
    }
    
    // Observers
    
    open func addObservers() {
        keyboardListener.addObservers()
        NotificationCenter.default.addObserver(self, selector: #selector(rotated), name: UIDevice.orientationDidChangeNotification, object: nil)
    }

    open func removeObservers() {
        keyboardListener.removeObservers()
        NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    @objc func rotated() {
        UIView.setAnimationsEnabled(false)
        keyboardInfoCache.isEnabled = false
        sendBarView.hideKeyboard()
        hideKeyboardOverlay()
        keyboardInfoCache.isEnabled = true
        UIView.setAnimationsEnabled(true)
        
        // There is an annoying issue where if we switch back to portrait,
        // this registers as a very small keyboard
        measureKeyboardHeight()
        keyboardInfoCache.relayout()

//        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: { [weak self] in
//
//
//        })

//        if UIDevice.current.orientation.isLandscape {
//            print("Landscape")
//        } else {
//            print("Portrait")
//        }
    }
    
    open func setTitle(text: String) {
        headerView.titleLabel?.text = text
    }
    
    open func setSubtitle(text: String? = nil) {
        if let text = text {
            headerView.subtitleLabel?.text = text
        } else if !model.subtitle().isEmpty {
            headerView.subtitleLabel?.text = model.subtitle()
        }
    }
    
    open func setHeaderImage(url: URL?) {
        headerView.imageView?.sd_setImage(with: url, placeholderImage: ChatKit.asset(icon: "icn_100_avatar"), options: .highPriority, context: nil)
    }
    
    // Setup methods
    
    open func setup() {
        view.backgroundColor = ChatKit.asset(color: "background")
        title = model.title()
    }


    open func setupMessageModel() {
        messagesModel = model.messagesModel
        messagesModel!.setSelectionChangeListener({ [weak self] selection in
            if selection.isEmpty {
                self?.hideToolbar()
            } else {
                self?.showToolbar()
            }
        })
    }
    
    open func setupMessagesView() {
        messagesView.setModel(model: messagesModel!)
        messagesView.hideKeyboardListener = { [weak self] in
            self?.sendBarView.hideKeyboard()
            self?.hiddenTextField?.resignFirstResponder()
        }
        view.addSubview(messagesView)
        messagesView.keepInsets.equal = 0
    }
    
    open func setupSendBarView() {
        view.addSubview(sendBarView)
        
        sendBarView.keepLeftInset.equal = 0
        sendBarView.keepRightInset.equal = 0
        
        sendBarView.didStartTyping = { [weak self] in
            self?.typingDelegate?.didStartTyping()
        }
        sendBarView.didStopTyping = { [weak self] in
            self?.typingDelegate?.didStopTyping()
        }

        sendBarView.didBecomeFirstResponder = { [weak self] in
            self?.hideKeyboardOverlay()
        }
        
        for action in model.sendBarActions {
            sendBarView.addAction(action)
        }
        
        sendBarViewFooter = ChatKit.provider().makeBackground()
        view.insertSubview(sendBarViewFooter!, belowSubview: sendBarView)
        
        sendBarViewFooter?.keepLeftInset.equal = 0
        sendBarViewFooter?.keepRightInset.equal = 0

        sendBarViewBottomConstraint = sendBarView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        sendBarViewFooterBottomConstraint = sendBarViewFooter!.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 20)

        NSLayoutConstraint.activate([
            sendBarViewFooter!.topAnchor.constraint(equalTo: sendBarView.topAnchor, constant: 0),
            sendBarViewBottomConstraint!,
            sendBarViewFooterBottomConstraint!
        ])
    }
    
    open func updateNavigationBar(reconnecting: Bool = false) {
        if reconnecting {
            navigationItem.titleView = reconnectingView
        } else {
            navigationItem.titleView = headerView
        }
        setTitle(text: model.title())
        setSubtitle(text: model.subtitle())
        setHeaderImage(url: model.imageURL())
        
    }
    
    open func setupReplyView() {
        view.addSubview(replyView)
        replyView.keepRightInset.equal = 0
        replyView.keepLeftInset.equal = 0
        replyView.keepBottomOffsetTo(sendBarView)?.equal = 0
        replyView.keepHeight.equal = ChatKit.config().chatReplyViewHeight + replyView.divider.frame.height
        replyView.hide(duration: 0, notify: false)
        replyView.didHideListener = { [weak self] in
            UIView.animate(withDuration: ChatKit.config().animationDuration, animations: {
                self?.updateMessageViewBottomInset()
            })
        }
    }
    
//    open func clearSelection() {
//        model.messagesModel().clearSelection()
//    }
    
    open func setuptoolbar() {
        view.addSubview(toolbar)
        
        toolbar.keepTopAlignTo(sendBarView)?.equal = 0;
        toolbar.keepRightAlignTo(sendBarView)?.equal = 0;
        toolbar.keepBottomAlignTo(sendBarView)?.equal = 0;
        toolbar.keepLeftAlignTo(sendBarView)?.equal = 0;
        toolbar.alpha = 0;
        
    }
    
    open func goOffline() {
        sendBarView.goOffline()
        updateNavigationBar(reconnecting: true)
    }

    open func goOnline() {
        sendBarView.goOnline()
        updateNavigationBar()
    }
    
    open func updateConnectionStatus(_ status: ConnectionStatus? = .none) {
        if status == .none {
            updateNavigationBar(reconnecting: false)
        }
        reconnectingView.update(status)
    }

    open func showReplyView(_ message: AbstractMessage) {
        replyView.show(message: message, duration: ChatKit.config().animationDuration)
        UIView.animate(withDuration: ChatKit.config().animationDuration, animations: { [weak self] in
            self?.updateMessageViewBottomInset()
        })
        toolbar.hide()
   }
    
    open func hideReplyView() {
        replyView.hide()
    }

    open func setupKeyboardOverlays() {
        for overlay in model.keyboardOverlays() {
            addKeyboardOverlay(view: overlay)
        }
    }
    
    open func setupKeyboardOverlay() {
        keyboardOverlayView.backgroundColor = ChatKit.asset(color: "background")
//        keyboardOverlayView.keepWidth.equal = view.wid
        
        keyboardInfoCache.keyboardHeightUpdatedListener = { [weak self] info, height in
//            self?.keyboardOverlayView.setHeight(value: height)
            self?.keyboardOverlayView.setSize(frame: info?.endFrame, height: height)
        }
        
        hiddenTextField = ChatKit.shared().provider.keyboardOverlayTextView(overlay: keyboardOverlayView)
        
        view.addSubview(hiddenTextField!)
        hiddenTextField!.keepTopInset.equal = -1000
        hiddenTextField!.alpha = 0
    }
    
    open func setupKeyboardListener() {
        
        keyboardListener.willShow = { [weak self] info in
            
//            self?.keyboardOverlayView.frame = info.frame
            
            if !(self?.isMeasuringKeyboardHeight ?? false) {
                UIView.animate(withDuration: info.duration, delay: 0, options: info.curve, animations: { [weak self] in
                    var height = info.height(view: self?.view)
                                    
                    self?.sendBarViewBottomConstraint?.constant = -height
                    self?.sendBarViewFooterBottomConstraint?.constant = -height
                    self?.view.layoutIfNeeded()
                    
                })
            } else {
                // We are measuring the keyboard height
//                let bottomInset = UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0
//                let height = info.height()
//                let total = bottomInset + height
//                let other = info.height(view: self?.view)
//
//                print("")
            }
        
        }
        
        keyboardListener.didShow = { [weak self] info in
            if let htf = self?.hiddenTextField, !htf.isFirstResponder {
//                self?.keyboardInfo.setInfo(info: info)
            }
        }
        
        keyboardListener.willChangeFrame = { [weak self] info in

            if let htf = self?.hiddenTextField, !htf.isFirstResponder, let cache = self?.keyboardInfoCache {
                
                // Only do this if it is appearing
                
                cache.setInfo(info: info, isTest: self?.isMeasuringKeyboardHeight ?? false)
                
                let height = cache.keyboardHeight()
                
                print("Height: ", height, UIView.isPortrait())
                
                if let frame = self?.keyboardOverlayView.frame, let view = self?.view {
                    
//                    let newFrame = CGRect(x: 0, y: 0, width: view.frame.width, height: frame.height)
                    
//                    print("SetFrame: ", newFrame)

//                    self?.keyboardOverlayView.frame = newFrame
                }
                
            }
        }
        
        keyboardListener.willHide = { [weak self] info in
                        
            if !(self?.isMeasuringKeyboardHeight ?? false) {
                UIView.animate(withDuration: info.duration, delay: 0, options: info.curve, animations: {
                    self?.sendBarViewBottomConstraint?.constant = 0
                    self?.sendBarViewFooterBottomConstraint?.constant = 20
                    self?.view.layoutIfNeeded()
                })
            }
        }
        
        keyboardListener.didHide = { [weak self] info in
//            self?.hideKeyboardOverlay()
        }
                
    }
    
    open func measureKeyboardHeight() {
        
//        let height = KeyboardSize.height()
//        print("height")
        
        // See if we need to do this
//        if ChatKit.shared().keyboardInfoCache.measurementRequired() {
            isMeasuringKeyboardHeight = true

            UIView.setAnimationsEnabled(false)

            sendBarView.showKeyboard()
            sendBarView.hideKeyboard()
            
            UIView.setAnimationsEnabled(true)
            isMeasuringKeyboardHeight = false
        }
//    }
    
    // Keyboard Overlay
    
//    open func resetKeyboardOverlayFrame() {
//        keyboardOverlayView.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: 300)
//    }
    
    open func showKeyboardOverlay() {
        
//        UIView.setAnimationsEnabled(sendBarView.isFirstResponder)
//        sendBarView.resignFirstResponder()
        
        DispatchQueue.main.async { [weak self] in
            self?.hiddenTextField?.becomeFirstResponder()
            // HERE
            self?.keyboardInfoCache.relayout()
        }
        
//        UIView.setAnimationsEnabled(true)

        
        // Is the keyboard showing
        
//        keyboardOverlayView.alpha = 1
//        keyboardOverlayView.isUserInteractionEnabled = true
    }

    open func hideKeyboardOverlay() {
        
        hiddenTextField?.resignFirstResponder()
//        keyboardOverlayView.removeFromSuperview()
//        keyboardOverlayView.alpha = 0
//        keyboardOverlayView.isUserInteractionEnabled = false
    }
    
    open func addKeyboardOverlay(view: KeyboardOverlay) {
        keyboardOverlayView.addSubview(view)
        view.alpha = 0
        view.keepTopInset.equal = 0
        view.keepLeftInset.equal = 0
        view.keepRightInset.equal = 0
    }

    open func showKeyboardOverlay(name: String) {
        showKeyboardOverlay()
        for overlay in model.keyboardOverlays() {
            overlay.alpha = 0
            overlay.isUserInteractionEnabled = false
        }
        if let overlay = model.keyboardOverlay(for: name) {
            overlay.alpha = 1
            overlay.isUserInteractionEnabled = true
        }
    }

    open func hideKeyboardOverlay(name: String) {
        hiddenTextField?.resignFirstResponder()
        hideKeyboardOverlay()
        if let overlay = model.keyboardOverlay(for: name) {
            overlay.alpha = 0
            overlay.isUserInteractionEnabled = false
        }
    }
    
    // Toolbar
    
    open func hideToolbar() {
        toolbar.hide()
    }

    open func showToolbar() {
        toolbar.show()
    }
    
    open func vibrate() {
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
    
    open func isReply() -> Bool {
        return replyView.message() != nil
    }

    open func replyToMessage() -> Message? {
        return replyView.message()
    }
    
    open func addAfterLayout(_ action: AfterLayoutAction) {
        afterLayoutQueue.append(action)
    }

    open func popAfterLayoutAction() {
        if !afterLayoutQueue.isEmpty {
            afterLayoutQueue.first?.action()
            afterLayoutQueue.remove(at: 0)
        }
    }
    
    open func popAllAfterLayoutActions() {
        for action in afterLayoutQueue {
            action.action()
        }
        afterLayoutQueue.removeAll()
    }
    
    open func setReadOnly(_ readonly: Bool) {
        if readonly {
            sendBarView.isHidden = true
            sendBarView.keepHeight.equal = 0
        } else {
            sendBarView.isHidden = false
            sendBarView.keepHeight.deactivate()
        }
    }

    deinit {
        delegate?.viewDidDestroy()
    }

}

extension UIView {
    open func safeAreaHeight() -> CGFloat {
        if #available(iOS 11, *) {
            return safeAreaInsets.bottom
        }
        return 0
    }
}

//extension ChatViewController: PChatViewController {
//
//    open func add(message: Message) {
//
//    }
//
//}

open class AfterLayoutAction {
    open var action: () -> Void
    public init(action: @escaping () -> Void) {
        self.action = action
    }
}

