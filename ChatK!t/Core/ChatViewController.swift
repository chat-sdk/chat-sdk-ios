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

open class ChatViewController: UIViewController {
    
    // View that contains the message list
    open var messagesView = ChatKit.provider().messagesView()
    open var keyboardOverlayView = UIView()
    open var headerView = ChatKit.provider().chatHeaderView()
    open var reconnectingView = ChatKit.provider().reconnectingView()
        
    open var hiddenTextField = UITextField()
    
    open var replyView = ChatKit.provider().replyView()
    open var toolbar: ChatToolbar
    open var subtitleTimer: Timer?
    
    open var messagesModel: MessagesModel?
    
    open var keyboardListener = KeyboardListener()
    
    open var afterLayoutQueue = [AfterLayoutAction]()
    
    open var initialLoad = true
        
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
    
    var rightBarButtonItem: UIBarButtonItem?
    var rightBarButtonAction: ((UIBarButtonItem) -> Void)?
    
    // Data model
    public let model: ChatModel
    open weak var typingDelegate: ChatViewControllerTypingDelegate?
    open weak var delegate: ChatViewControllerDelegate?

    public init(model: ChatModel) {
        self.model = model
        toolbar = ChatKit.provider().chatToolbar(model.messagesModel, actions: model)
        toolbar.setActionsDelegate(model)
        super.init(nibName: nil, bundle: nil)
//        model.view = self

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
        setupHiddenTextView()
        setupMessageModel()
        setupMessagesView()
        setupSendBarView()

        updateNavigationBar()

        setupReplyView()
        setuptoolbar()
        setupKeyboardOverlay()
        
        setupKeyboardListener()
        setupKeyboardOverlays()

        if let item = rightBarButtonItem {
            navigationItem.rightBarButtonItem = item
        }

        delegate?.viewDidLoad()
    }
    
    open func addRightBarButtonItem(item: UIBarButtonItem, action: @escaping ((UIBarButtonItem) -> Void)) {
        item.target = self
        item.action = #selector(rightBarButtonAction(sender:))
        rightBarButtonItem = item
        rightBarButtonAction = action
    }
    
    @objc open func rightBarButtonAction(sender: UIBarButtonItem) {
        rightBarButtonAction?(sender)
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        initialLoad = false
        delegate?.viewDidAppear()
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
        
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(didFinishAutoLayout), object: nil)
        self.perform(#selector(didFinishAutoLayout))
    }
    
    @objc open func didFinishAutoLayout() {
        if initialLoad {
            messagesView.scrollToBottom(animated: false, force: true)
        }
    }
    
    
    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        sendBarView.updateColors()
        replyView.updateColors()
    }
    
    open func updateMessageViewBottomInset(keyboardHeight: CGFloat? = nil) {
        var height = keyboardHeight ?? -(sendBarViewBottomConstraint?.constant ?? 0)
        if (replyView.isVisible() || replyView.willShow) && !replyView.willHide {
            height += replyView.frame.size.height
        }
        height += sendBarView.frame.size.height
        messagesView.setBottomInset(height: height)
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
    }

    open func removeObservers() {
        keyboardListener.removeObservers()
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
    
    // Setup methods
    
    open func setup() {
        view.backgroundColor = ChatKit.asset(color: "background")
        title = model.title()
    }

    open func setupHiddenTextView() {
        view.addSubview(hiddenTextField)
        hiddenTextField.keepTopInset.equal = -1000
        hiddenTextField.alpha = 0
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
            self?.hiddenTextField.resignFirstResponder()
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
    }
    
    open func setupReplyView() {
        view.addSubview(replyView)
        replyView.keepRightInset.equal = 0
        replyView.keepLeftInset.equal = 0
        replyView.keepBottomOffsetTo(sendBarView)?.equal = 0
        replyView.keepHeight.equal = ChatKit.config().chatReplyViewHeight + replyView.divider.frame.height
        replyView.hide(duration: 0, notify: false)
        replyView.didHideListener = { [weak self] in
            UIView.animate(withDuration: ChatKit.config().animationDuration, animations: { [weak self] in
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
        keyboardOverlayView.alpha = 0
        keyboardOverlayView.isUserInteractionEnabled = false
        resetKeyboardOverlayFrame()
    }
    
    open func setupKeyboardListener() {
        keyboardListener.willShow = { [weak self] info in
            
            self?.keyboardOverlayView.frame = info.frame

            UIView.animate(withDuration: info.duration, delay: 0, options: info.curve, animations: {
                let height = info.height(view: self?.view)
                                
                self?.sendBarViewBottomConstraint?.constant = -height
                self?.sendBarViewFooterBottomConstraint?.constant = -height
                self?.view.layoutIfNeeded()
                
            })
        }
        
        keyboardListener.willChangeFrame = { [weak self] info in
            self?.keyboardOverlayView.frame = info.frame
        }
        
        keyboardListener.willHide = { [weak self] info in
            
            self?.keyboardOverlayView.frame = info.frame
            
            UIView.animate(withDuration: info.duration, delay: 0, options: info.curve, animations: {
                self?.sendBarViewBottomConstraint?.constant = 0
                self?.sendBarViewFooterBottomConstraint?.constant = 20
                self?.view.layoutIfNeeded()
            })
        }
        
        keyboardListener.didHide = { [weak self] info in
            self?.hideKeyboardOverlay()
        }
                
    }
    
    // Keyboard Overlay
    
    open func resetKeyboardOverlayFrame() {
        keyboardOverlayView.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: 300)
    }
    
    open func showKeyboardOverlay() {
        hiddenTextField.becomeFirstResponder()
        UIApplication.shared.windows.last?.addSubview(keyboardOverlayView)
        keyboardOverlayView.alpha = 1
        keyboardOverlayView.isUserInteractionEnabled = true
    }

    open func hideKeyboardOverlay() {
        hiddenTextField.resignFirstResponder()
        keyboardOverlayView.removeFromSuperview()
        keyboardOverlayView.alpha = 0
        keyboardOverlayView.isUserInteractionEnabled = false
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
        hiddenTextField.resignFirstResponder()
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

