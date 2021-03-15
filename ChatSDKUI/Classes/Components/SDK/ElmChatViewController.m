//
//  BChatViewController.m
//  Chat SDK
//
//  Created by Benjamin Smiley-andrews on 21/09/2013.
//  Copyright (c) 2013 deluge. All rights reserved.
//

#import "ElmChatViewController.h"

#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>

#import <ChatSDK/Core.h>
#import <ChatSDK/UI.h>

#import <ChatSDK/ChatSDK-Swift.h>

// The distance to the bottom of the screen you need to be for the tableView to snap you to the bottom
#define bTableViewRefreshHeight 300
#define bTableViewBottomMargin 5

@interface ElmChatViewController ()

@end

@implementation ElmChatViewController

@synthesize tableView;
@synthesize delegate;
@synthesize sendBarView = _sendBarView;
//@synthesize titleLabel = _titleLabel;
@synthesize messageManager = _messageManager;
@synthesize headerView = _headerView;

-(instancetype) initWithDelegate: (id<ElmChatViewDelegate>) delegate_  nibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil
{
    self.delegate = delegate_;
    if (!nibNameOrNil) {
        nibNameOrNil = @"BChatViewController";
    }
    if(!nibBundleOrNil) {
        nibBundleOrNil = [NSBundle uiBundle];
    }
    
    self = [super initWithNibName: nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        _messageManager = [BMessageManager new];
        _selectedIndexPaths = [NSMutableArray new];
        
        // Add a tap recognizer so when we tap the table we dismiss the keyboard
        _tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
        [self.view addGestureRecognizer:_tapRecognizer];

        _longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onLongPress:)];
        [tableView addGestureRecognizer: _longPressRecognizer];
        
        // It should only be enabled when the keyboard is being displayed
        _tapRecognizer.enabled = NO;
        

        _notificationList = [BNotificationObserverList new];
        
        _lazyReloadManager = [[BLazyReloadManager alloc] initWithTableView:tableView messageManager:_messageManager];
        _lazyReloadManager.loadMoreMessages = ^() {
            if (self.delegate) {
                return [self.delegate loadMoreMessages];
            }
            return [RXPromise resolveWithResult:Nil];
        };

    }
    return self;
}

