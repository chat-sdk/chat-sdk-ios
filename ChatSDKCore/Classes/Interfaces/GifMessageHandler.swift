//
//  PGifMessageHandler.swift
//  ChatSDK
//
//  Created by Ben on 16/06/2022.
//

import Foundation
import RXPromise

@objc public protocol GifMessageHandler {
    @objc func sendMessageWithGif(url: String, threadEntityID: String) -> RXPromise?
}
