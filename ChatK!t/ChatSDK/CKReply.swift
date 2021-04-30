//
//  CKReply.swift
//  ChatK!t
//
//  Created by ben3 on 22/04/2021.
//

import Foundation

public class CKReply: Reply {
    
    let name: String?
    let text: String?
    let imageURL: URL?
    
    init(name: String?, text: String? = nil, imageURL: URL? = nil) {
        self.name = name
        self.text = text
        self.imageURL = imageURL
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
    
}
