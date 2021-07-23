//
//  IntegrateActions.swift
//  ChatK!t
//
//  Created by ben3 on 21/06/2021.
//

import Foundation
import ChatSDK

public extension ChatKitModule {
 
    func addSendBarActions(model: ChatModel, vc: ChatViewController, thread: PThread) {
        
        model.addSendBarAction(SendBarActions.send {
            if let text = vc.sendBarView.text() {
                if let message = vc.replyToMessage(), let m = BChatSDK.db().fetchEntity(withID: message.messageId(), withType: bMessageEntity) as? PMessage {
                    BChatSDK.thread().reply(to: m, withThreadID: thread.entityID(), reply: text)
                    vc.hideReplyView()
                } else {
                    BChatSDK.thread().sendMessage(withText: text, withThreadEntityID: thread.entityID())
                }
                vc.sendBarView.clear()
            }
        })

        model.addSendBarAction(SendBarActions.mic {
            vc.showKeyboardOverlay(name: RecordKeyboardOverlay.key)
        })

        model.addSendBarAction(SendBarActions.plus {
            vc.showKeyboardOverlay(name: OptionsKeyboardOverlay.key)
        })
        
        model.addSendBarAction(SendBarActions.camera {
            let action = BSelectMediaAction(type: bPictureTypeCameraImage, viewController: vc)
            _ = action?.execute()?.thenOnMain({ success in
                if let imageMessage = BChatSDK.imageMessage(), let photo = action?.photo {
                    imageMessage.sendMessage(with: photo, withThreadEntityID: thread.entityID())
                }
                return success
            }, nil)
        })
        
    }
    
}
