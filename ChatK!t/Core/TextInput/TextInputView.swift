//
//  TextInputView.swift
//  AFNetworking
//
//  Created by ben3 on 14/09/2020.
//

import Foundation
import GrowingTextView
import KeepLayout

public class TextInputView: UIView, UITextViewDelegate {
    
    public var textView: GrowingTextView?
    public let divider = UIView()

    public let startButtonsView = UIView()
    public var startActions = [TextInputAction]()

    public let endButtonsView = UIView()
    public var endActions = [TextInputAction]()
    
    public var sendAction: TextInputAction?
    public var audioEnabled = false
    public var micButtonEnabled = false

    @objc public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    public convenience required init?(coder: NSCoder) {
        self.init()
    }

    public func setup() {
        
        if #available(iOS 13, *) {
            backgroundColor = .systemBackground
            divider.backgroundColor = .systemGray6
        } else {
            backgroundColor = .white
            divider.backgroundColor = .lightGray
        }
        
        textView = GrowingTextView()
        textView?.delegate = self
        textView?.font = UIFont.systemFont(ofSize: 15)
        
        addSubview(divider)
        addSubview(startButtonsView)
        addSubview(textView!)
        addSubview(endButtonsView)
        
        divider.keepTopInset.equal = 0
        divider.keepLeftInset.equal = 0
        divider.keepRightInset.equal = 0
        divider.keepHeight.equal = 1

        startButtonsView.keepTopInset.equal = ChatKit.shared().textInputViewTopPadding
        startButtonsView.keepLeftInset.equal = ChatKit.shared().textInputViewStartPadding
        startButtonsView.keepBottomInset.equal = ChatKit.shared().textInputViewBottomPadding
        startButtonsView.keepRightOffsetTo(textView!)?.equal = ChatKit.shared().textInputViewElementSpacing
        startButtonsView.keepWidth.equal = KeepLow(0)

        endButtonsView.keepTopInset.equal = ChatKit.shared().textInputViewTopPadding
        endButtonsView.keepRightInset.equal = ChatKit.shared().textInputViewEndPadding
        endButtonsView.keepBottomInset.equal = ChatKit.shared().textInputViewBottomPadding
        endButtonsView.keepLeftOffsetTo(textView!)?.equal = ChatKit.shared().textInputViewElementSpacing
        endButtonsView.keepWidth.equal = KeepLow(0)

        textView?.keepTopInset.equal = ChatKit.shared().textInputViewTopPadding
        textView?.keepBottomInset.equal = ChatKit.shared().textInputViewBottomPadding
                                
    }
    
    public func addActionToStart(action: TextInputAction) {
        startActions.append(action)
        layoutStartActions()
    }

    public func addActionToEnd(action: TextInputAction) {
        endActions.append(action)
        layoutEndActions()
    }
    
    public func removeActionFromStart(at: Int) {
        clearLayout(actions: startActions)
        startActions.remove(at: at)
        layoutStartActions()
    }

    public func removeActionFromEnd(at: Int) {
        clearLayout(actions: endActions)
        endActions.remove(at: at)
        layoutEndActions()
    }

    public func clearLayout(actions: [TextInputAction]) {
        for action in actions {
            let button = action.getButton()
            button.removeFromSuperview()
        }
    }
    
    public func resetLayout(actions: [TextInputAction]) {
        for action in actions {
            let button = action.getButton()

            button.removeFromSuperview()
            addSubview(button)
            
            button.keepTopInset.min = ChatKit.shared().textInputViewTopPadding
            button.keepBottomInset.min = ChatKit.shared().textInputViewBottomPadding
            button.keepVerticallyCentered()
        }
    }
    
    public func layoutStartActions() {
        resetLayout(actions: startActions)
        
        startActions.first?.getButton().keepLeftInset.equal = ChatKit.shared().textInputViewStartPadding
        startActions.last?.getButton().keepRightOffsetTo(textView)?.equal = ChatKit.shared().textInputViewElementSpacing

        var previousAction = startActions.first
        for action in startActions {
            if !action.isEqual(previousAction) {
                action.button?.keepLeftOffsetTo(previousAction?.button)?.equal = ChatKit.shared().textInputViewElementSpacing
            }
            previousAction = action
        }
    }
    
    public func layoutEndActions() {
        resetLayout(actions: endActions)
        
        endActions.last?.getButton().keepRightInset.equal = ChatKit.shared().textInputViewEndPadding
        endActions.first?.getButton().keepLeftOffsetTo(textView)?.equal = ChatKit.shared().textInputViewElementSpacing

        var previousAction = endActions.first
        for action in endActions {
            if !action.isEqual(previousAction) {
                action.button?.keepLeftOffsetTo(previousAction?.button)?.equal = ChatKit.shared().textInputViewElementSpacing
            }
            previousAction = action
        }
    }
    
    public func addSendButton(action: TextInputAction, toEnd: Bool = true) {
        sendAction = action
        if toEnd {
            addActionToEnd(action: action)
        } else {
            addActionToStart(action: action)
        }
    }
    
    public func addSendButton(onClick: @escaping (() -> Void), toEnd: Bool = true) {
        addSendButton(action: TextInputAction(text: "Send", action: onClick), toEnd: toEnd)
    }

    public func addPlusButton(onClick: @escaping (() -> Void)) {
        addActionToStart(action: TextInputAction(text: "+", action: onClick))
    }
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return true
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        if text()?.count ?? 0 > 0 || !audioEnabled {
            
        } else {
            
        }
    }
    
    public func setMicButtonEnabled(enabled: Bool, sendButtonEnabled: Bool) {
        micButtonEnabled = enabled
        if let button = sendAction?.button {
            button.isEnabled = sendButtonEnabled || enabled
            if enabled {
                button.setTitle(nil, for: .normal)
                // TODO: 
//                button.setImage(<#T##image: UIImage?##UIImage?#>, for: <#T##UIControl.State#>)
            } else {
//                button
            }
        }
    }
    
    public func text() -> String? {
        let text = textView?.text.replacingOccurrences(of: " ", with: "")
        if text?.count ?? 0 > 0 {
            return textView?.text
        }
        return nil
    }

}
