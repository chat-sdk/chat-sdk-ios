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
    case topRight
    case topLeft
    case bottomRight
    case bottomLeft
}

public class MessageCell: UITableViewCell {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var contentContainerView: UIView!
    @IBOutlet weak var readReceiptImageView: UIImageView?
    @IBOutlet weak var nameLabel: UILabel?
    
    var content: MessageContent?
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        timeLabel.numberOfLines = 0
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    public func setContent(content: MessageContent) {
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
    
    public func bind(_ message: Message, model: MessagesModel) {
        if let content = self.content {
            content.bind(message, model: model)
        }
        if let url = message.messageSender().userImageUrl() {
            avatarImageView.sd_setImage(with: url, completed: nil)
        }
        timeLabel.text = model.messageTimeFormatter.string(from: message.messageDate())
        
        setAvatarSize(size: model.avatarSize())
        
        if content?.showBubble() ?? true {
            setBubbleColor(color: model.bubbleColor(message))
            contentContainerView.setMaskPosition(direction: message.messageDirection())
            content?.view().setMaskPosition(direction: message.messageDirection())
        }
                
        if let imageView = readReceiptImageView {
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
        
        hideNameLabel()
    }

    public func setAvatarSize(size: CGFloat) {
        avatarImageView.keepSize.equal = KeepHigh(size)
        avatarImageView.layer.cornerRadius = size / 2.0
    }

    public func setBubbleColor(color: UIColor) {
        contentContainerView.backgroundColor = color
    }

    public func setBubbleCornerRadius(radius: CGFloat) {
        contentContainerView.layer.cornerRadius = radius
        content?.view().layer.cornerRadius = radius
    }
    
    public func hideNameLabel() {
        nameLabel?.keepHeight.equal = 0
    }

    public func showNameLabel() {
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
        var mask: CACornerMask?
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
        self.layer.maskedCorners = mask!
    }
}
