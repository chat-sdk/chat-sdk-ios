//
//  AssetExtension.swift
//  ChatK!t
//
//  Created by Ben on 10/06/2022.
//

import Foundation
import AVFoundation
import Photos
import RXPromise

@objc public class AssetHelper: NSObject {
    
    @objc public class func thumbnailFor(asset: AVAsset, time: TimeInterval) -> UIImage? {
        let ig = AVAssetImageGenerator(asset: asset)
        ig.apertureMode = .encodedPixels
        ig.appliesPreferredTrackTransform = true
        do {
            let imageRef = try ig.copyCGImage(at: CMTimeMake(value: Int64(time), timescale: 60), actualTime: nil)
            return UIImage(cgImage: imageRef)
        } catch {
            return nil
        }
    }
    
    @objc public class func asset(asset: PHAsset) -> RXPromise {
        let promise = RXPromise()
        PHImageManager.default().requestAVAsset(forVideo: asset, options: nil, resultHandler: { asset, mimeType, _ in
            if let asset = asset as? AVAsset {
                if let asset = asset as? AVURLAsset {
                    promise.resolve(withResult: asset)
                } else {
                    let path = DownloadManager.downloadPath().appendingPathComponent(UUID().uuidString + ".mov")
                    
                    var preset = AVAssetExportPresetMediumQuality
                    let compatiblePresets = AVAssetExportSession.exportPresets(compatibleWith: asset)
                    if !compatiblePresets.contains(AVAssetExportPresetMediumQuality) {
                        if let first = compatiblePresets.first {
                            preset = first
                        }
                    }
                    
                    if let export = AVAssetExportSession(asset: asset, presetName: preset) {
                        export.outputFileType = .mov
                        export.outputURL = path
                        export.exportAsynchronously(completionHandler: {
                            let asset = AVURLAsset(url: path)
                            promise.resolve(withResult: asset)
                        })
                    } else {
                        promise.reject(withReason: nil)
                    }
                }
            } else {
                promise.reject(withReason: nil)
            }
        })
        return promise
    }
}
