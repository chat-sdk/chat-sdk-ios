//
//  Reply.swift
//  ChatK!t
//
//  Created by ben3 on 22/04/2021.
//

import Foundation

public protocol Reply : class {
    func replyTitle() -> String?
    func replyText() -> String?
    func replyImageURL() -> URL?
    func replyPlaceholder() -> UIImage?
}
