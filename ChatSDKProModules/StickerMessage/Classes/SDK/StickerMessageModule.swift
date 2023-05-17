//
//  StickerMessageModule.swift
//  ChatSDKModules
//
//  Created by ben3 on 11/01/2021.
//

import Foundation
import ChatSDK
import FLAnimatedImage
import Licensing
import ChatKit
import MessageModules

@objc open class StickerMessageModule: NSObject, PModule {

    static let instance = StickerMessageModule()
    @objc public static func shared() -> StickerMessageModule {
        return instance
    }
    
    @objc public var loadStickersFromPlist = true
    @objc public var plist = "default-stickers"
    @objc public var plistBundle: Bundle?
    
    @objc public var manager = StickerManager()

    @objc public var imageProvider: ((String) -> UIImage?)?
    @objc public var animatedImageProvider: ((String) -> FLAnimatedImage?)?
    
    public var stickerPackProvider: StickerPackProvider?
    
    private override init() {
        super.init()
    }
    
    public func weight() -> Int32 {
        return 100
    }

    @objc public func activate() {

        Licensing.shared().add(item: String(describing: type(of: self)))
        
        if self.plistBundle == nil {
            let bundle = Bundle(for: StickerManager.self)
            if let resourceBundleURL = bundle.url(forResource: bStickerMessageBundle, withExtension: "bundle") {
                if let resourceBundle = Bundle(url: resourceBundleURL) {
                    self.plistBundle = resourceBundle
                }
            }
        }
        
        BChatSDK.shared().networkAdapter.setStickerMessage(BStickerMessageHandler.init())
        BChatSDK.ui().add(BStickerChatOption.init())
        BChatSDK.ui().registerMessage(withCellClass: BChatSDK.stickerMessage()!.cellClass(), messageType: NSNumber(value: bMessageTypeSticker.rawValue))

        if loadStickersFromPlist {
            if let bundle = plistBundle {
//                StickerManager.shared().loadDefaultStickers(name: plist, bundle: bundle)
                stickerPackProvider = PListStickerPackProvider(plist: plist, bundle: bundle)
            }
        }
        
        ChatKitModule.shared().get().add(onCreateListener: StickerMessageOnCreateListener())
        
        ChatKitModule.shared().get().add(newMessageProvider: StickerMessageProvider(), type: Int(bMessageTypeSticker.rawValue))
        ChatKitModule.shared().get().add(optionProvider: StickerOptionProvider())

        let stickerRegistration = MessageCellRegistration(messageType: String(bMessageTypeSticker.rawValue), contentClass: StickerMessageContent.self)
        ChatKitModule.shared().get().add(messageRegistration: stickerRegistration)
    }
    
//    @objc public func addPack(_ pack: StickerPack) {
//        StickerManager.shared().addPack(pack)
//    }
    
//    @objc public func bundle() -> Bundle? {
//        let bundle = Bundle(for: StickerManager.self)
//        guard let resourceBundleURL = bundle.url(forResource: bStickerMessageBundle, withExtension: "bundle") else { return nil }
//        guard let resourceBundle = Bundle(url: resourceBundleURL) else { return nil }
//        return resourceBundle
//    }
    
    @objc open func image(_ name: String) -> UIImage? {
        // First try the image provider if it's set
        if let provider = imageProvider {
            if let image = provider(name) {
                return image
            }
        }
        // Otherwise try with the default bundle
        return UIImage(named: name, in: plistBundle, compatibleWith: nil)
    }

    @objc open func animatedImage(_ name: String) -> FLAnimatedImage? {
        // First try the image provider if it's set
        if let provider = animatedImageProvider {
            if let image = provider(name) {
                return image
            }
        }
        // Otherwise try with the default bundle
        if let path = plistBundle?.path(forResource: name, ofType: nil) {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                return FLAnimatedImage(animatedGIFData: data)
            } catch {
                return nil
            }
        }
        return nil
    }

    @objc public func setImageProvider(with imageProvider: @escaping ((String) -> UIImage?)) {
        self.imageProvider = imageProvider
    }

    @objc public func setAnimatedImageProvider(with animatedImageProvider: @escaping ((String) -> FLAnimatedImage?)) {
        self.animatedImageProvider = animatedImageProvider
    }
    
    @objc public func setCustomStickers(plist name: String, bundle: Bundle) {
        self.plist = name.replacingOccurrences(of: ".plist", with: "")
        self.plistBundle = bundle
    }
    
    @objc public func stickerManager() -> StickerManager {
        return manager;
    }
    
    public func setStickerPackProvider(provder: StickerPackProvider) {
        stickerPackProvider = provder
    }

}

public class StickerMessageOnCreateListener: OnCreateListener {
    public func onCreate(for vc: ChatViewController, model: ChatModel, thread: PThread) {
        
        let stickerOverlay = StickerKeyboardOverlay()
        model.addKeyboardOverlay(name: StickerKeyboardOverlay.key, overlay: stickerOverlay)
        stickerOverlay.stickerView?.sendSticker = { name, url in
            BChatSDK.stickerMessage()?.sendMessage(withSticker: name, url: url, threadEntityID: thread.entityID())
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
    
    open weak var vc: ChatViewController?
    
    public func provide(for vc: ChatViewController, thread: PThread) -> Option {
        self.vc = vc
        return Option(stickerOnClick: { [weak self] in
            self?.vc?.showKeyboardOverlay(name: StickerKeyboardOverlay.key)
        })
    }
}