// The text input view sits on top of the keyboard
-(void) setupTextInputView: (BOOL) forceSuper {
    _sendBarView = [BChatSDK.ui sendBarView];
    [_sendBarView setSendBarDelegate:self];

    [_sendBarView setSendListener: ^{
        NSString * newMessage = [_sendBarView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (_replyView.isVisible) {
            id<PMessage> message = [self messageForIndexPath:_selectedIndexPaths.firstObject];
            [BChatSDK.thread replyToMessage:message withThreadID:self.threadEntityID reply:newMessage];
            [_replyView dismiss];
        } else {
            [BChatSDK.thread sendMessageWithText:newMessage withThreadEntityID:self.threadEntityID];
        }
    }];
    
    [self.view addSubview:_sendBarView];
    
    _sendBarView.keepBottomInset.equal = self.safeAreaBottomInset;
    _sendBarView.keepLeftInset.equal = 0;
    _sendBarView.keepRightInset.equal = 0;

}

-(void) setReadOnly: (BOOL) readOnly {
    if (readOnly) {
        _replyView.keepBottomOffsetTo(_sendBarView).equal = -_sendBarView.frame.size.height;
        [_sendBarView.superview sendSubviewToBack:_sendBarView];
    } else {
        _replyView.keepBottomOffsetTo(_sendBarView).equal = 0;
        [_sendBarView.superview bringSubviewToFront:_sendBarView];
    }
}


-(void) clearSelection {
    [_selectedIndexPaths removeAllObjects];
    [self reloadData];
    [self hideChatToolbar];
}

-(void) copySelectedMessagesToClipboard {
    NSMutableString * copyText = [NSMutableString new];
    for (NSIndexPath * index in _selectedIndexPaths) {
        id<PMessage> message = [self messageForIndexPath:index];
        NSDateFormatter * formatter = [NSDateFormatter new];
        [formatter setDateFormat:@"dd/MM/yy hh:mm:ss"];
        [copyText appendFormat:@"%@ - %@ %@", [formatter stringFromDate:message.date], message.userModel.name, message.text];
    }
    UIPasteboard.generalPasteboard.string = copyText;
    [self.view makeToast:[NSBundle t: bCopiedToClipboard]];
}
-(void) setupChatToolbar {
    _chatToolbar = [[ChatToolbar alloc] init];
    [self.view addSubview:_chatToolbar];
    
    _chatToolbar.keepTopAlignTo(_sendBarView).equal = 0;
    _chatToolbar.keepRightAlignTo(_sendBarView).equal = 0;
    _chatToolbar.keepBottomAlignTo(_sendBarView).equal = 0;
    _chatToolbar.keepLeftAlignTo(_sendBarView).equal = 0;
    _chatToolbar.alpha = 0;
    
    _chatToolbar.copyListener = ^{
        [self copySelectedMessagesToClipboard];
        [self clearSelection];
    };

    _chatToolbar.replyListener = ^{
        id<PMessage> message = [self messageForIndexPath:_selectedIndexPaths.firstObject];
        
        [_replyView showWithTitle:message.user.name message:message.text imageURL:message.imageURL];
        
        [_chatToolbar hide];
        [self scrollToBottomOfTable:YES];
    };

    _chatToolbar.forwardListener = ^{
        
    };

    _chatToolbar.deleteListener = ^{
        for (NSIndexPath * index in _selectedIndexPaths) {
            id<PMessage> message = [self messageForIndexPath:index];
            [BChatSDK.thread deleteMessage:message.entityID];
        }
        [self clearSelection];
    };

}
-(void) setupReplyView {
    _replyView = [[ReplyView alloc] init];
    [self.view addSubview:_replyView];
    
    _replyView.keepRightInset.equal = 0;
    _replyView.keepLeftInset.equal = 0;
    _replyView.keepBottomOffsetTo(_sendBarView).equal = 0;
    
    [_replyView setDidCloseListenerWithListener:^{
        [self clearSelection];
    }];
    
    [_replyView hideWithDuration:0];
}

-(void) registerMessageCells {
    for(NSArray * cell in BChatSDK.ui.messageCellTypes) {
        [self.tableView registerClass:cell.firstObject forCellReuseIdentifier:[cell.lastObject stringValue]];
    }
}

// The naivgation bar has three functions
// 1 - Shows the name of the chat
// 2 - Show's a message or the list of usersBTextInputView
// 3 - Show's who's typing
-(void) setupNavigationBar {
    
    _headerView = [ChatHeaderView new];

    // When a user taps the title bar we want to know to show the options screen
    if (BChatSDK.config.userChatInfoEnabled) {
        UITapGestureRecognizer * titleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(navigationBarTapped)];
        [_headerView addGestureRecognizer:titleTapRecognizer];
    }

    void(^block)() = ^(NSDictionary * info){
        self.navigationItem.titleView = _headerView;
        if ([BChatSDK.core respondsToSelector:@selector(connectionStatus)] && (BChatSDK.core.connectionStatus != bConnectionStatusConnected) && BChatSDK.core.connectionStatus != bConnectionStatusNone) {
            self.navigationItem.titleView = [ReconnectingView new];
        }
    };
    
    block(nil);
    
    BHook * hook = [BHook hookOnMain:block];
    [BChatSDK.hook addHook:hook withName:bHookServerConnectionStatusUpdated];
    
}

// The options handler is responsible for displaying options to the user
// when the options button is pressed. These can either be in an alert view
// or a collection view shown in the keyboard overlay
-(void) setupKeyboardOverlay {
    _keyboardOverlay = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.fh, self.view.fw, 0)];
    
    if (@available(iOS 13.0, *)) {
        _keyboardOverlay.backgroundColor = [UIColor systemBackgroundColor];
    } 

    _optionsHandler = [BChatSDK.ui chatOptionsHandlerWithDelegate:self];
    
    if(_optionsHandler.keyboardView) {
        [_keyboardOverlay addSubview:_optionsHandler.keyboardView];
        _optionsHandler.keyboardView.keepInsets.equal = 0;
    }
    
    _keyboardOverlay.alpha = 0;
    _keyboardOverlay.userInteractionEnabled = NO;
}

-(void) setTitle: (NSString *) title {
    _headerView.titleLabel.text = title;
}

-(void) setSubtitle: (NSString *) subtitle {
    _subtitleText = subtitle;
    _headerView.subtitleLabel.text = subtitle;
}

-(void) addMessage: (id<PMessage>) message {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSIndexPath * indexPath = [self.messageManager addMessage: message];
//        NSIndexPath * previous = [self.messageManager indexPathForPreviousMessage:message];
//        [tableView beginUpdates];
//        [tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//        if (previous) {
//            [tableView reloadRowsAtIndexPaths:@[previous] withRowAnimation:UITableViewRowAnimationFade];
//        }
//        [tableView endUpdates];
//        [self scrollToBottomOfTable:YES force:message.senderIsMe];
        [self reloadData:YES animate:YES force:message.senderIsMe];
    });
}

