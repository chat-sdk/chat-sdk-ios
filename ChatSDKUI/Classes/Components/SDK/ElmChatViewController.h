//
//  BChatViewController.h
//  Chat SDK
//
//  Created by Benjamin Smiley-andrews on 21/09/2013.
//  Copyright (c) 2013 deluge. All rights reserved.
//

#import <ChatSDK/PSendBarDelegate.h>
#import <ChatSDK/bChatState.h>
#import <ChatSDK/BChatOptionDelegate.h>
#import <ChatSDK/PElmMessage.h>
#import <ChatSDK/ElmChatViewDelegate.h>

@protocol PChatOptionsHandler;
@protocol PImageViewController;
@protocol PSendBar;

@class MPMoviePlayerController;
@class BTextInputView;
@class BImageViewController;
@class BLocationViewController;
@class BMessageSection;
@class BNotificationObserverList;

@interface ElmChatViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, PSendBarDelegate, UINavigationControllerDelegate, UIScrollViewDelegate, BChatOptionDelegate> {
    
    NSArray<BMessageSection *> * _messages;
    
    UIView<PSendBar> * _sendBarView;
    
    UIGestureRecognizer * _tapRecognizer;
    
    UINavigationController * _imageViewNavigationController;

    UINavigationController * _locationViewNavigationController;
    
    UIRefreshControl * _refreshControl;
        
    // Typing Indicator
    NSTimer * _typingTimer;

    UILabel * _titleLabel;
    UILabel * _subtitleLabel;
    NSString * _subtitleText;

    bChatState _chatState;
    
    UIView * _keyboardOverlay;
    
    id<PChatOptionsHandler> _optionsHandler;
    
    BNotificationObserverList * _notificationList;
    
    BOOL _observersAdded;
}

@property (weak, nonatomic) IBOutlet UITableView * tableView;
@property (nonatomic, readwrite, weak) id<ElmChatViewDelegate> delegate;
@property (nonatomic, readonly) UIView<PSendBar> * sendBarView;
@property (nonatomic, readonly) UILabel * titleLabel;

@property (strong, nonatomic) MPMoviePlayerController * videoPlayer;

-(instancetype) initWithDelegate: (id<ElmChatViewDelegate>) delegate;

-(void) setTitle: (NSString *) title;
-(void) setSubtitle: (NSString *) subtitle;

-(void) startTypingWithMessage: (NSString *) message;
-(void) stopTyping;

-(void) setMessages: (NSArray<BMessageSection *> *) messages;
-(void) setMessages: (NSArray<BMessageSection *> *) messages scrollToBottom: (BOOL) scroll;

-(void) hideKeyboard;
-(void) setAudioEnabled: (BOOL) enabled;

-(void) setTextInputDisabled: (BOOL) disabled;
-(void) setTableViewBottomContentInset: (float) inset;

-(void) registerMessageCells;

// To be overridden
-(void) addObservers;
-(void) removeObservers;

@end
