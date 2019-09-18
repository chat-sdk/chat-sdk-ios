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


// The distance to the bottom of the screen you need to be for the tableView to snap you to the bottom
#define bTableViewRefreshHeight 300
#define bTableViewBottomMargin 5

@interface ElmChatViewController ()

@end

@implementation ElmChatViewController

@synthesize tableView;
@synthesize delegate;
@synthesize sendBarView = _sendBarView;
@synthesize titleLabel = _titleLabel;
@synthesize messageManager = _messageManager;

-(instancetype) initWithDelegate: (id<ElmChatViewDelegate>) delegate_
{
    self.delegate = delegate_;
    self = [super initWithNibName:@"BChatViewController" bundle:[NSBundle uiBundle]];
    if (self) {
        
        _messageManager = [BMessageManager new];
        
        // Add a tap recognizer so when we tap the table we dismiss the keyboard
        _tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped)];
        
        // It should only be enabled when the keyboard is being displayed
        _tapRecognizer.enabled = NO;
        [self.view addGestureRecognizer:_tapRecognizer];
        
        // When a user taps the title bar we want to know to show the options screen
        if (BChatSDK.config.userChatInfoEnabled) {
            UITapGestureRecognizer * titleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(navigationBarTapped)];
            [self.navigationItem.titleView addGestureRecognizer:titleTapRecognizer];
        }
        
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
-(void) setupTextInputView {
    _sendBarView = [BChatSDK.ui sendBarView];
    [_sendBarView setSendBarDelegate:self];
    
    [self.view addSubview:_sendBarView];
    
    _sendBarView.keepBottomInset.equal = self.safeAreaBottomInset;
    _sendBarView.keepLeftInset.equal = 0;
    _sendBarView.keepRightInset.equal = 0;
    
    // Constrain the table to the top of the toolbar
    tableView.keepBottomOffsetTo(_sendBarView).equal = 2;
    
//    tableView.layer.borderColor = [UIColor redColor].CGColor;
//    tableView.layer.borderWidth = 2;
    
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
    self.viewController.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    
//    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"< Back" style:UIBarButtonItemStylePlain target:nil action:nil];
//    [backButtonItem setTintColor:[UIColor blackColor]];
//    self.viewController.navigationItem.backBarButtonItem = backButtonItem;
//    UIImage *image = [[UIImage imageNamed:@"option"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    self.navigationItem.rightBarButtonItem =  [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(openOptionActionSheet)];
    
    UIBarButtonItem *chatOptionButton = [[UIBarButtonItem alloc] initWithTitle:@"..."               style:UIBarButtonItemStylePlain target:self action:@selector(openOptionActionSheet)];
    [chatOptionButton setTintColor:[UIColor blackColor]];
    self.navigationItem.rightBarButtonItem = chatOptionButton;
    
    UIView * containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 220, 40)];
    
    _titleLabel = [[UILabel alloc] init];
    
    _titleLabel.text = [NSBundle t: bThread];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont boldSystemFontOfSize:_titleLabel.font.pointSize];
    
    [containerView addSubview:_titleLabel];
    _titleLabel.keepInsets.equal = 0;
    _titleLabel.keepBottomInset.equal = 15;
    
    
    
    
    _subtitleLabel = [[UILabel alloc] init];
    _subtitleLabel.textAlignment = NSTextAlignmentCenter;
    _subtitleLabel.font = [UIFont italicSystemFontOfSize:12.0];
    _subtitleLabel.textColor = [UIColor lightGrayColor];
    
    [containerView addSubview:_subtitleLabel];
    
    _subtitleLabel.keepHeight.equal = 15;
    _subtitleLabel.keepWidth.equal = 200;
    _subtitleLabel.keepBottomInset.equal = 0;
    _subtitleLabel.keepHorizontalCenter.equal = 0.5;
    
    [self.navigationItem setTitleView:containerView];
}

