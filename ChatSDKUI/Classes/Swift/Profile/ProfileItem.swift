//
//  ProfileItem.swift
//  AFNetworking
//
//  Created by ben3 on 13/07/2020.
//

import Foundation
import UIKit

@objc public class ProfileItem: NSObject {
    
    let name: String
    let icon: String?
    let executor: ((UIViewController, PUser) -> Void)
    let showFor: ((PUser?) -> Bool)?

//    public convenience init(name: String, icon: String?, executor: @escaping ((UIViewController) -> Void)) {
//        self.init(name: name, icon: icon, executor: executor)
//    }

    public init(name: String, icon: String?, showFor: ((PUser?) -> Bool)?, executor: @escaping ((UIViewController, PUser) -> Void)) {
        self.name = name
        self.icon = icon
        self.showFor = showFor
        self.executor = executor
    }
    
    @objc public func getName() -> String {
        return name
    }

    @objc public func getIcon() -> String? {
        return icon
    }
    
    @objc public func execute(viewController: UIViewController, user: PUser) -> Void {
        executor(viewController, user)
    }

    @objc public func showFor(user: PUser?) -> Bool {
        if let showFor = self.showFor {
            return showFor(user)
        }
        return true
    }

}
