//
//  OutcomingTextMessageCell.swift
//  AFNetworking
//
//  Created by ben3 on 18/07/2020.
//

import Foundation
import UIKit
import KeepLayout

public enum MaskPosition: Int {
    case none
    case topRight
    case topLeft
    case bottomRight
    case bottomLeft
}

open class AbstractMessageCell: UITableViewCell {

    open var content: MessageContent?

    open func setContent(content: MessageContent) {
        preconditionFailure("This method must be overridden")
    }
    open func bind(_ message: AbstractMessage, model: MessagesModel) {
        preconditionFailure("This method must be overridden")
    }
}

open class MessageCell: AbstractMessageCell {
    
    @IBOutlet open weak var avatarImageView: UIImageView?
    @IBOutlet open weak var timeLabel: UILabel?
    @IBOutlet open weak var contentContainerView: UIView!
    @IBOutlet open weak var readReceiptImageView: UIImageView?
    @IBOutlet open weak var nameLabel: UILabel?
        
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        timeLabel?.numberOfLines = 0
        timeLabel?.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView?.contentMode = .scaleAspectFill
        readReceiptImageView?.keepWidth.equal = ChatKit.config().readReceiptImageWidth
        readReceiptImageView?.keepHeight.equal = ChatKit.config().readReceiptImageHeight
        backgroundColor = .clear
    }
    
    open override func setContent(content: MessageContent) {
        if self.content == nil {
            self.content = content
            contentContainerView.addSubview(content.view())

            content.view().keepInsets.equal = KeepRequired(0)

            if content.showBubble() {
                setBubbleCornerRadius(radius: content.bubbleCornerRadius())
            } else {
                setBubbleColor(color: .clear)
            }
        }
    }
    
    open override func bind(_ message: AbstractMessage, model: MessagesModel) {
        if let content = self.content {
            content.bind(message, model: model)
        }
        if ChatKit.config().cacheUserImage, let image = message.messageSender().userImage() {
            avatarImageView?.image = image
        }
        else if let url = message.messageSender().userImageUrl() {
            avatarImageView?.sd_setImage(with: url, placeholderImage: ChatKit.asset(icon: "icn_100_avatar"))
        } else {
            avatarImageView?.image = ChatKit.asset(icon: "icn_100_avatar")
        }

        if ChatKit.config().hideAvatarForOutgoingMessages {
            if message.messageDirection() == .outgoing {
                setAvatarSize(size: 0)
            } else {
                setAvatarSize(size: model.avatarSize())
            }
        } else {
            setAvatarSize(size: model.avatarSize())
        }

        timeLabel?.text = model.messageTimeFormatter.string(from: message.messageDate())
        if message.messageDirection() == .incoming {
            timeLabel?.textColor = ChatKit.asset(color: ChatKit.config().incomingMessageTextColor)
        }
        if message.messageDirection() == .outgoing {
            timeLabel?.textColor = ChatKit.asset(color: ChatKit.config().outgoingMessageTextColor)
        }
                     
        if content?.showBubble() ?? true {
            setBubbleColor(color: model.bubbleColor(message))
            contentContainerView.setMaskPosition(direction: message.messageDirection())
            content?.view().setMaskPosition(direction: message.messageDirection())
        }
        
        if content?.showBubble() ?? true {
            if message.messageDirection() == .incoming {
                contentContainerView.layer.borderWidth = CGFloat(ChatKit.config().incomingBubbleBorderWidth)
                contentContainerView.layer.borderColor = ChatKit.asset(color: ChatKit.config().incomingBubbleBorderColor).cgColor
            }
            if message.messageDirection() == .outgoing {
                contentContainerView.layer.borderWidth = CGFloat(ChatKit.config().outgoingBubbleBorderWidth)
                contentContainerView.layer.borderColor = ChatKit.asset(color: ChatKit.config().outgoingBubbleBorderColor).cgColor
            }
        } else {
            contentContainerView.layer.borderWidth = 0
        }

        if message.messageSender().userIsMe() {
            // If the message failed to send, show a failure message
            if let status = message.messageSendStatus() {
                if status == .willSend {
                    readReceiptImageView?.image = ChatKit.asset(icon: "icn_message_will_send")
                } else if status == .failed {
                    readReceiptImageView?.image = ChatKit.asset(icon: "icn_message_retry")
                } else if let imageView = readReceiptImageView {
                    switch message.messageReadStatus() {
                    case .sent:
                        imageView.image = ChatKit.asset(icon: "icn_message_sent")
                    case .delivered:
                        imageView.image = ChatKit.asset(icon: "icn_message_delivered")
                    case .read:
                        imageView.image = ChatKit.asset(icon: "icn_message_read")
                    default:
                        imageView.image = nil
                    }
                }
            }
        } else {
            readReceiptImageView?.image = nil
        }

        if message.messageDirection() == .outgoing {
            if readReceiptImageView?.image == nil {
                timeLabel?.keepTrailingAlignTo(contentContainerView)?.equal = 2
            } else {
                timeLabel?.keepTrailingAlignTo(contentContainerView)?.deactivate()
//                timeLabel?.keepRightInset.deactivate()
            }
        }

        hideNameLabel()
    }

    open func setAvatarSize(size: CGFloat) {
        avatarImageView?.keepSize.equal = KeepRequired(size)
        avatarImageView?.layer.cornerRadius = size / 2.0
    }

    open func setBubbleColor(color: UIColor) {
        contentContainerView.backgroundColor = color
    }

    open func setBubbleCornerRadius(radius: CGFloat) {
        contentContainerView.layer.cornerRadius = radius
        content?.view().layer.cornerRadius = radius
    }
    
    open func hideNameLabel() {
        nameLabel?.keepHeight.equal = 0
    }

    open func showNameLabel() {
        nameLabel?.keepHeight.equal = 17
    }

}

public extension UIView {

    func setMaskPosition(direction: MessageDirection) {
        switch direction {
        case .incoming:
            setMaskPosition(position: .topLeft)
        case .outgoing:
            setMaskPosition(position: .bottomRight)
        }
    }

    func setMaskPosition(position: MaskPosition) {
        var mask: CACornerMask = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        if position == .topLeft {
            mask = [.layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        }
        if position == .topRight {
            mask = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        }
        if position == .bottomLeft {
            mask = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        }
        if position == .bottomRight {
            mask = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner]
        }
        self.layer.maskedCorners = mask
    }
}
