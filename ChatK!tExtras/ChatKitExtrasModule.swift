//
//  ChatKitExtrasModule.swift
//  ChatK!tModule
//
//  Created by ben3 on 23/07/2021.
//

import Foundation
import ChatSDK
import ChatKit

@objc public class ChatKitExtrasModule: NSObject, PModule {

    public func weight() -> Int32 {
        return 100
    }
    
    public func activate() {

        if BChatSDK.stickerMessage() != nil {
            ChatKitModule.shared().get().add(onCreateListener: StickerMessageOnCreateListener())
            
            ChatKitModule.shared().get().add(newMessageProvider: StickerMessageProvider(), type: Int(bMessageTypeSticker.rawValue))
            ChatKitModule.shared().get().add(optionProvider: StickerOptionProvider())

            let stickerRegistration = MessageCellRegistration(messageType: String(bMessageTypeSticker.rawValue), contentClass: StickerMessageContent.self)
            ChatKitModule.shared().get().add(messageRegistration: stickerRegistration)
        }
    }
    
}

//public class FileMessageOnClick: NSObject, MessageOnClickListener, UIDocumentInteractionControllerDelegate {
//
//    var documentInteractionProvider : UIDocumentInteractionController?
//    weak var vc: UIViewController?
//
//    public func onClick(for vc: ChatViewController?, message: AbstractMessage) {
//        if let vc = vc, let message = message as? CKFileMessage, let url = message.localFileURL {
//
//            var fileURL = url;
//            if !url.isFileURL {
//                fileURL = URL(fileURLWithPath: url.path)
//            }
//
//            self.vc = vc
//            documentInteractionProvider = UIDocumentInteractionController(url: fileURL)
//            documentInteractionProvider?.name = message.messageText()
//            documentInteractionProvider?.delegate = self
//            documentInteractionProvider?.presentPreview(animated: true)
//        }
//    }
//
//    public func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
//        return self.vc!
//    }
//
//    public func documentInteractionControllerViewForPreview(_ controller: UIDocumentInteractionController) -> UIView? {
//        return self.vc!.view
//    }
//
//    public func documentInteractionControllerRectForPreview(_ controller: UIDocumentInteractionController) -> CGRect {
//        return self.vc!.view.frame
//    }
//}
//
//public class FileMessageProvider: MessageProvider {
//    public func new(for message: PMessage) -> CKMessage {
//        return CKFileMessage(message: message)
//    }
//}
//
//public class FileOptionProvider: OptionProvider {
//
//    var action: BSelectFileAction?
//
//    public func provide(for vc: ChatViewController, thread: PThread) -> Option {
//        return Option(fileOnClick: { [weak self] in
//            self?.action = BSelectFileAction.init(viewController: vc)
//            _ = self?.action?.execute().thenOnMain({ success in
//
//                if let fileMessage = BChatSDK.fileMessage(), let action = self?.action, let name = action.name, let url = action.url, let mimeType = action.mimeType, let data = action.data {
//                    let file: [AnyHashable: Any] = [
//                        bFileName: name,
//                        bFilePath: url,
//                        FileKeys.mimeType: mimeType,
//                        FileKeys.data: data
//                    ]
//                    return fileMessage.sendMessage(withFile: file, andThreadEntityID: thread.entityID())
//                }
//
//                return success
//            }, nil)
//        })
//    }
//}


public class StickerMessageOnCreateListener: OnCreateListener {
    public func onCreate(for vc: ChatViewController, model: ChatModel, thread: PThread) {
        
        let stickerOverlay = StickerKeyboardOverlay()
        model.addKeyboardOverlay(name: StickerKeyboardOverlay.key, overlay: stickerOverlay)
        stickerOverlay.stickerView?.sendSticker = { name in
            BChatSDK.stickerMessage()?.sendMessage(withSticker: name, withThreadEntityID: thread.entityID())
        }
        model.addKeyboardOverlay(name: StickerKeyboardOverlay.key, overlay: stickerOverlay)
        
    }
}

public class StickerMessageProvider: MessageProvider {
    public func new(for message: PMessage) -> CKMessage {
        return CKStickerMessage(message: message)
    }
}

public class StickerOptionProvider: OptionProvider {
    public func provide(for vc: ChatViewController, thread: PThread) -> Option {
        return Option(stickerOnClick: {
            vc.showKeyboardOverlay(name: StickerKeyboardOverlay.key)
        })
    }
}

