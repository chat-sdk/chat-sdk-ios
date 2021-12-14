//
//  ChatSDKUI.swift
//  AFNetworking
//
//  Created by ben3 on 13/07/2020.
//

import Foundation

@objc public class ChatSDKUI: NSObject {
    
    @objc public static let instance = ChatSDKUI()
    @objc public static func shared() -> ChatSDKUI {
        return instance
    }

    var userProfileSections = [ProfileSection]()

    public override init() {
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithDefaultBackground()
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
            UINavigationBar.appearance().compactAppearance = appearance
        }
    }
    
    @objc public func addUserProfileSection(section: ProfileSection) {
        userProfileSections.append( section)
    }
     
    @objc public func getProfileSections(user: PUser?) -> [ProfileSection] {
        var sections = [ProfileSection]()
        for section in userProfileSections {
            if section.showFor(user: user) && !section.getItems(user: user).isEmpty {
                sections.append(section)
            }
        }
        return sections;
    }
    
}
