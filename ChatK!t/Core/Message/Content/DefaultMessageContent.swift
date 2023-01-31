//
//  DefaultMessageContent.swift

//
//  Created by ben3 on 20/07/2020.
//

import Foundation

open class DefaultMessageContent: MessageContent {
    
    public required init() {
        
    }
    
    open func view() -> UIView {
        preconditionFailure("This method must be overridden")
    }
        
    open func bind(_ message: AbstractMessage, model: MessagesModel) {
        message.setContent(self)
    }
    
}

extension DefaultMessageContent {
    @objc open func showBubble() -> Bool {
        return true
    }
    @objc open func bubbleCornerRadius() -> CGFloat {
        return ChatKit.config().bubbleCornerRadius
    }
}

open class DefaultDownloadableMessageContent: DefaultMessageContent, DownloadableContent, UploadableContent {
    
    open override func bind(_ message: AbstractMessage, model: MessagesModel) {
        super.bind(message, model: model)
        progressViewHelper()?.setTick(color: model.bubbleColor(message))
        
        if let message = message as? DownloadableMessage {
            progressViewHelper()?.setDownloaded(message.isDownloaded())
        }
    }
        
    open func setDownloadProgress(_ progress: Float, total: Float) {
        progressViewHelper()?.setDownloadProgress(progress, total: total)
    }

    open func downloadFinished(_ url: URL?, error: Error?) {
        progressViewHelper()?.downloadFinished(url, error: error)
    }

    open func downloadPaused() {
        progressViewHelper()?.downloadPaused()
    }

    open func downloadStarted() {
        progressViewHelper()?.downloadStarted()
    }
    
    open func setUploadProgress(_ progress: Float, total: Float) {
        progressViewHelper()?.setUploadProgress(progress, total: total)
    }

    open func uploadFinished(_ url: URL?, error: Error?) {
        progressViewHelper()?.uploadFinished(url, error: error)
    }

    open func uploadStarted() {
        progressViewHelper()?.uploadStarted()
    }

    open func progressViewHelper() -> MessageProgressHelper? {
        preconditionFailure("This method must be overridden")
    }

}
