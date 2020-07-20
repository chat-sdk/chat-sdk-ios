//
//  MessageContent.swift
//  AFNetworking
//
//  Created by ben3 on 20/07/2020.
//

import Foundation

@objc public protocol MessageContent {
 
    @objc required init()
    @objc func view() -> UIView
    @objc func bind(message: Message)

}
