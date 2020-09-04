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

@class BTextInputView;
@class BImageViewController;
@class BLocationViewController;
@class BFileViewController;
@class BMessageSection;
@class BNotificationObserverList;
@class BCoreUtilities;
@class BHook;
@class BMessageManager;
@class BLazyReloadManager;
@class ChatToolbar;
@class ReplyView;

@interface ElmChatViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, PSendBarDelegate, UINavigationControllerDelegate, UIScrollViewDelegate, BChatOptionDelegate, UIDocumentInteractionControllerDelegate> {
        
    UIView<PSendBar> * _sendBarView;
    ChatToolbar * _chatToolbar;
    ReplyView * _replyView;
    
    UIGestureRecognizer * _tapRecognizer;
    
    UINavigationController * _imageViewNavigationController;

    UINavigationController * _locationViewNavigationController;

    UIDocumentInteractionController * _documentInteractionController;
    
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
    BOOL _keyboardVisible;
    
    BMessageManager * _messageManager;
    BOOL _loadingMessages;
    
    BLazyReloadManager * _lazyReloadManager;
    
    NSMutableArray * _selectedIndexPaths;
}

@property (weak, nonatomic) IBOutlet UITableView * tableView;
@property (nonatomic, readwrite, weak) id<ElmChatViewDelegate> delegate;
@property (nonatomic, readonly) UIView<PSendBar> * sendBarView;
@property (nonatomic, readonly) UILabel * titleLabel;
@property (nonatomic, readonly) BMessageManager * messageManager;

-(instancetype) initWithDelegate: (id<ElmChatViewDelegate>) delegate;

-(void) setTitle: (NSString *) title;
-(void) setSubtitle: (NSString *) subtitle;

-(void) startTypingWithMessage: (NSString *) message;
-(void) stopTyping;

-(void) addMessages: (NSArray<PMessage> *) messages;
-(void) addMessages: (NSArray<PMessage> *) messages;
-(void) addMessage: (id<PMessage>) message;

-(void) setMessages: (NSArray<PMessage> *) messages;
-(void) setMessages: (NSArray<PMessage> *) messages scrollToBottom: (BOOL) scroll animate: (BOOL) animate force:(BOOL) force;
-(void) removeMessage: (id<PMessage>) message;
-(void) reloadDataForMessage: (id<PMessage>) message;

-(void) hideKeyboard;
-(void) setAudioEnabled: (BOOL) enabled;

-(void) setTextInputDisabled: (BOOL) disabled;
-(void) setTableViewBottomContentInset: (float) inset;

-(void) registerMessageCells;

// To be overridden
-(void) addObservers;
-(void) removeObservers;

-(void) keyboardWillShow: (NSNotification *) notification;
-(void) keyboardWillHide: (NSNotification *) notification;

-(void) setupTextInputView: (BOOL) forceSuper;

@end
