//
//  Base64ImageMessageHandler.swift
//  ChatSDK
//
//  Created by ben3 on 16/09/2021.
//

import Foundation
import ChatSDK
import RXPromise

enum Base64ImageMessageError: Error {
    case compressionFailed
}

@objc public class Base64ImageMessageHandler: NSObject, PImageMessageHandler {
    
    open var width: CGFloat = 800.0
    open var jpegQuality: CGFloat = 0.2
    
    public func sendMessage(with image: UIImage!, withThreadEntityID threadID: String!) -> RXPromise! {
        let promise = RXPromise()
        
        // Max width = 400 px
        let height = image.size.height * width / image.size.width
        
        if let resized = image.resizedImage(CGSize(width: width, height: height), interpolationQuality: CGInterpolationQuality.high) {
            let data = resized.jpegData(compressionQuality: jpegQuality)
            let base64 = data?.base64EncodedString(options: .lineLength64Characters)
            
            BChatSDK.db().beginUndoGroup()
            
            let message = BMessageBuilder()
                .textMessage(Bundle.t(bImageMessage))
                .meta([bMessageImageData: base64])
                .type(bMessageTypeBase64Image)
                .thread(threadID)
                .build()
            
            return BChatSDK.thread().send(message)
        } else {
            return RXPromise.reject(withReason: Base64ImageMessageError.compressionFailed)
        }
        
    }
    
}