-(void) reloadDataForMessageInSection: (id<PMessage>) message {
    [self reloadDataForIndexPath:[_messageManager indexPathForPreviousMessageInSection:message]];
}

-(void) reloadDataForMessage: (id<PMessage>) message {
    [self reloadDataForIndexPath:[_messageManager indexPathForMessage:message]];
}

-(void) reloadDataForIndexPath: (NSIndexPath *) indexPath {
    if (indexPath) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [BChatSDK.shared.logger log: @"Reload %@", NSStringFromSelector(_cmd)];
            [self.tableView reloadData];
//            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        });
    }
}

-(void) addMessages: (NSArray<id<PMessage>> *) messages {
    dispatch_async(dispatch_get_main_queue(), ^{
        [BChatSDK.shared.logger log: @"Reload %@", NSStringFromSelector(_cmd)];
        [self.tableView reloadData];
    });
}

-(void) removeMessage: (id<PMessage>) message {
    [self.messageManager removeMessage: message];
    [self reloadData];
}

-(void) setMessages: (NSArray<PMessage> *) messages {
    [self setMessages:messages scrollToBottom:YES animate:YES force: NO];
}

-(void) setMessages: (NSArray<PMessage> *) messages scrollToBottom: (BOOL) scroll animate: (BOOL) animate force:(BOOL) force {
    [_messageManager setMessages:messages];
    [self reloadData:scroll animate:animate force: force];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Large titles will interfere with the custom navigation bar
    if (@available(iOS 11.0, *)) {
        self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;
    }
    
    // Keep the table header at the top
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.automaticallyAdjustsScrollViewInsets = YES;
    }
    
    // Disable the swipe left to go back
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    // Hide the tab bar when the messages are shown
    self.hidesBottomBarWhenPushed = YES;
    
    // Add an extra 5 px padding between the top of the table and the navigation bar
    // just to give the top message a bit more space
    UIEdgeInsets tableInsets = tableView.contentInset;
    tableInsets.top += 5;
    tableInsets.bottom += bTableViewBottomMargin;
    tableView.contentInset = tableInsets;
    
    // Add the refresh control - drag to load more messages
    _refreshControl = [[UIRefreshControl alloc] init];
    [_refreshControl addTarget:self action:@selector(tableRefreshed) forControlEvents:UIControlEventValueChanged];
    [tableView addSubview:_refreshControl];
    
    [self setupTextInputView: NO];
    [self setupChatToolbar];
    [self setupReplyView];
    
    // Constrain the table to the top of the toolbar
    tableView.keepBottomOffsetTo(_replyView).equal = 2;

    [self registerMessageCells];

    [self setupNavigationBar];

    [self updateInterfaceForReachabilityStateChange];

    [self setupKeyboardOverlay];
    

}

// Cell Selection

