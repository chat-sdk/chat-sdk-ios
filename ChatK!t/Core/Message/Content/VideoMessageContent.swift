//
//  VideoMessageContent.swift
//  ChatK!t
//
//  Created by ben3 on 01/06/2021.
//

import Foundation

public class VideoMessageContent: ImageMessageContent {
    
    public override func bind(_ message: AbstractMessage, model: MessagesModel) {
        _view.videoIconVisible = true
        super.bind(message, model: model)
    }
    
    public override func downloadFinished(_ url: URL?, error: Error?) {
        super.downloadFinished(url, error: error)
        if url != nil {
            showVideoIcon()
        } else {
            hideVideoIcon()
        }
    }

    public override func downloadStarted() {
        super.downloadStarted()
        hideVideoIcon()
    }
    
    public override func uploadFinished(_ url: URL?, error: Error?) {
        super.uploadFinished(url, error: error)
        showVideoIcon()
    }
    
    public override func uploadStarted() {
        super.uploadStarted()
        hideVideoIcon()
    }

}
