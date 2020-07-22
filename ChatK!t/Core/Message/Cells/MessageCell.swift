//
//  OutcomingTextMessageCell.swift
//  AFNetworking
//
//  Created by ben3 on 18/07/2020.
//

import Foundation
import UIKit
import LoremIpsum
import KeepLayout

@objc public enum BubbleMaskPosition: Int {
    case topRight
    case topLeft
    case bottomRight
    case bottomLeft
}

@objc public class MessageCell: UITableViewCell {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var contentContainerView: UIView!
    @IBOutlet weak var bubbleMask: UIView!
    @IBOutlet weak var readReceiptImageView: UIImageView?

    var content: MessageContent?
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        timeLabel.numberOfLines = 0
        timeLabel.translatesAutoresizingMaskIntoConstraints = false

    }
    
    @objc public func setContent(content: MessageContent) {
        if self.content == nil {
            self.content = content
            contentContainerView.addSubview(content.view())
//            contentContainerView.clipsToBounds = true

            content.view().keepInsets.equal = KeepRequired(0)

            if content.showBubble() {
                setBubbleCornerRadius(radius: content.bubbleCornerRadius())
            } else {
                setBubbleColor(color: .clear)
            }
        }
    }
    
    @objc public func bind(message: Message, model: MessagesViewModel) {
        if let content = self.content {
            content.bind(message: message)
        }
        if let url = message.messageSender().userImageUrl() {
            avatarImageView.sd_setImage(with: url, completed: nil)
        }
        timeLabel.text = model.messageTimeFormatter().string(from: message.messageDate())
        
        setAvatarSize(size: model.avatarSize())
        
        if content?.showBubble() ?? true {
            switch message.messageDirection() {
            case .incoming:
                setBubbleColor(color: model.incomingBubbleColor())
                setBubbleMaskPosition(position: .topLeft)
            case .outgoing:
                setBubbleColor(color: model.outgoingBubbleColor())
                setBubbleMaskPosition(position: .bottomRight)
            }
        }
                
        if let imageView = readReceiptImageView {
            switch message.messageReadStatus() {
            case .sent:
                imageView.image = UIImage(named: "icn_message_sent", in: model.bundle(), compatibleWith: nil)
            case .delivered:
                imageView.image = UIImage(named: "icn_message_delivered", in: model.bundle(), compatibleWith: nil)
            case .read:
                imageView.image = UIImage(named: "icn_message_read", in: model.bundle(), compatibleWith: nil)
            default:
                imageView.image = nil
            }
        }
    }

    @objc public func setAvatarSize(size: CGFloat) {
        avatarImageView.keepSize.equal = size
        avatarImageView.layer.cornerRadius = size / 2.0
    }

    @objc public func setBubbleColor(color: UIColor) {
        contentContainerView.backgroundColor = color
        bubbleMask.backgroundColor = color
    }

    @objc public func setBubbleCornerRadius(radius: CGFloat) {
        contentContainerView.layer.cornerRadius = radius
        bubbleMask.keepSize.equal = radius
        content?.view().layer.cornerRadius = radius
    }

    @objc public func setBubbleMaskPosition(position: BubbleMaskPosition) {
        switch position {
        case .topLeft:
            bubbleMask.keepTopInset.equal = 0
            bubbleMask.keepLeftInset.equal = 0
        case .topRight:
            bubbleMask.keepTopInset.equal = 0
            bubbleMask.keepRightInset.equal = 0
        case .bottomLeft:
            bubbleMask.keepBottomInset.equal = 0
            bubbleMask.keepLeftInset.equal = 0
        case .bottomRight:
            bubbleMask.keepBottomInset.equal = 0
            bubbleMask.keepRightInset.equal = 0
        }
    }
        
}

extension MessageCell {
    class func fromNib<T: MessageCell>(nib: UINib) -> T {
        return nib.instantiate(withOwner: self, options: nil)[0] as! T
    }
}
