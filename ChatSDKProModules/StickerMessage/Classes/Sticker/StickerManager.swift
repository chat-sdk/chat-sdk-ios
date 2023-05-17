//
//  StickerPacks.swift
//  ChatSDKModules-ChatStickerMessage
//
//  Created by ben3 on 11/01/2021.
//

import Foundation

@objc public class StickerManager: NSObject {
    
//    static let instance = StickerManager()
//    @objc public static func shared() -> StickerManager {
//        return instance
//    }
    
    @objc public var packs = [StickerPack]()
    
//    @objc public func loadFrom(plist: String, bundle: Bundle) -> Bool {
//        guard let filePath = bundle.path(forResource: plist, ofType: "plist") else {
//            return false
//        }
//        guard let data = NSArray(contentsOfFile: filePath) else  {
//            return false
//        }
//
//        for item in data {
//            if let item = item as? NSDictionary {
//                // Make a new pack
//                let pack = StickerPack(with: item)
//                packs.append(pack)
//            }
//         }
//
//        return true
//    }
    
    @objc public func addPack(_ pack: StickerPack) {
        packs.append(pack)
    }

    @objc public func removePack(_ pack: StickerPack) {
        packs.filter {
            $0 != pack
        }
    }

    @objc public func pack(at index: Int) -> StickerPack? {
        if index < packs.count {
            return packs[index]
        }
        return nil
    }
    
//    @objc public func loadDefaultStickers(name: String, bundle: Bundle) {
//        loadFrom(plist: name, bundle: bundle)
//    }
    
    @objc public func getStickerPacks() -> RXPromise {
        let promise = RXPromise()
        
        _ = StickerMessageModule.shared().stickerPackProvider?.getPacks().subscribe(onSuccess: { [weak self] success in
            
            self?.packs = success
            
            promise.resolve(withResult: success)
        }, onFailure: { error in
            promise.reject(withReason: error)
        })
        
        return promise
    }
    
}