-(void) onLongPress: (UILongPressGestureRecognizer *) recognizer {
    if (BChatSDK.config.messageSelectionEnabled && !self.selectionModeEnabled) {
        CGPoint point = [recognizer locationInView:tableView];
        NSIndexPath * path = [tableView indexPathForRowAtPoint:point];
        if (path) {
            if (![_selectedIndexPaths containsObject:path]) {
                [_selectedIndexPaths addObject:path];
            }
            [tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
        }
        [self updateChatToolbar];
    }
}

//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceivePress:(UIPress *)press {
//    if ([gestureRecognizer isEqual:_tapRecognizer]) {
//        return BChatSDK.config.messageSelectionEnabled || _sendBarView.isFirstResponder;
//    }
//    return YES;
//}

-(void) onTap: (UITapGestureRecognizer *) recognizer {
    if (BChatSDK.config.messageSelectionEnabled && self.selectionModeEnabled) {
        CGPoint point = [recognizer locationInView:tableView];
        NSIndexPath * path = [tableView indexPathForRowAtPoint:point];
        if (path) {
            if ([_selectedIndexPaths containsObject:path]) {
                [_selectedIndexPaths removeObject:path];
            } else {
                [_selectedIndexPaths addObject:path];
            }
            [tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
        }
        [self updateChatToolbar];
    } else {
        [self hideKeyboard];
    }
}

-(void) updateChatToolbar {
    if (!self.selectionModeEnabled) {
        [_chatToolbar hide];
    } else {
        [self showOrUpdateChatToolbar];
    }
}

-(BOOL) selectionModeEnabled {
    return _selectedIndexPaths.count > 0;
}

-(void) showOrUpdateChatToolbar {
    
    // Setup which items are active
    _chatToolbar.replyButton.enabled = _selectedIndexPaths.count == 1;
    
    BOOL canDelete = YES;
    
    for (NSIndexPath * path in _selectedIndexPaths) {
        id<PMessage> message = [self messageForIndexPath:path];
        if (![BChatSDK.thread canDeleteMessage:message]) {
            canDelete = NO;
            break;
        }
    }
    
    _chatToolbar.deleteButton.enabled = canDelete;
    
    [self resignFirstResponder];
    
    [_chatToolbar show];
}

-(void) hideChatToolbar {
    [_chatToolbar hide];
    [_replyView hide];
}

-(void) tableRefreshed {
    if ([delegate respondsToSelector:@selector(loadMoreMessages)]) {
        [delegate loadMoreMessages].thenOnMain(^id(id success) {
            [_refreshControl endRefreshing];
            return Nil;
        }, ^id(NSError * error) {
            [_refreshControl endRefreshing];
            return Nil;
        });
    }
}

-(void) startTypingWithMessage: (NSString *) message {
    if(message && message.length) {
        _headerView.subtitleLabel.text = message;
        __weak __typeof__(self) weakSelf = self;
        [NSTimer scheduledTimerWithTimeInterval:5 repeats:NO block:^(NSTimer * timer) {
            __typeof(self) strongSelf = weakSelf;
            [timer invalidate];
            [strongSelf stopTyping];
        }];
    }
    else {
        [self stopTyping];
    }
}

-(void) stopTyping {
    _headerView.subtitleLabel.text = _subtitleText;
}

-(void) setTextInputDisabled: (BOOL) disabled {
    _sendBarView.hidden = disabled;
}

-(void) setAudioEnabled:(BOOL)enabled {
    [_sendBarView setAudioEnabled: enabled];
}

// Typing Indicator
-(void) typing {
    [self setChatState:bChatStateComposing];
    // Each time the user types we reset the timer
    [_typingTimer invalidate];
    
    __weak __typeof(self) weakSelf = self;
    _typingTimer = [NSTimer scheduledTimerWithTimeInterval:bTypingTimeout repeats:NO block:^(NSTimer * timer) {
        [timer invalidate];
        __typeof(self) strongSelf = weakSelf;
        [strongSelf userFinishedTyping];
    }];
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self addObservers];
    
    self.tabBarController.tabBar.hidden = YES;
    
    // The user's read the messages
    [delegate markRead];
    
    // This scrolls the tableview almost to the bottom
    // This happens because autolayout hasn't yet been
    // layed out
    // The effect that this gives is that the
    // view starts off almost at the bottom and
    // scrolls the last bit animated (viewDidAppear)
    [self scrollToBottomOfTable:NO force:YES];
    
//    [self setChatState:bChatStateActive];
        
    [self reloadData];
}

-(void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    // Make sure the bottom inset is correct
    if (!_keyboardVisible) {
        _sendBarView.keepBottomInset.equal = self.safeAreaBottomInset;
    }
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    [self reloadData];
}

-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self removeObservers];
    
//    [self.delegate markRead];
    
    _keyboardOverlay.alpha = 0;
    _keyboardOverlay.userInteractionEnabled = NO;
    
    // Typing Indicator
    // When the user leaves then automatically set them not to be typing in the thread
//    [self userFinishedTypingWithState: bChatStateInactive];
}

#pragma TableView delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _messageManager.sectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_messageManager rowCountForSection:section];
}

-(id<PElmMessage>) messageForIndexPath: (NSIndexPath *) path {
    return [_messageManager messageForIndexPath:path];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [_messageManager headerForSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView_ cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id<PElmMessage> message = [self messageForIndexPath:indexPath];
        
    BMessageCell * messageCell;
    
    // We want to check if the message is a premium type but without the libraries added
    // Without this check the app crashes if the user doesn't have premium cell types
    if ((!BChatSDK.stickerMessage && message.type.integerValue == bMessageTypeSticker) ||
        (!BChatSDK.fileMessage && message.type.integerValue == bMessageTypeFile) ||
        (!BChatSDK.videoMessage && message.type.integerValue == bMessageTypeVideo) ||
        (!BChatSDK.fileMessage && message.type.integerValue == bMessageTypeFile) ||
        (!BChatSDK.audioMessage && message.type.integerValue == bMessageTypeAudio)) {
        // This is a standard text cell
        messageCell = [tableView_ dequeueReusableCellWithIdentifier:@"0"];
    }
    else {
        messageCell = [tableView_ dequeueReusableCellWithIdentifier:message.type.stringValue];
    }

    messageCell.navigationController = self.navigationController;
    
    [messageCell setMessage:message isSelected:[_selectedIndexPaths containsObject:indexPath]];
    
    return messageCell;
}

-(void) addObservers {
    [self removeObservers];
    __weak __typeof__(self) weakSelf = self;
    
    [_notificationList add:[[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillEnterForegroundNotification object:Nil queue:Nil usingBlock:^(NSNotification * notification) {
        __typeof__(self) strongSelf = weakSelf;
        dispatch_async(dispatch_get_main_queue(), ^{
            [strongSelf addUserToPublicThreadIfNecessary];
        });
    }]];
    
    [_notificationList add: [BChatSDK.hook addHook:[BHook hookOnMain:^(NSDictionary * data) {
        __typeof__(self) strongSelf = weakSelf;
        [strongSelf updateInterfaceForReachabilityStateChange];
    }] withName:bHookInternetConnectivityDidChange]];
    
    // Observe for keyboard appear and disappear notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:Nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:Nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:Nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:Nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:Nil];
}

-(void) removeObservers {
    [_notificationList dispose];
        
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:Nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:Nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:Nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:Nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:Nil];

}

-(void) addUserToPublicThreadIfNecessary {}

// Layout out the bubbles. Do this after the cell's been made so we have
// access to the cell dimensions
-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    // Allow the table to support different background colors
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    if ([cell respondsToSelector:@selector(willDisplayCell)]) {
        [cell performSelector:@selector(willDisplayCell)];
    }
}

