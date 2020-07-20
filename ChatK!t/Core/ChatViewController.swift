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

    let model: ChatViewControllerModel
    
    @objc public init(model: ChatViewControllerModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Ben"
        
        messagesView.setModel(model: model.messagesViewModel())
        
        view.addSubview(messagesView)
        
        messagesView.keepInsets.equal = 0
        
    }

}
