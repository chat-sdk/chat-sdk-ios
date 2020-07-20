//
//  Message.swift
//  AFNetworking
//
//  Created by ben3 on 18/07/2020.
//

import Foundation

@objc public protocol Message {
    
    @objc func messageId() -> String
    @objc func messageType() -> String
    @objc func messageDate() -> Date
    @objc func messageText() -> String?
    @objc func messageSender() -> User
    @objc func messageImageUrl() -> URL?
    @objc func messageMeta() -> [AnyHashable: Any]?

}
