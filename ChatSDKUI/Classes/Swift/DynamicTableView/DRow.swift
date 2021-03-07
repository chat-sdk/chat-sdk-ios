//
//  Row.swift
//  ChatSDK-ChatUI
//
//  Created by ben3 on 09/01/2021.
//

import Foundation
import UIKit

@objc public class DRow: NSObject {
    
    let title: String
    let icon: String?
    let color: UIColor?
    var selectable = true
//    let executor: ((UIViewController, PUser) -> Void)

    public init(title: String, icon: String? = nil, color: UIColor?  = nil) {
        self.title = title
        self.icon = icon
        self.color = color
    }
    
    @objc public func getTitle() -> String {
        return title
    }

    @objc public func getIcon() -> String? {
        return icon
    }
    
    @objc public func isSelectable() -> Bool {
        return selectable ?? true
    }
    
    public func nibName() -> String? {
        return nil
    }
    
    public func cellType() -> AnyClass? {
        return nil
    }
    
    public func identifier() -> String {
        if let nib = nibName() {
            return nib
        }
        if let type = cellType() {
            return String(describing: type)
        }
        return "none"
    }
    
}

@objc public class DNavigationRow: DRow {
    
    let onClick: (() -> Void)
    
    public init(title: String, icon: String? = nil, onClick: @escaping (() -> Void)) {
        self.onClick = onClick
        super.init(title: title, icon: icon)
    }

    @objc public func click() {
        onClick()
    }
            
    override public func cellType() -> AnyClass? {
        return NavigationCell.self
    }

}

@objc public class DButtonRow: DRow {
    
    let onClick: (() -> Void)

    public init(title: String, color: UIColor? = nil, onClick: @escaping (() -> Void)) {
        self.onClick = onClick
        super.init(title: title, color: color)
    }
    
    @objc public func click() {
        onClick()
    }
    
    override public func nibName() -> String? {
        return "ButtonCell"
    }
        
}

@objc public class DSwitchRow: DRow {
    
    let onChange: ((Bool) -> Void)
    var selected: Bool?
    
    public init(title: String, selected: Bool? = false, onChange: @escaping ((Bool) -> Void)) {
        self.onChange = onChange
        super.init(title: title)
        self.selectable = false
        self.selected = selected
    }

    @objc public func onChange(value: Bool) {
        selected = value
        onChange(value)
    }
        
    override public func nibName() -> String? {
        return "BoolCell"
    }

    @objc public func isSelected() -> Bool {
        return selected ?? false
    }

}

@objc public class DRadioRow: DRow {
    
    let onClick: (() -> Void)
    var selected: Bool?
    weak var section: DRadioSection?

    public init(title: String, selected: Bool, onClick: @escaping (() -> Void)) {
        self.onClick = onClick
        self.selected = selected
        super.init(title: title, icon: nil)
    }
    
    @objc public func deselect() {
        selected = false
    }

    @objc public func isSelected() -> Bool {
        return selected ?? false
    }
    
    @objc public func click() {
        if !(selected ?? false) {
            section?.selected(row: self)
            selected = true
            onClick()
        }
    }
    
    @objc public func setSection(section: DRadioSection) {
        self.section = section
    }

    override public func cellType() -> AnyClass? {
        return RadioCell.self
    }


}
