//
//  MessageReplyView.swift
//  ChatK!t
//
//  Created by ben3 on 17/04/2021.
//

import Foundation

open class MessageReplyView: UIView {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var divider: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = ChatKit.asset(color: ChatKit.config().replyBackgroundColor)
        titleLabel.textColor = ChatKit.asset(color: ChatKit.config().replyTitleColor)
        textLabel.textColor = ChatKit.asset(color: ChatKit.config().replyTextColor)
        imageView.contentMode = .scaleAspectFill
        layer.cornerRadius = ChatKit.config().replyViewCornerRadius
        translatesAutoresizingMaskIntoConstraints = false
        clipsToBounds = true
    }
    
    open func showImage() {
        imageView.keepWidth.equal = ChatKit.config().messageReplyViewHeight
    }
    
    open func hideImage() {
        imageView.keepWidth.equal = 0
    }
    
}

