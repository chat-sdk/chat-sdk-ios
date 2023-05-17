//
//  GiphyMessageModule.swift
//  MessageModules
//
//  Created by Ben on 16/06/2022.
//

import Foundation
import ChatSDK
import FLAnimatedImage
import Licensing
import ChatKit
import GiphyUISDK
import GiphyUISDK

@objc open class GiphyMessageModule: NSObject, PModule {
    
    let apiKey: String
    
    public init(apiKey: String) {
        self.apiKey = apiKey
        Giphy.configure(apiKey: apiKey)
    }
    
    @objc public func weight() -> Int32 {
        return 100
    }

    @objc public func activate() {
        if !apiKey.isEmpty {
            Licensing.shared().add(item: String(describing: type(of: self)))
     
            BChatSDK.shared().networkAdapter.setGifMessage(GiphyMessageHandler())
            
            ChatKitModule.shared().get().add(newMessageProvider: GifMessageProvider(), type: Int(bMessageTypeGif.rawValue))
            ChatKitModule.shared().get().add(optionProvider: GiphyOptionProvider())
            
            let gifRegistration = MessageCellRegistration(messageType: String(bMessageTypeGif.rawValue), contentClass: GifMessageContent.self)
            ChatKitModule.shared().get().add(messageRegistration: gifRegistration)
        }
    }


}

public class GifMessageProvider: MessageProvider {
    public func new(for message: PMessage) -> CKMessage {
        return CKGifMessage(message: message)
    }
}

public class CKGifMessage: CKMessage, GifMessage {

    open func imageURL() -> URL? {
        return message.imageURL()
    }
    
}

public class GiphyOptionProvider: OptionProvider, GiphyDelegate {
    
    open weak var vc: ChatViewController?
    open weak var thread: PThread?
    
    public func provide(for vc: ChatViewController, thread: PThread) -> Option {
        self.vc = vc
        self.thread = thread
        return Option(giphyOnClick: { [weak self] in
            let giphy = GiphyViewController()
            giphy.delegate = self
            vc.present(giphy, animated: true)
        })
    }
    
    public func didDismiss(controller: GiphyViewController?) {
        controller?.dismiss(animated: true)
    }
    
    public func didSelectMedia(giphyViewController: GiphyViewController, media: GPHMedia) {
        if let gifURL = media.url(rendition: .fixedWidth, fileType: .gif), let thread = thread {
            _ = BChatSDK.gifMessage()?.sendMessageWithGif(url: gifURL, threadEntityID: thread.entityID())
        }
        giphyViewController.dismiss(animated: true)
    }
}
