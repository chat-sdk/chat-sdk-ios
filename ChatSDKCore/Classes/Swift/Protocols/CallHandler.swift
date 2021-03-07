//
//  CallHandler.swift
//  ChatSDK
//
//  Created by ben3 on 13/02/2021.
//

import Foundation

@objc public protocol CallHandler {
    @objc func call(user entityID: String, viewController: UIViewController)
}
