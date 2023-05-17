//
//  StickerPackProvider.swift
//  MessageModules
//
//  Created by Ben on 17/09/2022.
//

import Foundation
import RxSwift

public protocol StickerPackProvider {
    func preload()
    func getPacks() -> Single<[StickerPack]>
    func imageURL(name: String) -> String?
}
