//
//  SystemMessageCell.swift
//  ChatK!t
//
//  Created by ben3 on 05/08/2021.
//

import Foundation
import KeepLayout

public class SystemMessageCell: AbstractMessageCell {
    
    @IBOutlet weak var contentContainerView: UIView!
    
    open override func setContent(content: MessageContent) {
        if self.content == nil {
            self.content = content
            contentContainerView.addSubview(content.view())
            content.view().keepInsets.equal = KeepRequired(0)
        }
    }
    
    open override func bind(_ message: AbstractMessage, model: MessagesModel) {
        if let content = self.content {
            content.bind(message, model: model)
        }
    }
}
