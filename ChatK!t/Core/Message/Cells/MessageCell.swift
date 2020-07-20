//
//  OutcomingTextMessageCell.swift
//  AFNetworking
//
//  Created by ben3 on 18/07/2020.
//

import Foundation
import UIKit
import LoremIpsum

@objc public class MessageCell: UITableViewCell {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var contentContainerView: UIView!
    
    var content: MessageContent?
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()

//        textView.translatesAutoresizingMaskIntoConstraints = true
//        textView.sizeToFit()
        
//        message.text = LoremIpsum.words(withNumber: 1 + UInt(arc4random() % 100))
//        message.lineBreakMode = .byWordWrapping
//        messageLabel.numberOfLines = 0
//        messageLabel.translatesAutoresizingMaskIntoConstraints = false
//        message.sizeToFit()

    }
    
    @objc public func setContent(content: MessageContent) {
        if self.content !== content &&  self.content != nil {
            self.content?.view().removeFromSuperview()
        }
        self.content = content
        contentContainerView.addSubview(content.view())
        content.view().keepInsets.equal = 0
    }
    
    @objc public func bind(message: Message, model: MessagesViewModel) {
        if let content = self.content {
            content.bind(message: message)
        }
        if let url = message.messageSender().userImageUrl() {
            avatarImageView.sd_setImage(with: url, completed: nil)
        }
        timeLabel.text = model.messageTimeFormatter().string(from: message.messageDate())
    }
    
    @objc public func setContent(view: UIView) {
    }
    
}
