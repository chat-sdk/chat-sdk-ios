//
//  StickerPack.swift
//  AFNetworking
//
//  Created by ben3 on 11/01/2021.
//

import Foundation

@objc public class StickerPack: NSObject {
        
    @objc public var icon: UIImage?
    @objc public var stickers = [Sticker]()
    @objc public var url: String?
        
    public init(with dict: NSDictionary) {
        super.init()

        if let iconName = dict["icon"] as? String, let icon = StickerMessageModule.shared().image(iconName) {
            self.icon = icon
        }
        if let items = dict["stickers"] as? NSArray {
            for item in items {
                addSticker(sticker: Sticker(data: item))
            }
        }
    }
    
    public init(icon: String, url: String?, stickers: [Sticker]) {
        super.init()
        if let iconImage = StickerMessageModule.shared().image(icon) {
            self.icon = iconImage
        }
        self.url = url
        for sticker in stickers {
            addSticker(sticker: sticker)
        }
    }
    
    @objc public func sticker(at index: Int) -> Sticker? {
        if stickers.count > index {
            return stickers[index]
        }
        return nil
    }
        
    public func addSticker(sticker: Sticker) {
        stickers.append(sticker)
    }
    
    public func removeSticker(sticker: Sticker) {
        stickers.filter {
            return $0 != sticker
        }
    }
        
}
