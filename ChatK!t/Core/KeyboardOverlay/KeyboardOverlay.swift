//
//  PKeyboardOverlay.swift
//  ChatK!t
//
//  Created by ben3 on 18/04/2021.
//

import Foundation

public protocol KeyboardOverlay: UIView {
    func viewWillLayoutSubviews(view: UIView)
}

public extension KeyboardOverlay {
    func viewWillLayoutSubviews(view: UIView) {
        keepBottomInset.equal = 0
    }
}
