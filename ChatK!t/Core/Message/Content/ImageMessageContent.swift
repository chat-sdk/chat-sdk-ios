//
//  ImageMessageContent.swift
//  ChatK!t
//
//  Created by ben3 on 27/05/2021.
//

import Foundation

public class ImageMessageContent: DefaultMessageContent, DownloadableContent {
    
    lazy var _view: UIImageView = {
        let view = UIImageView()
        return view
    }()

    public override func view() -> UIView {
        return _view
    }
    
    public override func bind(_ message: Message, model: MessagesModel) {
        if !ChatKit.config().downloadImageMessages {
            _view.sd_setImage(with: message.messageImageUrl(), completed: nil)
        } else {
            if let local = message.messageLocalPath() {
                // The message is downloaded already
                _view.sd_setImage(with: local, completed: nil)
            } else {
                (message as? Downloadable)?.startDownload()
            }
        }
        _view.setMaskPosition(direction: message.messageDirection())
    }
    
    public override func showBubble() -> Bool {
        return false
    }
    
    public func setProgress(_ progress: Float) {
        
    }
    
    public func downloadFinished(_ url: URL?, error: Error?) {
        if error == nil {
            _view.sd_setImage(with: url, completed: nil)
        }
    }
    
    public func downloadPaused() {
        
    }
    
    public func downloadStarted() {
        
    }
}