// Set the message height based on the text height
- (CGFloat)tableView:(UITableView *)tableView_ heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id<PElmMessage> message = [self messageForIndexPath:indexPath];
    if(message && [message entityID]) {
        return [BMessageCell cellHeight:message];
    }
    else {
//        NSLog(@"Section: %i, row: %i" , indexPath.section, indexPath.row);
        [_messageManager debug];
        return 0;
    }
}

- (void)tableView:(UITableView *)tableView_ didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BMessageCell * cell = (BMessageCell *) [tableView_ cellForRowAtIndexPath:indexPath];
        
    NSURL * url = Nil;
    if ([cell isKindOfClass:[BImageMessageCell class]]) {
        
        url = cell.message.imageURL;
        
        if (!_imageViewNavigationController) {
            _imageViewNavigationController = [BChatSDK.ui imageViewNavigationController];
        }

        // TODO: Refactor this to use the JSON keys
        url = cell.message.imageURL;
        // Only allow the user to click if the image is not still loading hence the alpha is 1
        if (cell.imageView.alpha == 1 && url) {

            [cell showActivityIndicator];
            cell.imageView.alpha = 0.75;
            
            __weak __typeof__(self) weakSelf = self;
            [cell.imageView sd_setImageWithURL:url placeholderImage:cell.imageView.image completed: ^(UIImage * image, NSError * error, SDImageCacheType cacheType, NSURL * imageURL) {
                __typeof__(self) strongSelf = weakSelf;
                
                [cell hideActivityIndicator];
                cell.imageView.alpha = 1;
                
                [((id<PImageViewController>) strongSelf->_imageViewNavigationController.topViewController) setImage: image];
                [strongSelf.navigationController presentViewController:strongSelf->_imageViewNavigationController animated:YES completion:Nil];
            }];
        }
    }
    if ([cell isKindOfClass:[BLocationCell class]]) {
        if (!_locationViewNavigationController) {
            _locationViewNavigationController = [BChatSDK.ui locationViewNavigationController];
        }
        
        float longitude = [cell.message.meta[bMessageLongitude] floatValue];
        float latitude = [cell.message.meta[bMessageLatitude] floatValue];
        
        [((id<PLocationViewController>) _locationViewNavigationController.topViewController) setLatitude:latitude longitude:longitude];

        [self.navigationController presentViewController:_locationViewNavigationController animated:YES completion:Nil];
    }
    
    if(BChatSDK.videoMessage && [cell isKindOfClass:BChatSDK.videoMessage.cellClass]) {
            
        // Only allow the user to click if the image is not still loading hence the alpha is 1
        if (cell.imageView.alpha == 1) {
            
            NSURL * url = [NSURL URLWithString:cell.message.meta[bMessageVideoURL]];
                        
            // Add an activity indicator while the image is loading
            UIActivityIndicatorView * activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            activityIndicator.frame = CGRectMake(cell.imageView.fw/2 - 20, cell.imageView.fh/2 -20, 40, 40);
            [activityIndicator startAnimating];
            
            [cell.imageView addSubview:activityIndicator];
            [cell.imageView bringSubviewToFront:activityIndicator];
            
            // Make sure the audio plays even if we're in silent mode
            [[AVAudioSession sharedInstance]
             setCategory: AVAudioSessionCategoryPlayback
             error: nil];
            
            AVPlayer * player = [[AVPlayer alloc] initWithURL:url];
            [player.currentItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
            [player addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];

            AVPlayerViewController * playerController = [[AVPlayerViewController alloc] init];
            playerController.player = player;
            [self presentViewController:playerController animated:YES completion:Nil];
            
        }
    }

    if (BChatSDK.fileMessage && [cell isKindOfClass:BChatSDK.fileMessage.cellClass]) {
        NSDictionary * meta = cell.message.meta;

        if (![BFileCache isFileCached:cell.message.entityID]) {
            [cell.imageView setImage:[NSBundle imageNamed:@"file.png" bundle:BChatSDK.fileMessage.bundle]];
        }
        
        [cell showActivityIndicator];
        
        NSURL * url = [NSURL URLWithString:meta[bMessageFileURL]];
        [BFileCache cacheFileFromURL:url withFileName:meta[bMessageText] andCacheName:cell.message.entityID]
        .thenOnMain(^id(NSURL * cacheUrl) {
            [BChatSDK.shared.logger log: @"Cache URL: %@", [cacheUrl absoluteString]];
            [cell setMessage:cell.message isSelected:[_selectedIndexPaths containsObject:indexPath]];
            
            [cell hideActivityIndicator];
            
            [self presentDocumentInteractionViewControllerWithURL:cacheUrl andName:nil];
            return nil;
        }, ^id(NSError *error) {
            [BChatSDK.shared.logger log: @"Error: %@", error.localizedDescription];
            [cell hideActivityIndicator];
            return nil;
        });
    }
    
    if ([cell isKindOfClass:[BTextMessageCell class]]) {
        NSString * string = cell.message.text;
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = string;
    }
}

