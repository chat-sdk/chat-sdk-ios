//
//  Provider.swift
//  AFNetworking
//
//  Created by ben3 on 24/04/2021.
//

import Foundation

open class Provider {
    
    public init() {
        
    }
    
    open func sectionNib() -> UINib {
        return UINib(nibName: "SectionCell", bundle: Bundle(for: SectionCell.self))
    }
    
    open func makeBackground(blur: Bool = true, effect: UIBlurEffect? = nil) -> UIView {
        if blur {
            var background: UIVisualEffectView = UIVisualEffectView(effect: effect ?? UIBlurEffect(style: .systemThinMaterial))
            background.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            return background
        } else {
            let background = UIView()
            background.backgroundColor = ChatKit.asset(color: "background")
            return background
        }
    }
    
    open func sectionView(for section: Section) -> UIView? {
        let view: SectionCell = .fromNib()
        view.titleLabel.text = section.date().dateAgo()
        
        let background = makeBackground()
        view.backgroundView.addSubview(background)
        background.keepInsets.equal = 0
        
        return view
    }
    
    open func messageReplyView() -> MessageReplyView {
        let view: MessageReplyView = .fromNib()
        return view
    }
    
    open func optionCellView() -> OptionCellView {
        let view: OptionCellView = .fromNib()
        view.background.layer.cornerRadius = 5
        view.background.backgroundColor = ChatKit.asset(color: ChatKit.config().chatOptionsIconBackgroundColor)
        view.label.textColor = ChatKit.asset(color: ChatKit.config().chatOptionsTextColor)
        view.imageView.tintColor = ChatKit.asset(color: ChatKit.config().chatOptionsIconColor)
        return view
    }
    
    open func messagesView() -> MessagesView {
        return MessagesView()
    }

    open func chatHeaderView() -> ChatHeaderView {
        return ChatHeaderView()
    }
    
    open func reconnectingView() -> ReconnectingView {
        return ReconnectingView()
    }
    
    open func replyView() -> ReplyView {
        return ReplyView()
    }

    open func audioRecorder() -> AudioRecorder {
        return AudioRecorder()
    }

//    open func audioPlayer() -> AudioPlayer {
//        return AudioPlayer()
//    }

    open func assets() -> Assets {
        return Assets()
    }

    open func config() -> Config {
        return Config()
    }

    open func downloadManager() -> DownloadManager {
        return DownloadManager()
    }

    open func messageCellSizeCache(_ model: MessagesModel) -> MessageCellSizeCache {
        return MessageCellSizeCache(model)
    }
    
    open func chatToolbar(_ delegate: ChatToolbarDelegate, actions: ChatToolbarActionsDelegate) -> ChatToolbar {
        let toolbar = ChatToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 35))
        toolbar.setActionsDelegate(actions)
        toolbar.setDelegate(delegate)
        return toolbar
    }
    
    open func sendBarView() -> SendBarView {
        return SendBarView()
    }
    
    open func messagesModel(_ conversation: Conversation) -> MessagesModel {
        return MessagesModel(conversation)
    }
    
    open func chatViewController(_ model: ChatModel) -> ChatViewController {
        return ChatViewController(model: model)
    }
    
    open func messageHeightCache() -> MessageHeightCache {
        return MessageHeightCache()
    }

}
