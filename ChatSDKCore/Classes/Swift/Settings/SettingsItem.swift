//
//  SettingsItem.swift
//  AFNetworking
//
//  Created by ben3 on 13/11/2020.
//

import Foundation

public enum SettingsItemType {
    case bool
    case button
    case cell
    case radio
}

public class SettingsItem {
    
    public let id: String?
    public let title: String?
    public let subtitle: String?
    public let icon: String?
    
    public init(id: String?, title: String?, subtitle: String? = nil, icon: String? = nil) {
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
        self.defaultValue = defaultValue
        super.init(id: id, title: title, subtitle: subtitle, icon: icon)
    }
    
    public func setValue(value: Bool) {
        notify(value: value)
    }
    
    public func getValue() -> Bool {
        if let defaultValue = self.defaultValue {
            return defaultValue()
        } else if let id = self.id {
            return BChatSDK.shared().settings.getBoolValue(key: id) ?? false
        }
        return false
    }
    
}


public class ButtonSettingsItem: SettingsItem {
    
}

public class CellSettingsItem: SettingsItem {
    
}

public class RadioSettingsItem: SettingsItem {
    
    let options: [String: String]
    let keys: [String]
    
    public var defaultValue: (() -> String)?
    public var onSelect: ((String) -> Void)?

    public init(id: String?, keys: [String], titles: [String], defaultValue: (() -> String)? = nil, onSelect: ((String) -> Void)? = nil) {
        var options = [String: String]()

        assert(keys.count == titles.count)

        for i in 0...keys.count-1 {
            options[keys[i]] = titles[i]
        }
        self.options = options
        self.keys = keys
        
        self.defaultValue = defaultValue
        self.onSelect = onSelect
        super.init(id: id, title: nil)
    }
    
    public func setValue(value: String) {
        notify(value: value)
        if let onSelect = onSelect {
            onSelect(value)
        }
    }
    
    public func getValue() -> String {
        if let defaultValue = self.defaultValue {
            return defaultValue()
        } else if let id = self.id {
            return BChatSDK.shared().settings.getValue(key: id) ?? ""
        }
        return ""
    }

    
}


