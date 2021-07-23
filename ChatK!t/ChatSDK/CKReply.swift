//
//  CKReply.swift
//  ChatK!t
//
//  Created by ben3 on 22/04/2021.
//

import Foundation

public class CKReply: Reply {
    
    
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
    
    public func replyTitle() -> String? {
        return name
    }
    
    public func replyText() -> String? {
        return text
    }
    
    public func replyImageURL() -> URL? {
        return imageURL
    }
    
    public func replyPlaceholder() -> UIImage? {
        return placeholder
    }

}
