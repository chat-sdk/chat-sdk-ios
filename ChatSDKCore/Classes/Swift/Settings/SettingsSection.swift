//
//  SettingsSection.swift
//  ChatSDK
//
//  Created by ben3 on 13/11/2020.
//

import Foundation

public class SettingsSection {

    public var items = [SettingsItem]()
    public let title: String

    public init (title: String) {
        self.title = title
    }
}
