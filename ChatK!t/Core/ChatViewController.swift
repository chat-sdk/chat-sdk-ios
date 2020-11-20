//
//  ChatViewController.swift
//  AFNetworking
//
//  Created by ben3 on 18/07/2020.
//

import Foundation
import UIKit
import KeepLayout

@objc public class ChatViewController: UIViewController {
    
    // View that contains the message list
    public var messagesView = MessagesView()
    public var keyboardOverlayView = UIView()
        
    // Text input bar
    public var textInputView = TextInputView()
    public var textInputViewBottomConstraint: NSLayoutConstraint?
    
    // Gesture recognizers
    var tapRecognizer: UITapGestureRecognizer?
    
    // Data model
    public let model: ChatViewControllerModel
    
    
    @objc public init(model: ChatViewControllerModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)

        // Hide the tab bar when the messages are shown
        hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
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
        
//        messagesView.keepInsets.equal = 0

        messagesView.keepTopInset.equal = 0
        messagesView.keepRightInset.equal = 0
        messagesView.keepLeftInset.equal = 0
        messagesView.keepBottomOffsetTo(textInputView)?.equal = 0
        
        messagesView.backgroundColor = .green
        messagesView.layer.borderColor = UIColor.red.cgColor
        messagesView.layer.borderWidth = 1
        
        textInputView.keepLeftInset.equal = 0
        textInputView.keepRightInset.equal = 0
        
        textInputView.addSendButton {
            
        }
        textInputView.addPlusButton {
            
        }
        
        textInputView.textView?.placeholder = "Write something..."

        textInputViewBottomConstraint = textInputView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        
        NSLayoutConstraint.activate([textInputViewBottomConstraint!])
        
        tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTap))
        // Add the gesture recognizer
        messagesView.addGestureRecognizer(tapRecognizer!)

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
    
    @objc public func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    @objc public func removeObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
        
    @objc private func keyboardWillChangeFrame(_ notification: Notification) {
        if let bottomConstraint = textInputViewBottomConstraint {
            if let endFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                var keyboardHeight = UIScreen.main.bounds.height - endFrame.origin.y
                if #available(iOS 11, *) {
                    if keyboardHeight > 0 {
                        keyboardHeight = keyboardHeight - view.safeAreaInsets.bottom
                    }
                }
                bottomConstraint.constant = -keyboardHeight
                view.superview?.layoutIfNeeded()
            }
        }
    }

}
