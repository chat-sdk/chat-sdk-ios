//
//  IntegrateOptions.swift
//  ChatK!t
//
//  Created by ben3 on 21/06/2021.
//

import Foundation
import ChatSDK

public extension ChatKitModule {
    
    func addOptions(model: ChatModel, vc: ChatViewController, thread: PThread) {

        let optionsOverlay = OptionsKeyboardOverlay()
        
        let options = [
            Option(galleryOnClick: {
                let action = BSelectMediaAction(type: bPictureTypeAlbumImage, viewController: vc)
                _ = action?.execute()?.thenOnMain({ success in
                    if let imageMessage = BChatSDK.imageMessage(), let photo = action?.photo {
                        imageMessage.sendMessage(with: photo, withThreadEntityID: thread.entityID())
                    }
                    return success
                }, nil)
            }),
            Option(locationOnClick: { [weak self] in
                self?.locationAction = BSelectLocationAction()
                _ = self?.locationAction?.execute()?.thenOnMain({ location in
                    if let locationMessage = BChatSDK.locationMessage(), let location = location as? CLLocation {
                        locationMessage.sendMessage(with: location, withThreadEntityID: thread.entityID())
                    }
                    return location
                }, nil)
            }),
            Option(videoOnClick: {
                let action = BSelectMediaAction(type: bPictureTypeAlbumVideo, viewController: vc)
                _ = action?.execute()?.thenOnMain({ success in
                    if let videoMessage = BChatSDK.videoMessage(), let data = action?.videoData, let coverImage = action?.coverImage {
                        // Set the local url of the message
                        videoMessage.sendMessage(withVideo: data, cover: coverImage, withThreadEntityID: thread.entityID())
                    }
                    return success
                }, nil)
            }),
        ]
        
        optionsOverlay.setOptions(options: options)
                    
        model.addKeyboardOverlay(name: OptionsKeyboardOverlay.key, overlay: optionsOverlay)
        
    }
}
