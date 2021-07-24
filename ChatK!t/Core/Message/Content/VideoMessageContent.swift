//
//  VideoMessageContent.swift
//  ChatK!t
//
//  Created by ben3 on 01/06/2021.
//

import Foundation

open class VideoMessageContent: ImageMessageContent {
    
    open override func bind(_ message: AbstractMessage, model: MessagesModel) {
        _view.videoIconVisible = true
        super.bind(message, model: model)
    }
    
    open override func downloadFinished(_ url: URL?, error: Error?) {
        super.downloadFinished(url, error: error)
        if url != nil {
            showVideoIcon()
        } else {
            hideVideoIcon()
        }
    }

    open override func downloadStarted() {
        super.downloadStarted()
        hideVideoIcon()
    }
    
    open override func uploadFinished(_ url: URL?, error: Error?) {
        super.uploadFinished(url, error: error)
        showVideoIcon()
    }
    
    open override func uploadStarted() {
        super.uploadStarted()
        hideVideoIcon()
    }

}
