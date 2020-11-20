//
//  SettingsItem.swift
//  AFNetworking
//
//  Created by ben3 on 13/11/2020.
//

import Foundation
import ChatSDK

public enum SettingsItemType {
    case bool
    case button
    case cell
    case radio
}

public class SettingsItem {
    
    public let id: String?
    public let title: String
    public let subtitle: String?
    public let icon: String?
    
    public init(id: String?, title: String, subtitle: String? = nil, icon: String? = nil) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
    }
    
    public func notify(value: Any) {
        if let id = id {
            BHookNotification.notificationSettingsUpdated(id, newValue: value)
        }
    }
}

public class BoolSettingsItem: SettingsItem {
    
    public var defaultValue: (() -> Bool)?
    
    public init(id: String?, title: String, subtitle: String? = nil, icon: String? = nil, defaultValue: (() -> Bool)? = nil) {
        super.init(id: id, title: title, subtitle: subtitle, icon: icon)
        self.defaultValue = defaultValue
    }
    
    public func setValue(value: Bool) {
        notify(value: value)
    }
    
    public func getValue() -> Bool {
        if let defaultValue = self.defaultValue {
            return defaultValue()
        } else if let id = self.id {
            return BChatSDK.shared()?.settings.getBoolValue(key: id) ?? false
        }
        return false
    }
    
}


@objc public class ButtonSettingsItem: NSObject {
    
}

@objc public class CellSettingsItem: NSObject {
    
}

@objc public class RadioSettingsItem: NSObject {
    
}


