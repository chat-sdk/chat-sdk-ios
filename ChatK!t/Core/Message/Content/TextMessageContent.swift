//
//  TextMessageContent.swift
//  AFNetworking
//
//  Created by ben3 on 20/07/2020.
//

import Foundation

public class TextMessageContent: DefaultMessageContent {
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var replyView: MessageReplyView = {
        let view: MessageReplyView = .fromNib()
        view.backgroundColor = ChatKit.asset(color: ChatKit.config().replyBackgroundColor)
        view.titleLabel.textColor = ChatKit.asset(color: ChatKit.config().replyTitleColor)
        view.textLabel.textColor = ChatKit.asset(color: ChatKit.config().replyTextColor)
        view.layer.cornerRadius = ChatKit.config().bubbleCornerRadius
        view.clipsToBounds = true
        return view
    }()
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.addSubview(label)
        
        label.keepLeftInset.equal = ChatKit.config().bubbleInsets.left
        label.keepBottomInset.equal = ChatKit.config().bubbleInsets.bottom
        label.keepRightInset.equal = ChatKit.config().bubbleInsets.right

        return view
    }()
    
    override public func view() -> UIView {
        return containerView
    }
    
    override public func bind(message: Message) {
        label.text = message.messageText()
        if message.messageDirection() == .incoming {
            replyView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner]
        }
        if message.messageDirection() == .outgoing {
            replyView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner]
        }
        if let reply = message.messageReply() {
            showReply(title: reply.replyTitle(), text: reply.replyText(), imageURL: reply.replyImageURL())
        } else {
            hideReply()
        }
    }
    
    public func hideReply() {
        replyView.removeFromSuperview()
        label.keepTopInset.equal = ChatKit.config().bubbleInsets.top
    }
    
    public func showReply(title: String?, text: String?, imageURL: URL? = nil) {
        containerView.addSubview(replyView)
        
        replyView.keepLeftInset.equal = ChatKit.config().bubbleInsets.left
        replyView.keepTopInset.equal = ChatKit.config().bubbleInsets.top
        replyView.keepRightInset.equal = ChatKit.config().bubbleInsets.right

        label.keepTopOffsetTo(replyView)?.equal = ChatKit.config().bubbleInsets.top
        
//        replyView.keepHeight.equal = ChatKit.config().chatReplyViewHeight
        replyView.titleLabel.text = title
        replyView.textLabel.text = text
        if let url = imageURL {
            replyView.showImage()
            replyView.imageView.sd_setImage(with: url, completed: nil)
        } else {
            replyView.hideImage()
        }
    }
        
}
