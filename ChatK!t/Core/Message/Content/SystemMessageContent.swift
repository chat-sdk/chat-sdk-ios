//
//  SystemMessageContent.swift
//  ChatK!t
//
//  Created by ben3 on 05/08/2021.
//

import Foundation
import KeepLayout

open class SystemMessageContent: DefaultMessageContent {

    open lazy var label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.italicSystemFont(ofSize: 13)
        return label
    }()

    open lazy var containerView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.addSubview(label)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        label.keepLeftInset.equal = ChatKit.config().systemMessageInsets.left
        label.keepBottomInset.equal = ChatKit.config().systemMessageInsets.bottom
        label.keepRightInset.equal = ChatKit.config().systemMessageInsets.right
        label.keepTopInset.equal = KeepHigh(ChatKit.config().systemMessageInsets.top)
        
        view.layer.cornerRadius = 5
        view.backgroundColor = ChatKit.asset(color: "gray_5")
        
        return view
    }()
    
    override open func view() -> UIView {
        return containerView
    }

    override open func bind(_ message: AbstractMessage, model: MessagesModel) {
        super.bind(message, model: model)
        label.text = message.messageText()
    }
    
    open override func showBubble() -> Bool {
        return false
    }

}
