//
//  MessageReplyView.swift
//  ChatK!t
//
//  Created by ben3 on 17/04/2021.
//

import Foundation

public class MessageReplyView: UIView {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var divider: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = ChatKit.asset(color: ChatKit.config().replyBackgroundColor)
        titleLabel.textColor = ChatKit.asset(color: ChatKit.config().replyTitleColor)
        textLabel.textColor = ChatKit.asset(color: ChatKit.config().replyTextColor)
        imageView.contentMode = .scaleAspectFill
        layer.cornerRadius = ChatKit.config().replyViewCornerRadius
        translatesAutoresizingMaskIntoConstraints = false
        clipsToBounds = true
    }
    
    public func showImage() {
        imageView.keepWidth.equal = ChatKit.config().messageReplyViewHeight
    }
    
    public func hideImage() {
        imageView.keepWidth.equal = 0
    }
    
}