// This observer looks at whether the audio is ready to play then returns the loading promise
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    NSError * error;
    if ([object isKindOfClass:[AVPlayer class]]) {
        error = [((AVPlayer *) object) error];
    }
    if ([object isKindOfClass:[AVPlayerItem class]]) {
        error = [((AVPlayerItem *) object) error];
    }
    if (error) {
        [BChatSDK.shared.logger log: @"%@", error.localizedDescription];
    }
}

- (void)presentDocumentInteractionViewControllerWithURL:(NSURL *)url andName:(NSString *)name {
    _documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:url];
    [_documentInteractionController setDelegate:self];
    if (name) {
        [_documentInteractionController setName:name];
    }
    [_documentInteractionController presentPreviewAnimated:YES];
}

-(BOOL) showOptions {
    
    // Needed for keyboard overlay to raise keyboard
    [_sendBarView becomeTextViewFirstResponder];
    
    if (_optionsHandler.keyboardView) {
        _keyboardOverlay.alpha = 1;
        _keyboardOverlay.userInteractionEnabled = YES;
    }
    
    return [_optionsHandler show];
}

-(BOOL) hideOptions {
    [_sendBarView becomeTextViewFirstResponder];

    _keyboardOverlay.alpha = 0;
    _keyboardOverlay.userInteractionEnabled = NO;
    return [_optionsHandler hide];
}

-(void) didResizeTextInputViewWithDelta:(float)delta {
//    if (fabsf(delta) > 0.01) {
//        [self setTableViewBottomContentInsetWithDelta:delta];
//        [self scrollToBottomOfTable:NO];
//    }
}

-(void) hideKeyboard {
    [_sendBarView resignTextViewFirstResponder];
}

#pragma BChatOptionDelegate

-(UIViewController *) currentViewController {
    return self;
}

#pragma  Picture selection

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id<PElmMessage> message = [self messageForIndexPath:indexPath];
    
    return message.flagged.intValue ? bUnflag : [NSBundle t:bFlag];
}

// Check that this is called for iOS7
- (void)tableView:(UITableView *)tableView_ commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id<PElmMessage> message = [self messageForIndexPath:indexPath];
    
    __weak __typeof(self) weakSelf = self;
    [delegate setMessageFlagged:message isFlagged:message.flagged.intValue].thenOnMain(^id(id success) {
        // Reload the tableView and not [self reloadData] so we don't go to the bottom of the tableView
        [weakSelf reloadDataForMessage:message];
        return Nil;
    }, Nil);
    
    [tableView_ setEditing:NO animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return BChatSDK.config.messageDeletionEnabled || BChatSDK.moderation;
}

