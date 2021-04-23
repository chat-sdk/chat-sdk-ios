//
//  UIViewExtension.swift
//  ChatK!t
//
//  Created by ben3 on 16/04/2021.
//

import Foundation
import UIKit

extension UIView {
    class func fromNib<T: UIView>() -> T {
        return Bundle(for: T.self).loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
    class func fromNib<T: UIView>(nibName: String) -> T {
        return Bundle(for: T.self).loadNibNamed(nibName, owner: nil, options: nil)![0] as! T
    }
}
