//
//  MessageContent.swift
//  AFNetworking
//
//  Created by ben3 on 20/07/2020.
//

import Foundation

public protocol MessageContent : AnyObject {
    func view() -> UIView
    func bind(_ message: AbstractMessage, model: MessagesModel)
    func showBubble() -> Bool
    func bubbleCornerRadius() -> CGFloat
}

@objc public protocol DownloadableContent : AnyObject {
    @objc optional func setDownloadProgress(_ progress: Float)
    @objc optional func downloadFinished(_ url: URL?, error: Error?)
    @objc optional func downloadPaused()
    @objc optional func downloadStarted()
}

@objc public protocol UploadableContent : AnyObject {
    @objc optional func setUploadProgress(_ progress: Float)
    @objc optional func uploadFinished(_ url: URL?, error: Error?)
    @objc optional func uploadStarted()
}

