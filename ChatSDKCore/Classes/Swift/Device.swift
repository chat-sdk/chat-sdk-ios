//
//  Device.swift
//  ChatSDK
//
//  Created by ben3 on 17/12/2020.
//

import Foundation

@objc public class Device: NSObject {
    
    @objc public static func iPhoneX() -> Bool {
        return UIDevice.current.name == "BanBan’s iPhone X "
    }

    @objc public static func notIPhoneX() -> Bool {
        return !iPhoneX()
    }

}