-(void)hideRightBarButton {
    self.navigationItem.rightBarButtonItem = nil;
}

-(void)openOptionActionSheet {
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        // Cancel button tappped.
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"members", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        // Distructive button tapped.
        [self navigationBarTapped];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"invite_others", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self addUser];

    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"edit_group_name", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self editGroupNameAlert];
    }]];
    [actionSheet addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"leave_chat", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self leaveGroupAction];
    }]];
    
    // Present action sheet.
    [self presentViewController:actionSheet animated:YES completion:nil];
}

-(void) editGroupNameAlert {
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: NSLocalizedString(@"group_name", nil)
                                                                              message: nil
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = _titleLabel.text;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }];
    
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Ok", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSArray * textfields = alertController.textFields;
        UITextField * groupName = textfields[0];
        if (groupName.text != nil) {
            [self setTitle:groupName.text];
             [self setThreadName:groupName.text];
        }
      
        
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}
// The options handler is responsible for displaying options to the user
// when the options button is pressed. These can either be in an alert view
// or a collection view shown in the keyboard overlay
-(void) setupKeyboardOverlay {
    _keyboardOverlay = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.fh, self.view.fw, 0)];
    _keyboardOverlay.backgroundColor = [UIColor whiteColor];
    
    _optionsHandler = [BChatSDK.ui chatOptionsHandlerWithDelegate:self];
    
    if(_optionsHandler.keyboardView) {
        [_keyboardOverlay addSubview:_optionsHandler.keyboardView];
        _optionsHandler.keyboardView.keepInsets.equal = 0;
    }
    
    _keyboardOverlay.alpha = 0;
    _keyboardOverlay.userInteractionEnabled = NO;
}

-(void) setTitle: (NSString *) title {
    _titleLabel.text = title;
    [[NSUserDefaults standardUserDefaults] setObject:_titleLabel.text forKey:@"chatViewTitle"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void) setSubtitle: (NSString *) subtitle {
    _subtitleText = subtitle;
    _subtitleLabel.text = subtitle;
}

-(void) addMessage: (id<PMessage>) message {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.messageManager addMessage: message];
//        NSIndexPath * indexPath = [self.messageManager addMessage: message];
//        NSIndexPath * indexPathOfPreviousMessage;
        
//        [self.tableView beginUpdates];
        
//        if (indexPath) {
//            // Also refresh the previous cell
//            indexPathOfPreviousMessage = [self.messageManager indexPathForPreviousMessageInSection:message];
//        }
//
//        if (indexPath) {
//            // We are adding a new section
//            if (indexPath.section == self.tableView.numberOfSections) {
//                [self.tableView insertSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
//            } else {
//                [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//            }
//            if (indexPathOfPreviousMessage) {
//                [self.tableView reloadRowsAtIndexPaths:@[indexPathOfPreviousMessage] withRowAnimation:UITableViewRowAnimationFade];
//            }
//        }
//        [self.tableView endUpdates];
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
            NSLog(@"Reload %@", NSStringFromSelector(_cmd));
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        });
    }
}

-(void) addMessages: (NSArray<id<PMessage>> *) messages {
    dispatch_async(dispatch_get_main_queue(), ^{
        id<PMessage> oldestMessage = self.messageManager.oldestMessage;
        NSMutableArray<NSIndexPath *> * indexPaths = [NSMutableArray arrayWithArray:[self.messageManager addMessages: messages]];

//        [self.tableView beginUpdates];
        NSLog(@"Reload %@", NSStringFromSelector(_cmd));
        [self.tableView reloadData];
        
//        [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
//
//        // Also refrest the oldest message because we have loaded a message before that
//        NSIndexPath * oldestMessagePath = [self.messageManager indexPathForMessage:oldestMessage];
//        if (oldestMessagePath) {
//            [indexPaths addObject:oldestMessagePath];
//        }
//        [self.tableView endUpdates];
////        [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
//
//        // Move the top of the list to the old first message
//        NSIndexPath * oldestMessagePath = [self.messageManager indexPathForMessage:oldestMessage];
//        if (oldestMessagePath) {
//            [self.tableView scrollToRowAtIndexPath:oldestMessagePath atScrollPosition:UITableViewScrollPositionTop animated:YES];
//        }
    });
}

