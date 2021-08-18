//
//  SendSendBarAction.swift
//  ChatK!t
//
//  Created by ben3 on 18/04/2021.
//

import Foundation

open class SendBarActions {
    
    public static func camera(onClick: @escaping (() -> Void)) -> SendBarAction {
        return SendBarAction(image: ChatKit.asset(icon: "icn_30_camera"), action: onClick, visibility: .noText, position: .end)
    }

    public static func cameraFilled(onClick: @escaping (() -> Void)) -> SendBarAction {
        return SendBarAction(image: ChatKit.asset(icon: "icn_30_camera_fill"), action: onClick, visibility: .noText, position: .end)
    }

    public static func plus(onClick: @escaping (() -> Void)) -> SendBarAction {
        return SendBarAction(image: ChatKit.asset(icon: "icn_30_plus"), action: onClick, visibility: .always, position: .start)
    }

    public static func mic(onClick: @escaping (() -> Void)) -> SendBarAction {
        return SendBarAction(image: ChatKit.asset(icon: "icn_30_mic"), action: onClick, visibility: .noText, position: .end)
    }

    public static func send(onClick: @escaping (() -> Void)) -> SendBarAction {
        return SendBarAction(image: ChatKit.asset(icon: "icn_30_send"), action: onClick, visibility: .text, position: .end)
    }

    public static func gallery(onClick: @escaping (() -> Void)) -> SendBarAction {
        return SendBarAction(image: ChatKit.asset(icon: "icn_30_gallery"), action: onClick, visibility: .noText, position: .end)
    }

}
