//
//  MessageContent.swift
//  AFNetworking
//
//  Created by ben3 on 20/07/2020.
//

import Foundation

public protocol MessageContent {
 
    func view() -> UIView
    func bind(message: Message)
    func showBubble() -> Bool
    func bubbleCornerRadius() -> CGFloat

}

