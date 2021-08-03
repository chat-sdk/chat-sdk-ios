//
//  MessageContent.swift
//  AFNetworking
//
//  Created by ben3 on 20/07/2020.
//

import Foundation

public protocol MessageContent : class {
    func view() -> UIView
    func bind(_ message: AbstractMessage, model: MessagesModel)
    func showBubble() -> Bool
    func bubbleCornerRadius() -> CGFloat
}

public protocol DownloadableContent : class {
    func setDownloadProgress(_ progress: Float)
    func downloadFinished(_ url: URL?, error: Error?)
    func downloadPaused()
    func downloadStarted()
}

public protocol UploadableContent : class {
    func setUploadProgress(_ progress: Float)
    func uploadFinished(_ url: URL?, error: Error?)
    func uploadStarted()
}