-(void) removeMessage: (id<PMessage>) message {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.messageManager removeMessage: message];
    });
}

//-(void) removeMessages: (NSArray<id<PMessage>> *) messages {
//    NSArray<NSIndexPath *> * indexPaths = [_messageManager removeMessages: messages];
//    [tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
//}

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
    
    [self setupTextInputView];

    [self registerMessageCells];

    [self setupNavigationBar];

    [self updateInterfaceForReachabilityStateChange];

    [self setupKeyboardOverlay];

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
        _subtitleLabel.text = message;
    }
    else {
        [self stopTyping];
    }
}

-(void) stopTyping {
    _subtitleLabel.text = _subtitleText;
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
    _typingTimer = [NSTimer scheduledTimerWithTimeInterval:bTypingTimeout
                                                    target:self
                                                  selector:@selector(userFinishedTyping)
                                                  userInfo:nil
                                                   repeats:NO];
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.viewController.navigationController.navigationBar.tintColor = [UIColor blackColor];

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
    
    [self setChatState:bChatStateActive];
    
//    [self reloadData];
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

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self scrollToBottomOfTable:YES];
}


-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self removeObservers];
    
    [self.delegate markRead];
    
    _keyboardOverlay.alpha = 0;
    _keyboardOverlay.userInteractionEnabled = NO;
    
    // Typing Indicator
    // When the user leaves then automatically set them not to be typing in the thread
    [self userFinishedTypingWithState: bChatStateInactive];
}

// When the view is tapped - dismiss the keyboard
-(void) viewTapped {
    [self hideKeyboard];
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
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyIdentifier"];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyIdentifier"];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        
//    }
//    cell.textLabel.font =  BChatSDK.config.messageTimeFont;
//    cell.textLabel.text = @"user left the chat";
//    cell.textLabel.backgroundColor = [UIColor redColor];
//    cell.textLabel.textAlignment = NSTextAlignmentCenter;
//    return cell;
    
    id<PElmMessage> message = [self messageForIndexPath:indexPath];

    if (BChatSDK.encryption) {
        [BChatSDK.encryption decryptMessage:message];
    }
    
    BMessageCell<BMessageDelegate> * messageCell;
    
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

    // Add a gradient to the cells
    //float colorWeight = ((float) indexPath.row / (float) self.messages.count) * 0.15 + 0.85;
    float colorWeight = 1;

    [messageCell setMessage:message withColorWeight:colorWeight];
    
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
    
    [_notificationList add: [BChatSDK.hook addHook:[BHook hook:^(NSDictionary * data) {
        __typeof__(self) strongSelf = weakSelf;
        [strongSelf updateInterfaceForReachabilityStateChange];
    }] withName:bHookInternetConnectivityDidChange]];
    
    // Observe for keyboard appear and disappear notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:Nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:Nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:Nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:Nil];
}

