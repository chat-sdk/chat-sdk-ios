//
//  CKStickerMessage.swift
//  ChatK!t
//
//  Created by ben3 on 21/06/2021.
//

import Foundation
import ChatKit
import MessageModules

public class CKStickerMessage: CKMessage, HasPlaceholder {

    public override func placeholder() -> UIImage? {
        if let text = messageText() {
            return StickerMessageModule.shared().image(text)
        }
        return nil
    }

}
