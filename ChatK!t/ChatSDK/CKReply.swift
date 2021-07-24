//
//  CKReply.swift
//  ChatK!t
//
//  Created by ben3 on 22/04/2021.
//

import Foundation

open class CKReply: Reply {
    
    
    var name: String?
    var text: String?
    var imageURL: URL?
    var placeholder: UIImage?
    
    init(name: String?, text: String? = nil, imageURL: URL? = nil, placeholder: UIImage? = nil) {
        self.name = name
        self.text = text
        self.imageURL = imageURL
        self.placeholder = placeholder
    }
    
    open func replyTitle() -> String? {
        return name
    }
    
    open func replyText() -> String? {
        return text
    }
    
    open func replyImageURL() -> URL? {
        return imageURL
    }
    
    open func replyPlaceholder() -> UIImage? {
        return placeholder
    }

}
