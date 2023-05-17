//
//  FileMessageModule.swift
//  ChatSDKModules-ChatFileMessage
//
//  Created by ben3 on 11/01/2021.
//

import Foundation
import ChatSDK
import Licensing

@objc public class FileMessageModule: NSObject, PModule {
    public func activate() {
        Licensing.shared().add(item: String(describing: type(of: self)))
        BChatSDK.shared().networkAdapter.setFileMessage(BFileMessageHandler.init())
        BChatSDK.ui().add(BFileChatOption.init())
        BChatSDK.ui().registerMessage(withCellClass: BChatSDK.fileMessage()?.cellClass(), messageType: NSNumber(value: bMessageTypeFile.rawValue))
    }
    
    @objc public static func bundle() -> Bundle? {
        let bundle = Bundle(for: FileMessageModule.self)
        guard let resourceBundleURL = bundle.url(forResource: bFileMessageBundle, withExtension: "bundle") else { return nil }
        guard let resourceBundle = Bundle(url: resourceBundleURL) else { return nil }
        return resourceBundle
    }
 
    @objc public static func image(named: String) -> UIImage? {
        return UIImage(named: named, in: bundle(), compatibleWith: nil)
    }

}
