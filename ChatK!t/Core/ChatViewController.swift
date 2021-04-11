//
//  ChatViewController.swift
//  AFNetworking
//
//  Created by ben3 on 18/07/2020.
//

import Foundation
import UIKit
import KeepLayout

open class ChatViewController: UIViewController {
    
    // View that contains the message list
    public var messagesView = MessagesView()
    public var keyboardOverlayView = UIView()
    public var headerView = ChatHeaderView()
    public var reconnectingView = ReconnectingView()
    public var replyView = ReplyView()
    
    public var keyboardListener = KeyboardListener()
        
    // Text input bar
    public lazy var textInputView = {
        return TextInputView()
    }()
    // This view bridges between the bottom of the text input view and the bottom of the safe area
    public var textInputViewFooter: UIView?
    public var textInputViewBottomConstraint: NSLayoutConstraint?
    public var textInputViewFooterBottomConstraint: NSLayoutConstraint?

    // Gesture recognizers
    var tapRecognizer: UITapGestureRecognizer?
    
    // Data model
    public let model: ChatViewControllerModel
    
    public init(model: ChatViewControllerModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)

        // Hide the tab bar when the messages are shown
        hidesBottomBarWhenPushed = true
        navigationItem.largeTitleDisplayMode = .never
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13, *) {
            view.backgroundColor = .systemBackground
        } else {
            view.backgroundColor = .white
        }
        
        title = model.title()
        
        messagesView.setModel(model: model.messagesViewModel())
        
        view.addSubview(messagesView)
        view.addSubview(keyboardOverlayView)
        
//        keyboardOverlayView.isHidden = yes
        
        view.addSubview(textInputView)
        
        messagesView.keepInsets.equal = 0

//        messagesView.keepTopInset.equal = 0
//        messagesView.keepRightInset.equal = 0
//        messagesView.keepLeftInset.equal = 0
//        messagesView.keepBottomOffsetTo(textInputView)?.equal = 0
        
        messagesView.backgroundColor = .green
        messagesView.layer.borderColor = UIColor.red.cgColor
        messagesView.layer.borderWidth = 1
        
        textInputView.keepLeftInset.equal = 0
        textInputView.keepRightInset.equal = 0
        
        textInputView.addSendButton {
            
        }
        textInputView.addPlusButton {
            
        }
        textInputView.addCameraButton {
            
        }
        textInputView.addMicButton {
            
        }
        
        textInputViewFooter = textInputView.makeBackground()
        view.insertSubview(textInputViewFooter!, belowSubview: textInputView)
        
        textInputViewFooter?.keepLeftInset.equal = 0
        textInputViewFooter?.keepRightInset.equal = 0
        textInputViewFooter?.keepBottomInset.equal = 0

        textInputViewBottomConstraint = textInputView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)

        textInputViewFooterBottomConstraint = textInputViewFooter!.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 20)

        NSLayoutConstraint.activate([
            textInputViewFooter!.topAnchor.constraint(equalTo: textInputView.topAnchor, constant: 0),
            textInputViewBottomConstraint!,
            textInputViewFooterBottomConstraint!
        ])
        
//        textInputViewFooter?.keepTopAlignTo(textInputView).top
        
//        textInputView.textView?.placeholder = "Write something..."

        
//        NSLayoutConstraint.activate([textInputViewBottomConstraint!])
        
        tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTap))
        // Add the gesture recognizer
        messagesView.addGestureRecognizer(tapRecognizer!)

        updateNavigationBar()
        setupReplyView()
        
        keyboardListener.willShow = { info in
            UIView.animate(withDuration: info.duration, delay: 0, options: info.curve, animations: { [weak self] in
                let height = info.height(view: self?.view)
                
                if var insets = self?.messagesView.tableView.contentInset {
                    insets.bottom = height
                    self?.messagesView.tableView.contentInset = insets
                    self?.messagesView.tableView.scrollIndicatorInsets = insets

//                    messagesView.tableView.scrollToRowAtIndexPath(editingIndexPath, atScrollPosition: .Top, animated: true)
                }
                
                self?.textInputViewBottomConstraint?.constant = -height
                self?.textInputViewFooterBottomConstraint?.constant = -height
                
                self?.view.layoutIfNeeded()
                
            }, completion: nil)
        }
        
        keyboardListener.willHide = { info in
            UIView.animate(withDuration: info.duration, delay: 0, options: info.curve, animations: { [weak self] in
                self?.textInputViewBottomConstraint?.constant = 0
                self?.textInputViewFooterBottomConstraint?.constant = 20
                self?.view.layoutIfNeeded()
            }, completion: nil)

        }
    }
    
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Handle the tableView insets
        if let height = self.textInputViewBottomConstraint?.constant {
            
        }
        
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
        replyView.keepBottomOffsetTo(textInputView)?.equal = 0
        replyView.hide(duration: 0)
    }
    
    open func setTitle(text: String) {
        headerView.titleLabel?.text = text
    }
    
    public func setSubtitle(text: String) {
        headerView.subtitleLabel?.text = text
    }
    
    @objc public func onTap(recognizer: UITapGestureRecognizer) {
        if messagesView.selectionModeEnabled() {
            
        } else {
            textInputView.textView?.resignFirstResponder()
        }
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addObservers()
    }
    
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObservers()
    }
    
    public func addObservers() {
        keyboardListener.addObservers()
    }

    public func removeObservers() {
        keyboardListener.removeObservers()
    }
        
//    @objc public func keyboardWillChangeFrame(_ notification: Notification) {
//        if let bottomConstraint = textInputViewBottomConstraint, let footerBottomConstraint = textInputViewFooterBottomConstraint {
//            if let info = notification.userInfo {
//                if let endFrame = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
//                    var keyboardHeight = UIScreen.main.bounds.height - endFrame.origin.y
//                    if #available(iOS 11, *) {
//                        if keyboardHeight > 0 {
//                            keyboardHeight = keyboardHeight - view.safeAreaInsets.bottom
//                        }
//                    }
////                    bottomConstraint.constant = -keyboardHeight
////
////                    var insets = messagesView.tableView.contentInset
////                    insets.bottom = keyboardHeight
////                    messagesView.tableView.contentInset = insets
////                    messagesView.tableView.scrollIndicatorInsets = insets
//
//    //                messagesView.tableView.scrollToRowAtIndexPath(editingIndexPath, atScrollPosition: .Top, animated: true)
//
//
//                    // Percentage
//                    let percentage = keyboardHeight / endFrame.size.height
////                    textInputViewFooter?.alpha = 1 - percentage
//
////                    footerBottomConstraint.constant = keyboardHeight * percentage
////                    view.setNeedsLayout()
//
////                    textInputViewFooter?.keepBottomInset.equal = keyboardHeight * percentage
////                    view.superview?.superview?.layoutIfNeeded()
////                    textInputViewFooter?.layoutIfNeeded()
//
////                    textInputView.setBackgroundAlpha(alpha: percentage)
//                }
//            }
//        }
//    }
  
}
