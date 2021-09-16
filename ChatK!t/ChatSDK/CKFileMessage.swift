//
//  CKFileMessage.swift
//  ChatK!tExtras
//
//  Created by ben3 on 08/09/2021.
//

import Foundation
import ChatKit
import ChatSDK

public class CKFileMessage: CKDownloadableMessage {

    open var localFileURL: URL?

    public override init(message: PMessage) {
        super.init(message: message)
        localFileURL = ChatKit.downloadManager().localURL(for: messageId())
    }

    open func fileURL() -> URL? {
        if let path = messageMeta()?[bMessageFileURL] as? String {
            return URL(string: path)
        }
        return nil
    }
    
    open func imageURL() -> URL? {
        if let url = self.message.meta()[bMessageImageURL] as? String {
            return  URL(string: url);
        }
        return nil
    }

    open override func downloadFinished(_ url: URL?, error: Error? = nil) {
        if let url = url {
            if url.isFileURL{
                localFileURL = url
            } else {
                localFileURL = URL(fileURLWithPath: url.path)
            }
        }
        super.downloadFinished(url, error: error)
    }

    open override func startDownload() {
         if let url = messageMeta()?[bMessageFileURL] as? String {
            ChatKit.downloadManager().startTask(messageId(), pathExtension: pathExtension(), url: url)
        }
    }
    
    open func pathExtension() -> String? {
        let name = messageText() as NSString?
        return name?.pathExtension.lowercased()
    }
    
    open override func uploadFinished(_ data: Data?, error: Error?) {
        // Get the local video URL
        if let content = messageContent() as? UploadableContent {
            if let data = data {
                do {
                    let url = try ChatKit.downloadManager().save(data, messageId: messageId(), pathExtension: pathExtension())
                    localFileURL = url
                    content.uploadFinished?(url, error: nil)
                } catch {
                    content.uploadFinished?(nil, error: error)
                }
            } else {
                content.uploadFinished?(nil, error: error)
            }
        }
    }
    
    open override func isDownloaded() -> Bool {
        return localFileURL != nil
    }
            

}

