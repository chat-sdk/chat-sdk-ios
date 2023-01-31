//
//  KeyboardUtils.swift

//
//  Created by ben3 on 11/04/2021.
//

import Foundation
import UIKit

open class KeyboardInfo {
    
    public let endFrame: CGRect
    public let startFrame: CGRect
    public let duration: Double
    public let curve: UIView.AnimationOptions
    
    init(start: CGRect, end: CGRect, duration: Double, curve: UIView.AnimationOptions) {
        self.endFrame = end
        self.startFrame = start
        self.duration = duration
        self.curve = curve
    }
    
    public static func from(_ info: [AnyHashable: Any]?) -> KeyboardInfo? {
        if let info = info,
           let endFrame = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
           let startFrame = info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue,
           let duration = info[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber,
           let curve = info[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber {
            return KeyboardInfo(start: startFrame.cgRectValue, end: endFrame.cgRectValue, duration: duration.doubleValue, curve: UIView.AnimationOptions(rawValue: curve.uintValue))
        }
        return nil
    }
    
    open func height(view: UIView? = nil) -> CGFloat {
        var keyboardHeight = UIScreen.main.bounds.height - endFrame.origin.y

        print("Start: ", startFrame)
        print("End: ", endFrame)
        print("Height: ", keyboardHeight)
        print("Height: ", modHeight())

        if #available(iOS 11, *) {
            if keyboardHeight > 0, let view = view {
                keyboardHeight = keyboardHeight - view.safeAreaInsets.bottom
            }
        }
        return keyboardHeight
    }
    
    open func modHeight() -> CGFloat {
        return max(endFrame.size.height, startFrame.size.height)
    }

    open func isAppearing() -> Bool {
        return endFrame.size.height > startFrame.size.height
    }

}

open class KeyboardListener {
    
    open var willShow: ((KeyboardInfo) -> Void)?
    open var didShow: ((KeyboardInfo) -> Void)?
    open var willHide: ((KeyboardInfo) -> Void)?
    open var didHide: ((KeyboardInfo) -> Void)?
    open var willChangeFrame: ((KeyboardInfo) -> Void)?

    public init() {
        
    }
    
    open func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide(_:)), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    open func removeObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    @objc open func keyboardWillChangeFrame(_ notification: Notification) {
        if let callback = willChangeFrame, let data = KeyboardInfo.from(notification.userInfo) {
            callback(data)
        }
    }
    
    @objc open func keyboardWillShow(_ notification: Notification) {
        if let info = KeyboardInfo.from(notification.userInfo) {
            willShow?(info)
        }
    }

    @objc open func keyboardDidShow(_ notification: Notification) {
        if let info = KeyboardInfo.from(notification.userInfo) {
            didShow?(info)
        }
    }

    @objc open func keyboardWillHide(_ notification: Notification) {
        if let info = KeyboardInfo.from(notification.userInfo) {
            willHide?(info)
        }
    }

    @objc open func keyboardDidHide(_ notification: Notification) {
        if let info = KeyboardInfo.from(notification.userInfo) {
            didHide?(info)
        }
    }

}
