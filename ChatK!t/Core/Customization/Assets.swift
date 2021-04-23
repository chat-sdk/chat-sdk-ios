//
//  Icons.swift
//  ChatK!t
//
//  Created by ben3 on 08/04/2021.
//

import Foundation


public class Assets {

    public var colors = [String: UIColor]()
    public var icons = [String: UIImage]()

    public lazy var bundle = {
        return Bundle(for: Assets.self)
    }()

    public func get(icon named: String) -> UIImage {
        let image = icons[named] ?? UIImage(named: named, in: bundle, compatibleWith: nil)
        icons[named] = image
        return image!
    }

    public func get(color named: String) -> UIColor {
        let color = colors[named] ?? UIColor(named: named, in: bundle, compatibleWith: nil)
        colors[named] = color
        return color!
    }

    public func set(name: String, image: UIImage) {
        icons[name] = image
    }

}