// This only works for iOS8
-(NSArray *)tableView:(UITableView *)tableView_ editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak __typeof__(self) weakSelf = self;

    id<PElmMessage> message = [self messageForIndexPath:indexPath];
    if ([BChatSDK.thread canDeleteMessage:message] && BChatSDK.config.messageDeletionEnabled) {
        UITableViewRowAction * button = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                                                           title:[NSBundle t:bDelete]
                                                                         handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
            [BChatSDK.thread deleteMessage:message.entityID];
        }];
        
        if (@available(iOS 13.0, *)) {
            button.backgroundColor = [UIColor systemRedColor];
        } else {
            button.backgroundColor = [UIColor redColor];
        }

        return @[button];

    }
    else if(BChatSDK.moderation.canFlagMessage) {
        NSString * flagTitle = message.flagged.intValue ? [NSBundle t:bUnflag] : [NSBundle t:bFlag];
        
        UITableViewRowAction * button = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:flagTitle handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
            __typeof__(self) strongSelf = weakSelf;
            [strongSelf.delegate setMessageFlagged:message isFlagged:message.flagged.intValue].thenOnMain(^id(id success) {
                // Reload the tableView and not [self reloadData] so we don't go to the bottom of the tableView
                [strongSelf reloadDataForMessage:message];
                return Nil;
            }, Nil);
            
        }];
        
        if (@available(iOS 13.0, *)) {
            button.backgroundColor = message.flagged.intValue ? [UIColor systemGrayColor] : [UIColor systemRedColor];
        } else {
            button.backgroundColor = message.flagged.intValue ? [UIColor grayColor] : [UIColor redColor];
        }
        
        return @[button];
    }
    
    return @[];
}

#pragma Handle keyboard

// Move the toolbar up
-(void) keyboardWillShow: (NSNotification *) notification {
    
    if (_keyboardVisible) {
        return;
    }
    
    _keyboardVisible = YES;
    
    // Get the keyboard size
    CGRect keyboardBounds = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect keyboardBoundsConverted = [self.view convertRect:keyboardBounds toView:Nil];
    
    // Get the duration and curve from the notification
    NSNumber *duration = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];

    // Set the initial position
    [UIView beginAnimations:Nil context:Nil];
    [UIView setAnimationDuration:0];
    _keyboardOverlay.frame = CGRectMake(0, self.view.fh, self.view.fw, 0);
    [UIView commitAnimations];
    
    // Set the new constraints
    _sendBarView.keepBottomInset.equal = keyboardBoundsConverted.size.height;
    
    [[UIApplication sharedApplication].windows.lastObject addSubview: _keyboardOverlay];
    _keyboardOverlay.frame = keyboardBounds;
    
    // Animate using this style because for some reason
    // using blocks doesn't give a smooth animation
    [UIView beginAnimations:Nil context:Nil];
    
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:duration.doubleValue];
    [UIView setAnimationCurve:curve.integerValue];

    CGFloat contentOffsetY = tableView.contentOffset.y + keyboardBoundsConverted.size.height - self.safeAreaBottomInset;

    [tableView setContentOffset:CGPointMake(0, contentOffsetY)];

    [UIView setAnimationsEnabled:NO];
    
//    for(NSIndexPath * indexPath in tableView.indexPathsForVisibleRows) {
//        [[tableView cellForRowAtIndexPath:indexPath] layoutIfNeeded];
//        [[tableView headerViewForSection:indexPath.section] layoutIfNeeded];
//    }
//
//    [tableView layoutIfNeeded];
    
    for(UITableViewCell * cell in tableView.visibleCells) {
        [cell layoutIfNeeded];
    }

    [UIView setAnimationsEnabled:YES];


    [self.view layoutIfNeeded];

    [UIView commitAnimations];
    
}

-(void) keyboardWillHide: (NSNotification *) notification {
    
    if (!_keyboardVisible) {
        return;
    }
    
    NSNumber *duration = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    CGRect keyboardBounds = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect keyboardBoundsConverted = [self.view convertRect:keyboardBounds toView:Nil];

    _keyboardOverlay.frame = keyboardBounds;
    
    _sendBarView.keepBottomInset.equal = self.safeAreaBottomInset;
    [_sendBarView setNeedsUpdateConstraints];
    
    [UIView beginAnimations:Nil context:Nil];
    
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:duration.doubleValue];
    [UIView setAnimationCurve:curve.integerValue];
    
    
    [UIView setAnimationsEnabled:NO];
    
    for(UITableViewCell * cell in tableView.visibleCells) {
        [cell setNeedsLayout];
        [cell layoutIfNeeded];
    }

    [UIView setAnimationsEnabled:YES];

    CGFloat contentOffsetY = tableView.contentOffset.y - keyboardBoundsConverted.size.height + self.safeAreaBottomInset;
    [tableView setContentOffset:CGPointMake(0, contentOffsetY)];

    [self.view layoutIfNeeded];

    [UIView commitAnimations];
    
    // Disable the gesture recognizer so cell taps are recognized
    _tapRecognizer.enabled = NO;
    
}

