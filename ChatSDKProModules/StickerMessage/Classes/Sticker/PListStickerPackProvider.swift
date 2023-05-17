//
//  PListStickerPackProvider.swift
//  MessageModules
//
//  Created by Ben on 17/09/2022.
//

import Foundation

enum StickerMessageError: Error {
    case plistDoesNotExist
}


public class PListStickerPackProvider: StickerPackProvider {
    
    let plist: String
    let bundle: Bundle
    
    public init(plist: String, bundle: Bundle) {
        self.plist = plist
        self.bundle = bundle
    }

    public func preload() {
        _ = getPacks().subscribe()
    }
    
    public func getPacks() -> Single<[StickerPack]> {
        return Single.deferred({ [weak self] in

            guard let plist = self?.plist, let filePath = self?.bundle.path(forResource: plist, ofType: "plist") else {
                return Single.error(StickerMessageError.plistDoesNotExist)
            }
            guard let data = NSArray(contentsOfFile: filePath) else  {
                return Single.error(StickerMessageError.plistDoesNotExist)
            }
            
            var packs: [StickerPack] = []

            for item in data {
                if let item = item as? NSDictionary {
                    // Make a new pack
                    let pack = StickerPack(with: item)
                    packs.append(pack)
                }
             }
            
            return Single.just(packs)

        })
    }
    
    public func imageURL(name: String) -> String? {
        return bundle.path(forResource: name, ofType: nil)
    }
    
}
