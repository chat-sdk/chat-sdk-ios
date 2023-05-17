//
//  GiphyMessageHandler.swift
//  MessageModules
//
//  Created by Ben on 16/06/2022.
//

import Foundation
import ChatSDK

public class GiphyMessageHandler: GifMessageHandler {

    public func sendMessageWithGif(url: String, threadEntityID: String) -> RXPromise? {
        if let message = BMessageBuilder.message().type(bMessageTypeGif).thread(threadEntityID).build() {
            message.setMeta([bMessageImageURL: url])
            return BChatSDK.thread().send(message)
        }
        return nil
    }
    
}
