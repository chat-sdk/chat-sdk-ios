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
    
    public func showImage() {
        imageView.keepWidth.equal = 50
    }
    
    public func hideImage() {
        imageView.keepWidth.equal = 0
    }
}

