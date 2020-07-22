//
//  Conversation.swift
//  AFNetworking
//
//  Created by ben3 on 18/07/2020.
//

import Foundation

@objc public protocol Thread {
    
    @objc func threadId() -> String
    @objc func threadName() -> String
    @objc func threadImageUrl() -> URL?
    @objc func threadUsers() -> [User]
    @objc func threadMessages() -> [Message]
    @objc func threadType() -> ThreadType

}
