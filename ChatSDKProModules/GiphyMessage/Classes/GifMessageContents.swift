//
//  GifMessageContents.swift
//  MessageModules
//
//  Created by Ben on 16/06/2022.
//

import Foundation
import ChatKit
import FLAnimatedImage

public class GifMessageContent: ImageMessageContent {

    public override func bind(_ message: AbstractMessage, model: MessagesModel) {

        hideVideoIcon()
        imageMessageView.hideProgressView()

        imageMessageView.checkView?.isHidden = !message.isSelected()

        imageMessageView.imageView?.image = nil
        imageMessageView.imageView?.animatedImage = nil

        imageMessageView.imageView?.keepWidth.equal = KeepHigh(size().width)
        imageMessageView.imageView?.keepHeight.equal = KeepHigh(size().height)
        imageMessageView.imageView?.contentMode = .scaleAspectFill

        if let gifMessage = message as? GifMessage, let url = gifMessage.imageURL() {
            do {
                imageMessageView.imageView?.sd_setImage(with: url)
            } catch {
                imageMessageView.imageView?.image = ChatKit.asset(icon: "icn_250_icon_unavailable")
            }
        } else {
            imageMessageView.imageView?.image = ChatKit.asset(icon: "icn_250_icon_unavailable")
        }

        view().setMaskPosition(direction: message.messageDirection())
        imageMessageView.imageView?.setMaskPosition(direction: message.messageDirection())
    }

    public override func size() -> CGSize {
        return CGSize(width: 200, height: 200)
    }


}


