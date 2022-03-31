//
//  BImageCell.swift
//  ChatSDK
//
//  Created by Ben on 24/03/2022.
//

import Foundation
import UIKit
import KeepLayout

@objc public class BImageCell: UITableViewCell {
    
    @objc public let avatarImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(avatarImageView)
        
        avatarImageView.keepHorizontallyCentered()
        avatarImageView.keepWidth.equal = 100
        avatarImageView.keepHeight.equal = 100
        avatarImageView.keepTopInset.equal = 10
        avatarImageView.keepBottomInset.equal = 10

        avatarImageView.clipsToBounds = true
        avatarImageView.layer.cornerRadius = 50
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
