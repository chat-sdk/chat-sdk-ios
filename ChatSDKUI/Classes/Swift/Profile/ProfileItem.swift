//
//  ProfileItem.swift
//  AFNetworking
//
//  Created by ben3 on 13/07/2020.
//

import Foundation
import ChatSDK
import UIKit

@objc public class ProfileItem: NSObject {
    
    let name: String
    let icon: String?
    let executor: ((UIViewController) -> Void)
    
//    public convenience init(name: String, icon: String?, executor: @escaping ((UIViewController) -> Void)) {
//        self.init(name: name, icon: icon, executor: executor)
//    }

    public init(name: String, icon: String?, executor: @escaping ((UIViewController) -> Void)) {
        self.name = name
        self.icon = icon
        self.executor = executor
    }
    
    @objc public func getName() -> String {
        return name
    }

    @objc public func getIcon() -> String? {
        return icon
    }
    
    @objc public func execute(viewController: UIViewController) -> Void {
        executor(viewController)
    }

}
