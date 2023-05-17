//
//  Sticker.swift
//  AFNetworking
//
//  Created by ben3 on 11/01/2021.
//

import Foundation
import ChatSDK
import FLAnimatedImage

@objc public class Sticker: NSObject {
    
    @objc public var image: UIImage?
    @objc public var animatedImage: FLAnimatedImage?
    @objc public var imageName: String?
    @objc public var sound: String?
    @objc public var isAnimated = false
    @objc public var url: String?
    
    @objc public init(data: Any) {
        super.init()
        if let imageName = data as? String {
            setImage(name: imageName)
        }
        if let data = data as? NSDictionary {
            if let imageName = data["image-name"] as? String {
                setImage(name: imageName)
            }
            if let soundName = data["sound-name"] as? String {
                self.sound = soundName
            }
        }
    }
    
    @objc public init(image: String, url: String? , sound: String? = nil) {
        super.init()
        setImage(name: image)
        self.sound = sound
        self.url = url
    }

    @objc public init(url: String? , sound: String? = nil) {
        super.init()
        self.sound = sound
        self.url = url
    }

    @objc public func setImage(name: String) {
        isAnimated = name.contains(".gif")
        imageName = name
        if isAnimated {
            if let anim = StickerMessageModule.shared().animatedImage(name) {
                animatedImage = anim
            }
        } else {
            image = StickerMessageModule.shared().image(name)
        }
    }
    
    
//    @objc public static func animatedImage(_ name: String, bundle: Bundle? = nil) -> FLAnimatedImage? {
//        return StickerMessageModule.shared().image(named: name)
//
//
//        let bundle = bundle ?? StickerMessageModule.bundle()
//        if let path = bundle?.path(forResource: name, ofType: nil) {
//            do {
//                let data = try Data(contentsOf: URL(fileURLWithPath: path))
//                return FLAnimatedImage(animatedGIFData: data)
//            } catch {
//                return nil
//            }
//        }
//        return nil
//    }
    
}
