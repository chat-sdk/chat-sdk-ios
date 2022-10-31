//
//  KeyboardSize.swift
//  ChatK!t
//
//  Created by Ben on 27/09/2022.
//

import Foundation

public class KeyboardInfoCache {
    
    var portrait: KeyboardInfo?
    var landscape: KeyboardInfo?
    
    var testHeightPortrait: CGFloat = 0
    var testHeightLandscape: CGFloat = 0

    var heightPortrait: CGFloat = 0
    var heightLandscape: CGFloat = 0
    
    open var isEnabled = true
    
    open var keyboardHeightUpdatedListener: ((KeyboardInfo?, CGFloat) -> Void)?
        
    init() {
        load()
    }
    
    public func setInfo(info: KeyboardInfo, isTest: Bool = false) {
        if isEnabled {
            let height = info.endFrame.height
            if height > 170 {
                print("Set Height", height)
                if isTest {
                    if UIView.isPortrait() && testHeightPortrait == 0 {
                        testHeightPortrait = height
                    }
                    if !UIView.isPortrait() && testHeightLandscape == 0 {
                        testHeightLandscape = height
                    }
                } else {
                    if UIView.isPortrait() {
                        portrait = info
                        if heightPortrait == 0 {
                            heightPortrait = height
                        }
                    } else {
                        landscape = info
                        if heightLandscape == 0 {
                            heightLandscape = height
                        }
                    }
                    save()
                }
                keyboardHeightUpdatedListener?(info, keyboardHeight())
            }
        }
    }
    
    public func save() {
        UserDefaults.standard.setValue(heightPortrait, forKey: "height-portrait")
        UserDefaults.standard.setValue(heightLandscape, forKey: "height-landscape")
    }
    
    public func load() {
        heightPortrait = CGFloat(UserDefaults.standard.float(forKey: "height-portrait"))
        heightLandscape = CGFloat(UserDefaults.standard.float(forKey: "height-landscape"))
    }
    
    public func measurementRequired() -> Bool {
        if UIView.isPortrait() {
            return portrait == nil
        } else {
            return landscape == nil
        }
    }
    
    public func keyboardHeight() -> CGFloat {
        if UIView.isPortrait() {
            if heightPortrait > 0 {
                return heightPortrait
            } else {
                return testHeightPortrait
            }
        } else {
            if heightLandscape > 0 {
                return heightLandscape
            } else {
                return testHeightLandscape
            }
        }
    }
    
    public func info() -> KeyboardInfo? {
        if UIView.isPortrait() {
            return portrait
        } else {
            return landscape
        }
    }
    
    public func relayout() {
        keyboardHeightUpdatedListener?(info(), keyboardHeight())
    }
    
}
