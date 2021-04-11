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
    public var blurEnabled = true
    
    public var background: UIView?

    public override init(frame: CGRect) {
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
                
        textView = GrowingTextView()
        textView?.delegate = self
        textView?.font = UIFont.systemFont(ofSize: 15)
        textView?.backgroundColor = ChatKit.shared().assets.get(color: "gray_6")
        textView?.layer.cornerRadius = 15
        textView?.layer.borderColor = ChatKit.shared().assets.get(color: "gray_5")?.cgColor
        textView?.layer.borderWidth = 1
        textView?.isScrollEnabled = true
        textView?.maxHeight = 200
        
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

        background = makeBackground(blur: blurEnabled)
        insertSubview(background!, at: 0)
        background?.keepInsets.equal = 0
        background?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        background?.alpha = 0

        backgroundColor = .clear
        divider.backgroundColor = ChatKit.shared().assets.get(color: "gray_6")

    }
    
    public func makeBackground(blur: Bool = true) -> UIView {
        if blur {
            let background = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
            background.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            return background
        } else {
            let background = UIView()
            background.backgroundColor = ChatKit.shared().assets.get(color: "background")
            return background
        }
    }
    
    public func setBackgroundAlpha(alpha: CGFloat) {
        background?.alpha = alpha
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
        
    public func filterActions(actions: [TextInputAction], hasText: Bool) -> [TextInputAction] {
        var result = [TextInputAction]()
        
        for action in actions {
            if action.visibility == .always {
                result.append(action)
            }
            if action.visibility == .noText && !hasText {
                result.append(action)
            }
            if action.visibility == .text && hasText {
                result.append(action)
            }
            // If this is filtered out, hide it
            action.getButton().alpha = result.contains(action) ? 1 : 0
        }
        return result
    }
    
    public func layoutStartActions(hasText: Bool = false) {
        resetLayout(actions: startActions)

        let actions = filterActions(actions: startActions, hasText: hasText)
                
        actions.first?.getButton().keepLeftInset.equal = ChatKit.shared().textInputViewStartPadding
        actions.last?.getButton().keepRightOffsetTo(textView)?.equal = ChatKit.shared().textInputViewElementSpacing

        var previousAction = actions.first
        for action in actions {
            if !action.isEqual(previousAction) {
                action.button?.keepLeftOffsetTo(previousAction?.button)?.equal = ChatKit.shared().textInputViewElementSpacing
            }
            previousAction = action
        }
    }
    
    public func layoutEndActions(hasText: Bool = false) {
        resetLayout(actions: endActions)
        
        let actions = filterActions(actions: endActions, hasText: hasText)

        for action in endActions {
            if !actions.contains(action) {
                action.getButton().keepRightInset.equal = ChatKit.shared().textInputViewEndPadding
            }
        }
        
        actions.last?.getButton().keepRightInset.equal = ChatKit.shared().textInputViewEndPadding
        actions.first?.getButton().keepLeftOffsetTo(textView)?.equal = ChatKit.shared().textInputViewElementSpacing
        
        var previousAction = actions.first
        for action in actions {
            if !action.isEqual(previousAction) {
                action.button?.keepLeftOffsetTo(previousAction?.button)?.equal = ChatKit.shared().textInputViewElementSpacing
            }
            previousAction = action
        }
    }
    
    public func addButton(action: TextInputAction, toEnd: Bool = true) {
        sendAction = action
        if toEnd {
            addActionToEnd(action: action)
        } else {
            addActionToStart(action: action)
        }
    }
    
    public func addSendButton(onClick: @escaping (() -> Void), toEnd: Bool = true) {
        if let image = ChatKit.shared().assets.get(icon: "icn_30_send") {
            addButton(action: TextInputAction(image: image, action: onClick, visibility: .text), toEnd: toEnd)
        } else {
            addButton(action: TextInputAction(text: "Send", action: onClick, visibility: .text), toEnd: toEnd)
        }
    }

    public func addMicButton(onClick: @escaping (() -> Void), toEnd: Bool = true) {
        if let image = ChatKit.shared().assets.get(icon: "icn_30_mic") {
            addButton(action: TextInputAction(image: image, action: onClick, visibility: .noText), toEnd: toEnd)
        }
    }

    public func addCameraButton(onClick: @escaping (() -> Void), toEnd: Bool = true) {
        if let image = ChatKit.shared().assets.get(icon: "icn_30_camera") {
            addButton(action: TextInputAction(image: image, action: onClick, visibility: .noText), toEnd: toEnd)
        }
    }

    public func addPlusButton(onClick: @escaping (() -> Void), toEnd: Bool = false) {
        if let image = ChatKit.shared().assets.get(icon: "icn_30_plus") {
            addButton(action: TextInputAction(image: image, action: onClick, visibility: .always), toEnd: toEnd)
        } else {
            addButton(action: TextInputAction(text: "+", action: onClick, visibility: .always), toEnd: toEnd)
        }
    }
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text.isEmpty {
            layout(hasText: false)
        } else if let textRange = Range(range, in: text) {
            let newText = textView.text.replacingCharacters(in: textRange, with: text)
            if newText.isEmptyOrBlank() != textView.text.isEmptyOrBlank() {
                layout(hasText: true)
            }
        }
        return true
    }
    
    public func layout(hasText: Bool = false) {
        keepAnimated(withDuration: 0.2, delay: 0, options: .curveEaseInOut, layout: { [weak self] in
            self?.layoutStartActions(hasText: hasText)
            self?.layoutEndActions(hasText: hasText)
        }, completion: nil)
//        keepAnimated(withDuration: 0.2, options: ,layout: { [weak self] in
//        })
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        if hasText() {
            
        } else {
            
        }
    }

    
//    - (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
//        NSString * newText = [textView.text stringByReplacingCharactersInRange:range withString:text];
//        if (textView.heightToFitText >= 300 && newText.length > textView.text.length) {
//            return NO;
//        }
//        return YES;
//    }

    
    public func text() -> String? {
        return textView?.text
//        let text = textView?.text.replacingOccurrences(of: " ", with: "")
//        if text?.count ?? 0 > 0 {
//            return textView?.text
//        }
//        return nil
    }
    
    public func hasText() -> Bool {
        if let text = text(), text.hasText() {
            return true
        }
        return false
    }

}

extension String {
    public func isEmptyOrBlank() -> Bool {
        return replacingOccurrences(of: " ", with: "").isEmpty
    }
    public func hasText() -> Bool {
        return !isEmptyOrBlank()
    }
}
