//
//  AssetExtension.swift
//  ChatK!t
//
//  Created by Ben on 10/06/2022.
//

import Foundation
import AVFoundation

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
    
}
