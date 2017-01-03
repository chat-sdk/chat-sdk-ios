//
//  BChatViewController.h
//  Chat SDK
//
//  Created by Benjamin Smiley-andrews on 21/09/2013.
//  Copyright (c) 2013 deluge. All rights reserved.
//

#import <ChatSDK/BTextInputDelegate.h>
#import <ChatSDK/bChatState.h>

#import <ChatSDK/BChatOptionDelegate.h>

@class MPMoviePlayerController;
@class CLLocationManager;
@class MBProgressHUD;

typedef enum {
    bStickerPositionUp,
    bStickerPositionDown,
} bStickerPosition;

@class BTextInputView;
@class BImageViewController;
@class BLocationViewController;
@class MBProgressHUD;
@class BAudioMessageCell;
@class BThreadsViewController;

@class BStickerView;
@class BChatOptionsCollectionView;


@protocol PThread;
@protocol PChatOptionsHandler;

// TODO: Check if there are unused class variables
@interface BChatViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, BTextInputDelegate, UINavigationControllerDelegate, UIScrollViewDelegate, BChatOptionDelegate> {
    
    BTextInputView * _textInputView;
    
    UIGestureRecognizer * _tapRecognizer;
    
    id<PThread> _thread;
    
    UISwipeGestureRecognizer * _swipeGestureRecognizer;
    
    CGPoint _lastContentOffset;
    
    BImageViewController * _imageViewController;
    UINavigationController * _imageViewNavigationController;

    BLocationViewController * _locationViewController;
    UINavigationController * _locationViewNavigationController;
    
    BOOL _messageCacheDirty;
    NSMutableArray * _messageCache;
    
    UIRefreshControl * _refreshControl;
    
    id _messageObserver;
    id _userObserver;
    id _typingObserver;
    id _readReceiptObserver;

    UIActivityIndicatorView * _activityIndicator;
    
    
    MBProgressHUD * _hud;
    
    // This allows us to see what kind of media is being sent to know if we need to save it to album
//    bPictureType _pictureType;
    
    BOOL _usersViewLoaded;
    
    // Typing Indicator
    NSTimer * _typingTimer;
    UILabel * _navigationBarSubtitle;
    
    NSString * _navigationBarSubtitleText;
    bChatState _chatState;
    
    id _threadUsersObserver;
    
    UIView * _keyboardOverlay;
    
    id<PChatOptionsHandler> _optionsHandler;
}

@property (weak, nonatomic) IBOutlet UITableView * tableView;
@property (weak, nonatomic) BThreadsViewController * controller;

@property (strong, nonatomic) MPMoviePlayerController * videoPlayer;

@property (strong, nonatomic) BStickerView * _stickerView;

- (id)initWithThread: (id<PThread>) thread;
-(void) hideKeyboard;

//-(void) sendImage: (UIImage *) image;
//-(void) sendText: (NSString *) message;

@end
