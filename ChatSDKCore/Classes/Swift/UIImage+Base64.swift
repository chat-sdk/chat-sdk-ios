//
//  UIImage+Base64.swift
//  ChatSDK
//
//  Created by Ben on 04/05/2022.
//

import Foundation
import UIKit

public extension UIImage {

    @objc func toBase64Leg(width: CGFloat, quality: CGFloat) -> String {
        return toBase64(width: width, quality: quality) ?? ""
    }
    
    func toBase64(width: CGFloat? = nil, quality: CGFloat = 0.2) -> String? {
        var image = self
        if let width = width {
            let height = size.height * (width ?? size.width) / size.width
            if let resized = resizedImage(CGSize(width: width, height: height), interpolationQuality: CGInterpolationQuality.high) {
                image = resized
            }
        }
        let data = image.jpegData(compressionQuality: quality)
        return data?.base64EncodedString(options: .lineLength64Characters)
    }
    
    public static func fromBase64(base64: String) -> UIImage? {
        if let data = NSData(base64Encoded: base64, options: .ignoreUnknownCharacters) {
            return UIImage(data: data as Data)
        }
        return nil
    }
    
}
