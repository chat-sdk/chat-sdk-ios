//
//  KeyboardOverlayTextView.swift
//  ChatK!t
//
//  Created by Ben on 27/09/2022.
//

import Foundation

public class KeyboardOverlayTextView: UITextView {
    
    var overlayView: KeyboardOverlayView
    
    init(overlayView: KeyboardOverlayView) {
        self.overlayView = overlayView

        super.init(frame: .zero, textContainer: nil)
        
        autocorrectionType = .no
        inputAssistantItem.leadingBarButtonGroups = []
        inputAssistantItem.trailingBarButtonGroups = []
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public var inputView: UIView? {
        get { overlayView }
        set {}
    }
    
    public override var canBecomeFirstResponder: Bool {
        return true
    }
}