-(void) removeObservers {
    [_notificationList dispose];
        
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:Nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:Nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:Nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:Nil];

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
            NSLog(@"Cache URL: %@", [cacheUrl absoluteString]);
            [cell setMessage:cell.message];
            
            [cell hideActivityIndicator];
            
            [self presentDocumentInteractionViewControllerWithURL:cacheUrl andName:nil];
            return nil;
        }, ^id(NSError *error) {
            NSLog(@"Error: %@", error.localizedDescription);
            [cell hideActivityIndicator];
            return nil;
        });
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
    
    [delegate setMessageFlagged:message isFlagged:message.flagged.intValue].thenOnMain(^id(id success) {
        // Reload the tableView and not [self reloadData] so we don't go to the bottom of the tableView
        [self reloadDataForMessage:message];
        return Nil;
    }, Nil);
    
    [tableView_ setEditing:NO animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

// This only works for iOS8
-(NSArray *)tableView:(UITableView *)tableView_ editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak __typeof__(self) weakSelf = self;

    id<PElmMessage> message = [self messageForIndexPath:indexPath];
    if (message.senderIsMe) {
        UITableViewRowAction * button = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                                                           title:NSLocalizedString(@"Delete", nil)
                                                                         handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
            [BChatSDK.moderation deleteMessage:message.entityID];
        }];
        
        button.backgroundColor = [UIColor redColor];
        return @[button];

    }
    else {
        NSString * flagTitle = message.flagged.intValue ? [NSBundle t:bUnflag] : [NSBundle t:bFlag];
        
        UITableViewRowAction * button = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:flagTitle handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
            __typeof__(self) strongSelf = weakSelf;
            [strongSelf.delegate setMessageFlagged:message isFlagged:message.flagged.intValue].thenOnMain(^id(id success) {
                // Reload the tableView and not [self reloadData] so we don't go to the bottom of the tableView
                [strongSelf reloadDataForMessage:message];
                return Nil;
            }, Nil);
            
        }];
        
        button.backgroundColor = message.flagged.intValue ? [UIColor darkGrayColor] : [UIColor redColor];
        
        return @[button];
    }
    
}

#pragma Handle keyboard

// Move the toolbar up
-(void) keyboardWillShow: (NSNotification *) notification {
    
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

    float contentOffsetY = tableView.contentOffset.y + keyboardBoundsConverted.size.height - self.safeAreaBottomInset;

    [tableView setContentOffset:CGPointMake(0, contentOffsetY)];

    [UIView setAnimationsEnabled:NO];
    for(UITableViewCell * cell in tableView.visibleCells) {
        [cell layoutIfNeeded];
    }
    [UIView setAnimationsEnabled:YES];


    [self.view layoutIfNeeded];

    [UIView commitAnimations];
    
}

-(void) keyboardWillHide: (NSNotification *) notification {
    
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

    float contentOffsetY = tableView.contentOffset.y - keyboardBoundsConverted.size.height + self.safeAreaBottomInset;
    [tableView setContentOffset:CGPointMake(0, contentOffsetY)];

    [self.view layoutIfNeeded];

    [UIView commitAnimations];
    
    // Disable the gesture recognizer so cell taps are recognized
    _tapRecognizer.enabled = NO;
    
}

-(void) keyboardDidShow: (NSNotification *) notification {
    
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

-(void) keyboardDidHide: (NSNotification *) notification {
    [_keyboardOverlay removeFromSuperview];
    _keyboardVisible = NO;
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
        [UIView transitionWithView: self.tableView
                          duration: animate ? 0.2f : 0
                           options: UIViewAnimationOptionTransitionCrossDissolve
                        animations: ^(void) {
                            NSLog(@"Reload %@", NSStringFromSelector(_cmd));
                            [self.tableView reloadData];
                        }
                        completion: ^(BOOL finished) {
                            if (scroll) {
                                [self scrollToBottomOfTable:animate force:force];
                            }
                        } ];
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

-(void) dataUpdated {
    [tableView reloadData];
    [self scrollToBottomOfTable:YES];
}

- (void) navigationBarTapped {
    
    [delegate navigationBarTapped];
}

- (void) openInviteScreen {
   // [delegate openInviteScreen];
}

-(void)leaveChat {
}

-(void) addUser {
}

-(void)leaveGroupAction {
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: NSLocalizedString(@"leave_chat_title", nil)
                                                                              message: NSLocalizedString(@"leave_chat_subtitle", nil)
                                                                       preferredStyle:UIAlertControllerStyleAlert];
  
    
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"leave", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self leaveChat];
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void) setThreadName: (NSString *)updatedName {
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
    [_typingTimer invalidate];
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
