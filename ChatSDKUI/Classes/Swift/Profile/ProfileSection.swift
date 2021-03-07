//
//  ProfileSection.swift
//  AFNetworking
//
//  Created by ben3 on 13/07/2020.
//

import Foundation
import UIKit

@objc public class ProfileSection: NSObject {
    
    let name: String
    var items = [ProfileItem]()
    let showFor: ((PUser?) -> Bool)?
    
    public init(name: String, showFor: ((PUser?) -> Bool)?) {
        self.name = name
        self.showFor = showFor
    }
    
    @objc public func addItem(item: ProfileItem) {
        items.append(item)
    }
    
    @objc public func showFor(user: PUser?) -> Bool {
        if let showFor = self.showFor {
            return showFor(user)
        }
        return true
    }
    
    @objc public func getItems(user: PUser?) -> [ProfileItem] {
        var items = [ProfileItem]()
        for item in self.items {
            if item.showFor(user: user) {
                items.append(item)
            }
        }
        return items
    }
    
    @objc public func getName() -> String {
        return name
    }
 
}
