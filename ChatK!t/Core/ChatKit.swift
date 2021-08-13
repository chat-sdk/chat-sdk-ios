//
//  ChatKit.swift
//  AFNetworking
//
//  Created by ben3 on 16/09/2020.
//

import Foundation

open class ChatKit {
    
    open var provider = Provider()
    
    public static let instance = ChatKit()
    
    public static func shared() -> ChatKit {
        return instance
    }
    
    open lazy var assets = {
        return ChatKit.provider().assets()
    }()

    open lazy var config = {
        return ChatKit.provider().config()
    }()
    
    open lazy var audioRecorder = {
        ChatKit.provider().audioRecorder()
    }()

    open lazy var messageHeightCache = {
        ChatKit.provider().messageHeightCache()
    }()

    open lazy var downloadManager = {
        ChatKit.provider().downloadManager()
    }()

    public static func config() -> Config {
        return shared().config
    }

    public static func assets() -> Assets {
        return shared().assets
    }

    public static func downloadManager() -> DownloadManager {
        return shared().downloadManager
    }

    public static func asset(color named: String) -> UIColor {
        return assets().get(color: named)
    }

    public static func asset(icon named: String) -> UIImage {
        return assets().get(icon: named)
    }

    public static func provider() -> Provider {
        return shared().provider
    }

    open func setProvider(_ provider: Provider) {
        self.provider = provider
    }

    public static func audioRecorder() -> AudioRecorder {
        return shared().audioRecorder
    }

    public static func messageHeightCache() -> MessageHeightCache {
        return shared().messageHeightCache
    }


}


