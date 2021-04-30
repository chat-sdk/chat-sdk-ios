//
//  Provider.swift
//  AFNetworking
//
//  Created by ben3 on 24/04/2021.
//

import Foundation

public class Provider {
    
    public func sectionNib() -> UINib {
        return UINib(nibName: "SectionCell", bundle: Bundle(for: SectionCell.self))
    }
    
    public func makeBackground(blur: Bool = true) -> UIView {
        if blur {
            var background: UIVisualEffectView
            if #available(iOS 13.0, *) {
                background = UIVisualEffectView(effect: UIBlurEffect(style: .systemThinMaterial))
            } else {
                background = UIVisualEffectView(effect: UIBlurEffect(style: .light))
            }
            background.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            return background
        } else {
            let background = UIView()
            background.backgroundColor = ChatKit.asset(color: "background")
            return background
        }
    }
    
    public func sectionView(for section: Section) -> UIView? {
        let view: SectionCell = .fromNib()
        view.titleLabel.text = section.date().dateAgo()
        
        let background = makeBackground()
        view.backgroundView.addSubview(background)
        background.keepInsets.equal = 0
        
        return view
    }
    
    public func messageReplyView() -> MessageReplyView {
        let view: MessageReplyView = .fromNib()
        return view
    }
    
    public func optionCellView() -> OptionCellView {
        let view: OptionCellView = .fromNib()
        view.background.layer.cornerRadius = 5
        view.background.backgroundColor = ChatKit.asset(color: ChatKit.config().chatOptionsIconBackgroundColor)
        view.label.textColor = ChatKit.asset(color: ChatKit.config().chatOptionsTextColor)
        view.imageView.tintColor = ChatKit.asset(color: ChatKit.config().chatOptionsIconColor)
        return view
    }
    
    public func messagesView() -> MessagesView {
        return MessagesView()
    }

    public func chatHeaderView() -> ChatHeaderView {
        return ChatHeaderView()
    }
    
    public func reconnectingView() -> ReconnectingView {
        return ReconnectingView()
    }
    
    public func replyView() -> ReplyView {
        return ReplyView()
    }
    
    public func chatToolbar(_ delegate: ChatToolbarDelegate, actions: ChatToolbarActionsDelegate) -> ChatToolbar {
        let toolbar = ChatToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 35))
        toolbar.setActionsDelegate(actions)
        toolbar.setDelegate(delegate)
        return toolbar
    }
    
    public func sendBarView() -> SendBarView {
        return SendBarView()
    }
    
    public func messagesModel(_ thread: Thread) -> MessagesModel {
        return MessagesModel(thread)
    }
}
