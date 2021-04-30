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

public class ChatViewController: UIViewController {
    
    
    // View that contains the message list
    public var messagesView = ChatKit.provider().messagesView()
    public var keyboardOverlayView = UIView()
    public var headerView = ChatKit.provider().chatHeaderView()
    public var reconnectingView = ChatKit.provider().reconnectingView()
        
    public var hiddenTextField = UITextField()
    
    public var replyView = ChatKit.provider().replyView()
    public var toolbar: ChatToolbar
    public var subtitleTimer: Timer?
    
    public var messagesModel: MessagesModel?
    
    public var keyboardListener = KeyboardListener()
        
    // Text input bar
    public lazy var sendBarView = {
        return ChatKit.provider().sendBarView()
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
        toolbar = ChatKit.provider().chatToolbar(model.messagesModel(), actions: model)
        toolbar.setActionsDelegate(model)
        super.init(nibName: nil, bundle: nil)
        model.setView(self)

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
        setuptoolbar()
        setupKeyboardOverlay()
        
        setupKeyboardListener()
        setupKeyboardOverlays()
        
        model.loadMessages()

    }
    
    override public func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        for overlay in model.keyboardOverlays() {
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
    
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
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
    
    public func setTitle(text: String) {
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
        messagesModel = model.messagesModel()
        messagesModel!._onSelectionChange = { [weak self] selection in
            if selection.isEmpty {
                self?.hideToolbar()
            } else {
                self?.showToolbar()
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
        
        for action in model.sendBarActions() {
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
    
    public func updateNavigationBar(reconnecting: Bool = false) {
        if reconnecting {
            navigationItem.titleView = reconnectingView
        } else {
            navigationItem.titleView = headerView
        }
        setTitle(text: model.title())
        setSubtitle(text: model.subtitle())
    }
    
    
    public func setupReplyView() {
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
    
    public func clearSelection() {
        messagesView.clearSelection()
    }
    
    public func setuptoolbar() {
        view.addSubview(toolbar)
        
        toolbar.keepTopAlignTo(sendBarView)?.equal = 0;
        toolbar.keepRightAlignTo(sendBarView)?.equal = 0;
        toolbar.keepBottomAlignTo(sendBarView)?.equal = 0;
        toolbar.keepLeftAlignTo(sendBarView)?.equal = 0;
        toolbar.alpha = 0;
        
    }
    
    public func showReplyView(_ message: Message) {
        replyView.show(message: message, duration: ChatKit.config().animationDuration)
        UIView.animate(withDuration: ChatKit.config().animationDuration, animations: { [weak self] in
            self?.updateMessageViewBottomInset()
        })
        toolbar.hide()
   }

    public func setupKeyboardOverlays() {
        for overlay in model.keyboardOverlays() {
            addKeyboardOverlay(view: overlay)
        }
    }
    
    public func setupKeyboardOverlay() {
        keyboardOverlayView.backgroundColor = ChatKit.asset(color: "background")
        keyboardOverlayView.alpha = 0
        keyboardOverlayView.isUserInteractionEnabled = false
        resetKeyboardOverlayFrame()
    }
    
    public func setupKeyboardListener() {
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
    
    public func resetKeyboardOverlayFrame() {
        keyboardOverlayView.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: 300)
    }
    
    public func showKeyboardOverlay() {
        hiddenTextField.becomeFirstResponder()
        UIApplication.shared.windows.last?.addSubview(keyboardOverlayView)
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
        toolbar.hide()
    }

    public func showToolbar() {
        toolbar.show()
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

