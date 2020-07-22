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
    
    var messagesView = MessagesView()
    var keyboardOverlayView = UIView()

    let model: ChatViewControllerModel
    
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
        
        title = model.title()
        
        messagesView.setModel(model: model.messagesViewModel())
        
        view.addSubview(messagesView)
        view.addSubview(keyboardOverlayView)
        
//        keyboardOverlayView.isHidden = yes
        
        messagesView.keepInsets.equal = 0
        
    }
    
    @objc public func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(notification:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardDidHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc public func removeObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    @objc public func keyboardWillShow(notification: Notification) {
        
        
        guard let boundsValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {}
        
        
        if let boundsValue: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
            let durationValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
            let curveValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        {
            let bounds = self.view.convert(boundsValue.cgRectValue, to: nil)
            
            let keyboardRectangle = boundsValue.cgRectValue
            let keyboardHeight = boundsValue.height
            
        }
    }

    @objc public func keyboardDidShow(notification: Notification) {
        
    }

    @objc public func keyboardWillHide(notification: Notification) {
        
    }

    @objc public func keyboardDidHide(notification: Notification) {
        
    }

}
