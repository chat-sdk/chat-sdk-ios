//
//  ChatKit.swift
//  AFNetworking
//
//  Created by ben3 on 16/09/2020.
//

import Foundation

public class ChatKit {
    
    public var provider = Provider()
    
    public static let instance = ChatKit()
    
    
    public static func shared() -> ChatKit {
        return instance
    }
    
    public var _assets = Assets()
    public var _config = Config()
    
    public static func config() -> Config {
        return shared()._config
    }

    public static func assets() -> Assets {
        return shared()._assets
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
    
}


