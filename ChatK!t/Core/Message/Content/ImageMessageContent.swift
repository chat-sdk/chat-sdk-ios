//
//  ImageMessageContent.swift
//  ChatK!t
//
//  Created by ben3 on 27/05/2021.
//

import Foundation
import KeepLayout
import FLAnimatedImage

public class ImageMessageContent: DefaultMessageContent, DownloadableContent {
    
    lazy var _view: ImageMessageView = {
        let view: ImageMessageView = .fromNib()
        view.layer.cornerRadius = ChatKit.config().bubbleCornerRadius
        view.clipsToBounds = true
//        view.contentMode = .scaleAspectFill
//        view.keepWidth.min = 200
//        view.keepHeight.min = 200
//        view.keepWidth.equal = KeepLow(400)
//        view.keepHeight.equal = KeepLow(400)
        return view
    }()

    public override func view() -> UIView {
        return _view
    }
    
    public override func bind(_ message: Message, model: MessagesModel) {
        super.bind(message, model: model)

        if ChatKit.config().loadImageMessageFromURL {
            _view.imageView.sd_setImage(with: message.messageImageUrl(), completed: nil)
        } else if let downloadable = message as? DownloadableMessage {
            if let local = downloadable.messageLocalURL() {
                // The message is downloaded already
                _view.imageView.sd_setImage(with: local, completed: nil)
            } else {
                downloadable.startDownload()
            }
        }
        view().setMaskPosition(direction: message.messageDirection())
        _view.imageView.setMaskPosition(direction: message.messageDirection())
    }
    
    public override func showBubble() -> Bool {
        return false
    }
    
    public func setProgress(_ progress: Float) {
        
    }
    
    public func downloadFinished(_ url: URL?, error: Error?) {
        if error == nil {
            _view.imageView.sd_setImage(with: url, completed: nil)
        }
    }
    
    public func downloadPaused() {
        
    }
    
    public func downloadStarted() {
        
    }
}

public class ImageMessageView: UIView {
    
    @IBOutlet weak var imageView: FLAnimatedImageView!
    
}
