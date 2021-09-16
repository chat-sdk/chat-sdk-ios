//
//  FileMessageContent.swift
//  ChatK!t
//
//  Created by ben3 on 08/09/2021.
//

import Foundation
import ChatKit
import ChatSDK

open class FileMessageContent: DefaultDownloadableMessageContent, MessageProgressHelperDelegate {
    
    public let _view: FileMessageView = .fromNib()
    
    open var message: DownloadableMessage?
    
    public required init() {
        super.init()
        _view.progressHelper?.delegate = self
    }

    public override func view() -> UIView {
        return _view;
    }
    
    public override func bind(_ message: AbstractMessage, model: MessagesModel) {
        super.bind(message, model: model)
        
        if let message = message as? CKFileMessage {
            self.message = message
            
            updateImage()
            
            _view.textLabel.text = message.messageText()
        }
    }
    
    public override func downloadFinished(_ url: URL?, error: Error?) {
        super.downloadFinished(url, error: error)
    }
    
    public func updateImage() {
        if let message = message as? CKFileMessage {

            _view.imageView.isHidden = !message.isDownloaded()
            
            var image = UIImage(named: "file", in: Bundle(for: FileMessageContent.self), compatibleWith: nil)


            if let imageURL = message.imageURL() {
                 _view.imageView.sd_setImage(with: imageURL, completed: nil)
             } else if let name = message.messageText() as NSString? {
                 let ext = name.pathExtension.lowercased()
                 let imageName = "file-type-" + ext
                
                if ext == "png" || ext == "jpg" || ext == "jpeg" {
                    do {
                        if let url = message.localFileURL {
                            let data = try Data(contentsOf: url)
                            image = UIImage(data: data)
                        }
                    } catch {
                        
                    }
                } else {
                    let image = UIImage(named: imageName, in: Bundle(for: FileMessageContent.self), compatibleWith: nil)
                }
             } 
            _view.imageView.image = image
        }
    }
    
    public func startDownload() {
        message?.startDownload()
    }
    
    public func pauseDownload() {
        message?.pauseDownload()
    }
    
    public func isDownloading() -> Bool {
        message?.isDownloading ?? false
    }

    open func downloadFinished() {
        updateImage()
    }

    open override func progressViewHelper() -> MessageProgressHelper? {
        return _view.progressHelper
    }

}

