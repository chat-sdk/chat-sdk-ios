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

public protocol PChatViewController {
    func add(message: Message)
}

open class ChatViewController: UIViewController {
    
    // View that contains the message list
    public var messagesView = MessagesView()
    public var keyboardOverlayView = UIView()
    public var headerView = ChatHeaderView()
    public var reconnectingView = ReconnectingView()
        
    public var hiddenTextField = UITextField()
    
    public var replyView = ReplyView()
    public var toolbarView = ChatToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 35))
    public var subtitleTimer: Timer?
    
    public var messagesModel: MessagesModel?
    
    public var keyboardListener = KeyboardListener()
        
    // Text input bar
    public lazy var sendBarView = {
        return SendBarView()
    }()
    // This view bridges between the bottom of the text input view and the bottom of the safe area
    public var sendBarViewFooter: UIView?
    public var sendBarViewBottomConstraint: NSLayoutConstraint?
    public var sendBarViewFooterBottomConstraint: NSLayoutConstraint?

    // Gesture recognizers
    var tapRecognizer: UITapGestureRecognizer?
    
    // Data model
    public let model: ChatModel
    
    public init(model: ChatModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
        model.view = self

        // Hide the tab bar when the messages are shown
        hidesBottomBarWhenPushed = true
        navigationItem.largeTitleDisplayMode = .never
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()

        setup()
        setupHiddenTextView()
        setupMessageModel()
        setupMessagesView()
        setupSendBarView()

        updateNavigationBar()

        setupReplyView()
        setupToolbarView()
        setupKeyboardOverlay()
        
        setupKeyboardListener()
        setupKeyboardOverlays()

    }
    
    override public func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        for overlay in model.getKeyboardOverlays() {
            if let _ = overlay.superview {
                overlay.viewWillLayoutSubviews(view: self.view)
            }
        }
        messagesView.willSetBottomInset()
    }
    
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateMessageViewBottomInset()
    }
    
    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        sendBarView.updateColors()
        replyView.updateColors()
    }
    
    public func updateMessageViewBottomInset(keyboardHeight: CGFloat? = nil) {
        var keyboardHeight = keyboardHeight ?? -(sendBarViewBottomConstraint?.constant ?? 0)
        if (replyView.isVisible() || replyView.willShow) && !replyView.willHide {
            keyboardHeight += replyView.frame.size.height
        }
        messagesView.setBottomInset(height: keyboardHeight + sendBarView.frame.size.height)
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setSubtitle(text: model.initialSubtitle())
        
        if let text = model.initialSubtitle() {
            setSubtitle(text: text)
            subtitleTimer = Timer(timeInterval: ChatKit.config().initialSubtitleInterval, repeats: false, block: { [weak self] timer in
                timer.invalidate()
                self?.setSubtitle()
            })
        }
        
        addObservers()
    }
    
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObservers()
        hideKeyboardOverlay()
    }
    
    // Observers
    
    public func addObservers() {
        keyboardListener.addObservers()
    }

    public func removeObservers() {
        keyboardListener.removeObservers()
    }
    
    open func setTitle(text: String) {
        headerView.titleLabel?.text = text
    }
    
    public func setSubtitle(text: String? = nil) {
        if let text = text {
            headerView.subtitleLabel?.text = text
        } else {
            headerView.subtitleLabel?.text = model.subtitle()
        }
    }
    
    // Setup methods
    
    public func setup() {
        view.backgroundColor = ChatKit.asset(color: "background")
        title = model.title()
    }

    public func setupHiddenTextView() {
        view.addSubview(hiddenTextField)
        hiddenTextField.keepTopInset.equal = -1000
        hiddenTextField.alpha = 0
    }

    public func setupMessageModel() {
        messagesModel = model.getMessagesModel()
        messagesModel!._onSelectionChange = { [weak self] selection in
            if selection.isEmpty {
                self?.hideToolbar()
            } else {
                self?.showToolbar()
                self?.toolbarView.setSelectedMessageCount(count: selection.count)
            }
        }
    }
    
    public func setupMessagesView() {
        messagesView.setModel(model: messagesModel!)
        messagesView._hideKeyboardListener = { [weak self] in
            self?.sendBarView.hide()
            self?.hiddenTextField.resignFirstResponder()
        }
        view.addSubview(messagesView)
        messagesView.keepInsets.equal = 0
    }
    
    public func setupSendBarView() {
        view.addSubview(sendBarView)
        
        sendBarView.keepLeftInset.equal = 0
        sendBarView.keepRightInset.equal = 0
        
        sendBarView.didBecomeFirstResponder = { [weak self] in
            self?.hideKeyboardOverlay()
        }
        
        for action in model.getSendBarActions() {
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
        replyView.keepHeight.equal = 51
        replyView.hide(duration: 0, notify: false)
        replyView.didHideListener = { [weak self] in
            UIView.animate(withDuration: ChatKit.config().animationDuration, animations: { [weak self] in
                self?.updateMessageViewBottomInset()
            })
        }
    }
    
    open func setupToolbarView() {
        view.addSubview(toolbarView)
        
        toolbarView.keepTopAlignTo(sendBarView)?.equal = 0;
        toolbarView.keepRightAlignTo(sendBarView)?.equal = 0;
        toolbarView.keepBottomAlignTo(sendBarView)?.equal = 0;
        toolbarView.keepLeftAlignTo(sendBarView)?.equal = 0;
        toolbarView.alpha = 0;
        
        toolbarView.copyListener = { [weak self] in
            if let mvm = self?.messagesModel {
                mvm.copyToClipboard()
                self?.view.makeToast(Strings.t(Strings.copiedToClipboard))
            }
            self?.messagesView.clearSelection()
        }
        
        toolbarView.replyListener = { [weak self] in
            // Get the message
            if let message = self?.messagesModel?.selectedMessages().first {
                self?.replyView.show(message: message, duration: ChatKit.config().animationDuration)
                // Move the insets up
                
                UIView.animate(withDuration: ChatKit.config().animationDuration, animations: { [weak self] in
                    self?.updateMessageViewBottomInset()
                })
                
                self?.toolbarView.hide()
            }
            self?.messagesView.clearSelection()
        }
        
        toolbarView.forwardListener = { [weak self] in
            
        }
        
        toolbarView.deleteListener = { [weak self] in
            if let messages = self?.messagesModel?.selectedMessages() {
                self?.model.deleteMessages(messages: messages)
            }
            self?.messagesView.clearSelection()
        }
        
    }

    public func setupKeyboardOverlays() {
        for name in model.keyboardOverlays.keys {
            if let overlay = model.keyboardOverlay(for: name) {
                addKeyboardOverlay(view: overlay)
            }
        }
    }
    
    open func setupKeyboardOverlay() {
        keyboardOverlayView.backgroundColor = ChatKit.asset(color: "background")
        keyboardOverlayView.alpha = 0
        keyboardOverlayView.isUserInteractionEnabled = false
        resetKeyboardOverlayFrame()
    }
    
    public func setupKeyboardListener() {
        keyboardListener.willShow = { [weak self] info in
            
//            self?.resetKeyboardOverlayFrame()
            self?.keyboardOverlayView.frame = info.frame
//            if let overlay = self?.keyboardOverlayView {
//                overlay.superview?.bringSubviewToFront(overlay)
//            }

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
    
    public func showKeyboardOverlay() {
        hiddenTextField.becomeFirstResponder()
//        if keyboardOverlayView.superview == nil {
            UIApplication.shared.windows.last?.addSubview(keyboardOverlayView)
//        }
        keyboardOverlayView.alpha = 1
        keyboardOverlayView.isUserInteractionEnabled = true
    }

    public func hideKeyboardOverlay() {
        hiddenTextField.resignFirstResponder()
        keyboardOverlayView.removeFromSuperview()
        keyboardOverlayView.alpha = 0
        keyboardOverlayView.isUserInteractionEnabled = false
    }
    
    public func addKeyboardOverlay(view: KeyboardOverlay) {
        keyboardOverlayView.addSubview(view)
        view.keepTopInset.equal = 0
        view.keepLeftInset.equal = 0
        view.keepRightInset.equal = 0
    }

    public func showKeyboardOverlay(name: String) {
        showKeyboardOverlay()
        if let overlay = model.keyboardOverlay(for: name) {
            overlay.alpha = 1
            overlay.isUserInteractionEnabled = true
        }
    }

    public func hideKeyboardOverlay(name: String) {
        hiddenTextField.resignFirstResponder()
        hideKeyboardOverlay()
        if let overlay = model.keyboardOverlay(for: name) {
            overlay.alpha = 0
            overlay.isUserInteractionEnabled = false
        }
    }
    
    // Toolbar
    
    public func hideToolbar() {
        toolbarView.hide()
    }

    public func showToolbar() {
        toolbarView.show()
    }
    
    public func vibrate() {
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
    
    public func isReply() -> Bool {
        return replyView.message() != nil
    }

    public func replyToMessage() -> Message? {
        return replyView.message()
    }

}

extension UIView {
    public func safeAreaHeight() -> CGFloat {
        if #available(iOS 11, *) {
            return safeAreaInsets.bottom
        }
        return 0
    }
}

extension ChatViewController: PChatViewController {

    public func add(message: Message) {
        
    }
    
}

