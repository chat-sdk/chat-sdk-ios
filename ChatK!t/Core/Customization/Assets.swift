//
//  Icons.swift
//  ChatK!t
//
//  Created by ben3 on 08/04/2021.
//

import Foundation


open class Assets {

    open var colors = [String: UIColor]()
    open var icons = [String: UIImage]()
    
    public init() {
        
    }

    open lazy var bundle = {
        return Bundle(for: Assets.self)
    }()

    open func get(icon named: String) -> UIImage {
        let image = icons[named] ?? UIImage(named: named, in: bundle, compatibleWith: nil) ?? UIImage(named: named, in: Bundle.main, compatibleWith: nil)
        icons[named] = image
        return image!
    }

    open func get(color named: String) -> UIColor {
        let color = colors[named] ?? UIColor(named: named, in: bundle, compatibleWith: nil) ?? UIColor(named: named, in: Bundle.main, compatibleWith: nil)
        colors[named] = color
        return color!
    }

    open func set(name: String, image: UIImage) {
        icons[name] = image
    }

    open func set(name: String, color: UIColor) {
        colors[name] = color
    }

}


