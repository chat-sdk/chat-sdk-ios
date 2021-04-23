//
//  OutcomingTextMessageCell.swift
//  AFNetworking
//
//  Created by ben3 on 18/07/2020.
//

import Foundation
import UIKit
import KeepLayout

public enum BubbleMaskPosition: Int {
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
//            contentContainerView.clipsToBounds = true

            content.view().keepInsets.equal = KeepRequired(0)

            if content.showBubble() {
                setBubbleCornerRadius(radius: content.bubbleCornerRadius())
            } else {
                setBubbleColor(color: .clear)
            }
        }
    }
    
    public func bind(message: Message, model: MessagesModel, selected: Bool = false) {
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
                setBubbleColor(color: model.incomingBubbleColor(selected: selected))
                setBubbleMaskPosition(position: .topLeft)
            case .outgoing:
                setBubbleColor(color: model.outgoingBubbleColor(selected: selected))
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
        
        hideNameLabel()
    }

    public func setAvatarSize(size: CGFloat) {
        avatarImageView.keepSize.equal = size
        avatarImageView.layer.cornerRadius = size / 2.0
    }

    public func setBubbleColor(color: UIColor) {
        contentContainerView.backgroundColor = color
    }

    public func setBubbleCornerRadius(radius: CGFloat) {
        contentContainerView.layer.cornerRadius = radius
        content?.view().layer.cornerRadius = radius
    }

    public func setBubbleMaskPosition(position: BubbleMaskPosition) {
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
        contentContainerView.layer.maskedCorners = mask!
        content?.view().layer.maskedCorners = mask!
    }
    
    public func hideNameLabel() {
        nameLabel?.keepHeight.equal = 0
    }

    public func showNameLabel() {
        nameLabel?.keepHeight.equal = 17
    }

}

extension MessageCell {
    class func fromNib<T: MessageCell>(nib: UINib) -> T {
        return nib.instantiate(withOwner: self, options: nil)[0] as! T
    }
}
