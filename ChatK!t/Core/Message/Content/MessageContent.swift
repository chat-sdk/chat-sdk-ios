//
//  MessageContent.swift
//  AFNetworking
//
//  Created by ben3 on 20/07/2020.
//

import Foundation

public protocol MessageContent {
    func view() -> UIView
    func bind(_ message: Message, model: MessagesModel)
    func showBubble() -> Bool
    func bubbleCornerRadius() -> CGFloat
}

public protocol DownloadableContent {
    func setProgress(_ progress: Float)
    func downloadFinished(_ url: URL?, error: Error?)
    func downloadPaused()
    func downloadStarted()
}
