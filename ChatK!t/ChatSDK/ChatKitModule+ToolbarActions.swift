//
//  ChatKitModule+ToolbarActions.swift
//  ChatK!t
//
//  Created by ben3 on 21/06/2021.
//

import Foundation
import ChatSDK

public extension ChatKitModule {
    
    func addToolbarActions(model: ChatModel, vc: ChatViewController, thread: PThread) {

        model.addToolbarAction(ToolbarAction.copyAction(onClick: { messages in
            
            let formatter = DateFormatter()
            formatter.dateFormat = ChatKit.config().messageHistoryTimeFormat
            
            var text = ""
            for message in messages {
                text += String(format: "%@ - %@ %@\n", formatter.string(from: message.messageDate()), message.messageSender().userName(), message.messageText() ?? "")
            }
            
            UIPasteboard.general.string = text
            vc.view.makeToast(Strings.t(Strings.copiedToClipboard))

            return true
        }))

        model.addToolbarAction(ToolbarAction.trashAction(visibleFor: { messages in
            var visible = true
            for message in messages {
                if let m = CKMessageStore.shared().message(with: message.messageId()) {
                    visible = visible && BChatSDK.thread().canDelete(m.message)
                }
            }
            return visible
        }, onClick: { messages in
            for message in messages {
                _ = BChatSDK.thread().deleteMessage(message.messageId()).thenOnMain({ success in
                    _ = model.messagesModel.removeMessages([message]).subscribe()
                    return success
                }, nil)
            }
            return false
        }))

        model.addToolbarAction(ToolbarAction.forwardAction(visibleFor: { messages in
            return messages.count == 1
        }, onClick: { messages in
            return true
        }))

        model.addToolbarAction(ToolbarAction.replyAction(visibleFor: { messages in
            return messages.count == 1
        }, onClick: { messages in
            if let message = messages.first {
                vc.showReplyView(message)
            }
            return true
        }))
        
    }

}
