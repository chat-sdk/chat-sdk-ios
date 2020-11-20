//
//  ChatKit.swift
//  AFNetworking
//
//  Created by ben3 on 16/09/2020.
//

import Foundation

public class ChatKit {
    
    public static let instance = ChatKit()
    
    public static func shared() -> ChatKit {
        return instance
    }
    
    // TextInputView layout parameters
    public var textInputViewTopPadding = 5
    public var textInputViewBottomPadding = 5
    public var textInputViewStartPadding = 8
    public var textInputViewEndPadding = 8
    public var textInputViewElementSpacing = 5
    
}
