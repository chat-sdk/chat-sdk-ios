//
//  TextMessageContent.swift
//  AFNetworking
//
//  Created by ben3 on 20/07/2020.
//

import Foundation
import KeepLayout
import SDWebImage

public class TextMessageContent: DefaultMessageContent {
    
    public lazy var label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public lazy var replyView: MessageReplyView = {
        return ChatKit.provider().messageReplyView()
    }()
    
    public lazy var containerView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.addSubview(label)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        label.keepLeftInset.equal = ChatKit.config().bubbleInsets.left
        label.keepBottomInset.equal = ChatKit.config().bubbleInsets.bottom
        label.keepRightInset.equal = ChatKit.config().bubbleInsets.right
        label.keepTopInset.equal = KeepHigh(ChatKit.config().bubbleInsets.top)
        
        return view
    }()
    
    override public func view() -> UIView {
        return containerView
    }
    
    override public func bind(_ message: AbstractMessage, model: MessagesModel) {
        super.bind(message, model: model)

        if message.messageDirection() == .incoming {
            replyView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner]
        }
        if message.messageDirection() == .outgoing {
            replyView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner]
        }
        if let reply = message.messageReply() {
            showReply(title: reply.replyTitle(), text: reply.replyText(), imageURL: reply.replyImageURL(), placeholder: reply.replyPlaceholder())
        } else {
            hideReply()
        }
        label.text = message.messageText()
//        containerView.setNeedsLayout()
    }
    
    public func hideReply() {
        if replyView.superview != nil {
            label.keepTopOffsetTo(replyView)?.deactivate()
            replyView.removeFromSuperview()
            label.keepTopInset.equal = ChatKit.config().bubbleInsets.top
        }
    }
    
    public func showReply(title: String?, text: String?, imageURL: URL? = nil, placeholder: UIImage? = nil) {
        if replyView.superview == nil {
            containerView.addSubview(replyView)

            replyView.keepLeftInset.equal = ChatKit.config().bubbleInsets.left
            replyView.keepTopInset.equal = ChatKit.config().bubbleInsets.top
            replyView.keepRightInset.equal = ChatKit.config().bubbleInsets.right
            replyView.keepHeight.equal = KeepFitting(ChatKit.config().messageReplyViewHeight)

            label.keepTopInset.deactivate()
            label.keepTopOffsetTo(replyView)?.equal = ChatKit.config().bubbleInsets.top
        }
  
        replyView.titleLabel.text = title
        replyView.textLabel.text = text
        if let url = imageURL {
            replyView.showImage()
            replyView.imageView.sd_setImage(with: url, placeholderImage: placeholder, options: .scaleDownLargeImages, completed: nil)
        } else if let placeholder = placeholder {
            replyView.showImage()
            replyView.imageView.image = placeholder
        } else {
            replyView.hideImage()
        }
    }
        
}
