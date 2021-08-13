//
//  Config.swift
//  ChatK!t
//
//  Created by ben3 on 08/04/2021.
//

import Foundation

open class Config {
    
    // Should the camera icon be shown next to the send button
    open var cameraIconEnabled = true
    
    // Should we use icons or text for send button
    open var useIconForSendButton = true
    
    // Should we allow the user to tap the chat navigation bar to show the user info
    open var userChatInfoEnabled = true

    open var messageSelectionEnabled = true

    open var timeFormat = "HH:mm"
    
    open var messageHistoryTimeFormat = "dd/MM/yy hh:mm:ss"

    open var messagesViewSectionTimeFormat = "dd/MM/yy"

    // SendBarView layout parameters
    open var sendBarViewTopPadding = 8
    open var sendBarViewBottomPadding = 8
    open var sendBarViewStartPadding = 8
    open var sendBarViewEndPadding = 8
    open var sendBarViewElementSpacing = 5

    open var sendBarMaxLines = 5

    open var animationDuration = 0.3
    
    open var blurEnabled = true
    open var blurStyle: UIBlurEffect.Style?
    
    open var initialSubtitleInterval: Double = 3
    
    open var chatOptionsBottomMargin: CGFloat = 50.0
    open var chatOptionsIconColor = "gray_1"
    open var chatOptionsIconBackgroundColor = "gray_6"
    open var chatOptionsTextColor = "gray_1"
    
    open var replyBackgroundColor = "white"
    open var replyTitleColor = "gray_dark_const"
    open var replyTextColor = "gray_med_dark_const"
    
    open var messagesViewRefreshHeight: CGFloat = 300
    open var messagesViewSectionViewCornerRadius: CGFloat = 5
    
    open var messagesViewSectionHeight: CGFloat = 40

    // The reply view that shows inside the message bubble
    open var messageReplyViewHeight: CGFloat = 50

    // The reply view that shows above the keyboard
    open var chatReplyViewHeight: CGFloat = 50
    
    open var bubbleInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    open var systemMessageInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)

    open var bubbleCornerRadius: CGFloat = 10
    open var replyViewCornerRadius: CGFloat = 5

    open var outgoingBubbleColor = "outgoing_bubble"
    open var outgoingBubbleSelectedColor = "outgoing_bubble_selected"

    open var incomingBubbleColor = "incoming_bubble"
    open var incomingBubbleSelectedColor = "incoming_bubble_selected"
    
    open var outgoingMessageNibName = "OutgoingMessageCell"
    open var incomingMessageNibName = "IncomingMessageCell"
    
    open var estimatedMessageCellHeight:CGFloat = 100
    open var estimatedMessageSectionHeight:CGFloat = 100
    
    open var downloadFolderName = "ChatKit"
    
    open var minimumAudioRecordingLength = 1

    open var typingTimeout: Double = 3

//    open var loadImageMessageFromURL = false
    
    // We define the max size i.e. 400 and the minimum size which is the screen width
    // minus the space we need to display The avatar and time label
//    open lazy var imageMessageSize = {
//        return min(400, UIScreen.main.bounds.width - 115)
//    }()

    open lazy var imageMessageSize: CGSize = {
        let dim = min(400, UIScreen.main.bounds.width - 115)
        return CGSize(width: dim, height: dim)
    }()

}