-(void) keyboardDidShow: (NSNotification *) notification {
    
    if (!_keyboardVisible) {
        return;
    }

    // Get the keyboard size
    CGRect keyboardBounds = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect keyboardBoundsConverted = [self.view convertRect:keyboardBounds toView:Nil];
        
    // Enable the tap gesture recognizer to hide the keyboard
    _tapRecognizer.enabled = YES;
}


-(float) safeAreaBottomInset {
    // Move the text input up to avoid the bottom area
    if (@available(iOS 11, *)) {
        return self.view.safeAreaInsets.bottom;
    }
    return 0;
}

-(void) keyboardWillChangeFrame: (NSNotification *) notification {
    if (!_keyboardVisible) {
        return;
    }

    // Get the keyboard size
    CGRect keyboardBounds = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect keyboardBoundsConverted = [self.view convertRect:keyboardBounds toView:Nil];

    // Set the new constraints
    _sendBarView.keepBottomInset.equal = keyboardBoundsConverted.size.height;
    
    [[UIApplication sharedApplication].windows.lastObject addSubview: _keyboardOverlay];
    _keyboardOverlay.frame = keyboardBounds;

}

-(void) keyboardDidHide: (NSNotification *) notification {
    
    if (!_keyboardVisible) {
        return;
    }
    
    [_keyboardOverlay removeFromSuperview];
    _keyboardVisible = NO;
    
    // Hide the options...
    _keyboardOverlay.alpha = 0;
    _keyboardOverlay.userInteractionEnabled = NO;
    [_optionsHandler hide];
}

-(void) scrollToBottomOfTable: (BOOL) animated {
    [self scrollToBottomOfTable:animated force:NO];
}

-(void) scrollToBottomOfTable: (BOOL) animated force: (BOOL) force {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSInteger lastSection = self.tableView.numberOfSections - 1;
        if (lastSection < 0) {
            return;
        }
        NSInteger lastRow = [self.tableView numberOfRowsInSection:lastSection] - 1;
        if (lastRow < 0) {
            return;
        }
        
        BOOL scroll = NO;
        if ((self.tableView.contentSize.height - self.tableView.frame.size.height) - self.tableView.contentOffset.y <= bTableViewRefreshHeight) {
            scroll = YES;
        }
        
        if (scroll || force) {
            NSIndexPath * indexPath = [NSIndexPath indexPathForItem:lastRow inSection:lastSection];
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:animated];
        }
    });
}

-(void) reloadData {
    [self reloadData:YES animate: YES force:NO];
}

-(void) reloadData: (BOOL) scroll animate: (BOOL) animate force: (BOOL) force {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        if (scroll) {
            [self scrollToBottomOfTable:animate force:force];
        }
//
//
//        [UIView transitionWithView: self.tableView
//                          duration: 0//animate ? 0.2f : 0
//                           options: UIViewAnimationOptionTransitionCrossDissolve
//                        animations: ^(void) {
////                            NSLog(@"Reload %@", NSStringFromSelector(_cmd));
//                            [self.tableView reloadData];
//                        }
//                        completion: ^(BOOL finished) {
//                            if (scroll) {
//                                [self scrollToBottomOfTable:animate force:force];
//                            }
//                        } ];
    });
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_lazyReloadManager scrollViewDidScroll: scrollView];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [_lazyReloadManager scrollViewWillBeginDragging:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [_lazyReloadManager scrollViewDidEndDecelerating:scrollView];
}

#pragma Utility Methods

- (void) navigationBarTapped {
    [delegate navigationBarTapped];
}

- (void)updateInterfaceForReachabilityStateChange {
    BOOL connected = BChatSDK.connectivity.isConnected;
    self.navigationItem.rightBarButtonItem.enabled = connected;
}

-(void) userFinishedTyping {
    [self userFinishedTypingWithState:bChatStateActive];
}

-(void) setChatState: (bChatState) state {
    if (state != _chatState) {
        [delegate setChatState:state];
    }
    _chatState = state;
}

-(void) userFinishedTypingWithState: (bChatState) state {
    [self setChatState:state];
    [_typingTimer invalidate];
}

-(UIViewController *) viewController {
    return self;
}

-(void) dealloc {
    self.delegate = Nil;
    [_sendBarView setSendBarDelegate:Nil];
    self.tableView.delegate = Nil;
    self.tableView.dataSource = Nil;
    _typingTimer = Nil;
}

#pragma UIDocumentInteractionControllerDelegate

- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller {
    return self;
}

- (UIView *)documentInteractionControllerViewForPreview:(UIDocumentInteractionController *)controller {
    return self.view;
}

- (CGRect)documentInteractionControllerRectForPreview:(UIDocumentInteractionController *)controller {
    return self.view.frame;
}

@end
