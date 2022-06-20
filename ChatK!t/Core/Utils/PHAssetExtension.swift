//
//  PHAssetExtension.swift
//  ChatK!t
//
//  Created by Ben on 13/06/2022.
//

import Foundation
import Photos
import RXPromise

extension PHAsset {
    
    public func thumbnailImage(size: CGSize) -> UIImage {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.isSynchronous = true
        option.isNetworkAccessAllowed = true
        option.resizeMode = .fast
        manager.requestImage(for: self, targetSize: size, contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
            thumbnail = result!
        })
        return thumbnail
    }
    
    public func thumbnailImageAsync(size: CGSize) -> RXPromise {
        let promise = RXPromise()
        
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.isSynchronous = false
        option.isNetworkAccessAllowed = true
        option.resizeMode = .fast
        manager.requestImage(for: self, targetSize: size, contentMode: .aspectFill, options: option, resultHandler: { result, info in
            promise.resolve(withResult: result)
        })
        
        return promise
    }

}
