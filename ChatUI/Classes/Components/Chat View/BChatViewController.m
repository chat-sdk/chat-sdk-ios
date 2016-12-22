//
//  BChatViewController.m
//  Chat SDK
//
//  Created by Benjamin Smiley-andrews on 21/09/2013.
//  Copyright (c) 2013 deluge. All rights reserved.
//

#import "BChatViewController.h"

#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

#import <ChatSDK/ChatUI.h>
#import <ChatSDK/ChatCore.h>

@interface BChatViewController ()

@end

@implementation BChatViewController

@synthesize tableView;
@synthesize controller;
@synthesize _stickerView;

- (id)initWithThread: (id<PThread>) thread
{
    self = [super initWithNibName:@"BChatViewController" bundle:[NSBundle chatUIBundle]];
    if (self) {
        
        _thread = thread;
        
//        if (bLimitNumberOfMessagesTo > 0) {
//            NSArray * array = _thread.messagesOrderedByDateDesc;
//            int count = array.count;
//            for (int i = bLimitNumberOfMessagesTo; i < count; i++) {
//                [array[i] setThread:Nil];
//                [[BStorageManager sharedManager].adapter deleteEntity:array[i]];
//            }
//        }
        
        // Set the title
        self.title = _thread.displayName ? _thread.displayName : [NSBundle t: bDefaultThreadName];
        
        // Add a tap recognizer so when we tap the table
        // we dismiss the keyboard
        _tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped)];
        _tapRecognizer.enabled = NO;
        [self.view addGestureRecognizer:_tapRecognizer];
        
        // Observe for keyboard appear and disappear notifications
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:Nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:Nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:Nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:Nil];
        
        // Mark all messages as read
//        [thread.model markRead];
        [[BNetworkManager sharedManager].a.readReceipt markRead:thread.model];
        
        UITapGestureRecognizer * titleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loadUsersView)];
        [self.navigationItem.titleView addGestureRecognizer:titleTapRecognizer];

    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _navigationBarSubtitleText = [NSBundle t: bTapHereForContactInfo];
    if (_thread.type.intValue == bThreadType1to1) {
        if([BNetworkManager sharedManager].a.lastOnline) {
            [[BNetworkManager sharedManager].a.lastOnline getLastOnlineForUser:_thread.otherUser].thenOnMain(^id(NSDate * date) {
                _navigationBarSubtitleText = date.lastSeenTimeAgo;
                [self setNavigationBarSubtitle:Nil];
                
                return Nil;
            }, Nil);
        }
    }
    
    
    // Keep the table header at the top
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.automaticallyAdjustsScrollViewInsets = YES;
    }
    
    // Disable the swipe left to go back
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    // Add an extra 5 px padding between the top of the table and the navigation bar
    // just to give the top message a bit more space
    UIEdgeInsets tableInsets = tableView.contentInset;
    tableInsets.top += 5;
    tableView.contentInset = tableInsets;
    
    // Add a toolbar at bottom to allow messages to be composed
    //
    _textInputView = [[BTextInputView alloc] init];
    _textInputView.messageDelegate = self;
    [_textInputView setAudioEnabled: [BNetworkManager sharedManager].a.audioMessage != Nil];
    
    [self.view addSubview:_textInputView];
    
    _textInputView.keepBottomInset.equal = 0;
    _textInputView.keepLeftInset.equal = 0;
    _textInputView.keepRightInset.equal = 0;
    
    // Constrain the table to the top of the toolbar
    tableView.keepBottomOffsetTo(_textInputView).equal =  -_textInputView.fh;
    [self setTableViewBottomContentInset:_textInputView.fh];
    
    [self.tableView registerClass:[BTextMessageCell class] forCellReuseIdentifier:bTextMessageCell];
    [self.tableView registerClass:[BImageMessageCell class] forCellReuseIdentifier:bImageMessageCell];
    [self.tableView registerClass:[BLocationCell class] forCellReuseIdentifier:bLocationMessageCell];
    [self.tableView registerClass:[BSystemMessageCell class] forCellReuseIdentifier:bSystemMessageCell];
   
#ifdef ChatSDKAudioMessagesModule
    if([BNetworkManager sharedManager].a.audioMessage) {
        [self.tableView registerClass:[BNetworkManager sharedManager].a.audioMessage.messageCellClass forCellReuseIdentifier:bAudioMessageCell];
    }
#endif

#ifdef ChatSDKVideoMessagesModule
    if([BNetworkManager sharedManager].a.videoMessage) {
        [self.tableView registerClass:[BNetworkManager sharedManager].a.videoMessage.messageCellClass forCellReuseIdentifier:bVideoMessageCell];
    }
#endif

#ifdef ChatSDKStickerMessagesModule
    if([BNetworkManager sharedManager].a.stickerMessage) {
        [self.tableView registerClass:[BNetworkManager sharedManager].a.stickerMessage.messageCellClass forCellReuseIdentifier:bStickerMessageCell];
    }
#endif

    
    _refreshControl = [[UIRefreshControl alloc] init];
    [_refreshControl addTarget:self action:@selector(loadMoreMessages) forControlEvents:UIControlEventValueChanged];
    [tableView addSubview:_refreshControl];
    
    // Hide the tab bar when the messages are shown
    self.hidesBottomBarWhenPushed = YES;

    
    // When a user types in a thread they get added to the typing users in that thread
    // This sends a notification to add them to the list
    // If they click send or stop typing for 5 seconds then it is removed
    // Set the title

    UIView * containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 220, 40)];
    
    UILabel * titleLabel = [[UILabel alloc] init];
    titleLabel.text = _thread.displayName ? _thread.displayName : [NSBundle t: bThread];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:titleLabel.font.pointSize];
    
    [containerView addSubview:titleLabel];
    titleLabel.keepInsets.equal = 0;
    titleLabel.keepBottomInset.equal = 10;
    
    _navigationBarSubtitle = [[UILabel alloc] init];
    _navigationBarSubtitle.textAlignment = NSTextAlignmentCenter;
    _navigationBarSubtitle.font = [UIFont italicSystemFontOfSize:12.0];
    _navigationBarSubtitle.textColor = [UIColor lightGrayColor];
    
    [containerView addSubview:_navigationBarSubtitle];
    
    _navigationBarSubtitle.keepHeight.equal = 15;
    _navigationBarSubtitle.keepWidth.equal = 200;
    _navigationBarSubtitle.keepBottomInset.equal = 0;
    _navigationBarSubtitle.keepHorizontalCenter.equal = 0.5;
    
    [self setNavigationBarSubtitle:Nil];
    
    [self.navigationItem setTitleView:containerView];
    
    [self updateInterfaceForReachabilityStateChange];
    
    _keyboardOverlay = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.fh, self.view.fw, 0)];
    _keyboardOverlay.backgroundColor = [UIColor whiteColor];

    _optionsHandler = [[BInterfaceManager sharedManager].a chatOptionsHandlerWithChatViewController:self];
    [_optionsHandler setDelegate: self];
    
    if(_optionsHandler.keyboardView) {
        [_keyboardOverlay addSubview:_optionsHandler.keyboardView];
        _optionsHandler.keyboardView.keepInsets.equal = 0;
    }

    _keyboardOverlay.alpha = 0;
    _keyboardOverlay.userInteractionEnabled = NO;

}

-(void) loadMoreMessages {
    [[BNetworkManager sharedManager].a.core loadMoreMessagesForThread:_thread].thenOnMain(^id(NSArray * messages) {
        _messageCacheDirty = YES;
        [tableView reloadData];
        [_refreshControl endRefreshing];
        return Nil;
    },^id(NSError * error) {
        // Make the refresh control disappear if there are no messages to load
        [_refreshControl endRefreshing];
        return Nil;
    });
}

-(void) setNavigationBarSubtitle: (NSString *) subtitle {
    if (subtitle && subtitle.length) {
        _navigationBarSubtitle.text = subtitle;
    }
    else {
        if (_thread.type.intValue & bThreadTypeGroup) {
            _navigationBarSubtitle.text = _thread.memberListString;
        }
        else {
            _navigationBarSubtitle.text = _navigationBarSubtitleText;
        }
    }
}

-(void) addObservers {
    [self removeObservers];
    
    id<PUser> currentUserModel = [BNetworkManager sharedManager].a.core.currentUserModel;

    _readReceiptObserver = [[NSNotificationCenter defaultCenter] addObserverForName:bNotificationReadReceiptUpdated object:Nil queue:Nil usingBlock:^(NSNotification * notification) {
        _messageCacheDirty = YES;
        [tableView reloadData];
    }];

    _messageObserver = [[NSNotificationCenter defaultCenter] addObserverForName:bNotificationMessageAdded object:Nil queue:Nil usingBlock:^(NSNotification * notification) {
        _messageCacheDirty = YES;
        
        id<PMessage> messageModel = notification.userInfo[bNotificationMessageAddedKeyMessage];
        
        if (![messageModel.thread isEqual:_thread.model] && [currentUserModel.threads containsObject:_thread] && messageModel) {
            
            // If we are in chat and receive a message in another chat then vibrate the phone
            if (![messageModel.userModel isEqual:currentUserModel]) {
                AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
            }
        }
        else {
            [self reloadData];
            [[BNetworkManager sharedManager].a.readReceipt markRead:_thread.model];
            //[_thread.model markRead];
        }
        
        messageModel.delivered = @YES;
    }];
    _userObserver = [[NSNotificationCenter defaultCenter] addObserverForName:bNotificationUserUpdated object:Nil queue:Nil usingBlock:^(NSNotification * notification) {
        _messageCacheDirty = YES;
        [tableView reloadData];
    }];
    
    _typingObserver = [[NSNotificationCenter defaultCenter] addObserverForName:bNotificationTypingStateChanged object:nil queue:Nil usingBlock:^(NSNotification * notification) {
        id<PThread> thread = notification.userInfo[bNotificationTypingStateChangedKeyThread];
        if ([thread isEqual: _thread]) {
            [self setNavigationBarSubtitle:notification.userInfo[bNotificationTypingStateChangedKeyMessage]];
        }
    }];
    
    // TODO: Check this
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateInterfaceForReachabilityStateChange)
                                                 name:kReachabilityChangedNotification
                                               object:Nil];
    
    _threadUsersObserver = [[NSNotificationCenter defaultCenter] addObserverForName:bNotificationThreadUsersUpdated object:Nil queue:Nil usingBlock:^(NSNotification * notification) {
        [self setNavigationBarSubtitle:Nil];
    }];

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
    
    self.tabBarController.tabBar.hidden = YES;
    
    [self addObservers];
    
    // The user's read the messages
    [_thread markRead];
    
    // This scrolls the tableview almost to the bottom
    // This happens because autolayout hasn't yet been
    // layed out
    // The effect that this gives is that the
    // view starts off almost at the bottom and
    // scrolls the last bit animated (viewDidAppear)
    [self scrollToBottomOfTable:NO];
    
    [self setChatState:bChatStateActive];
    
    _usersViewLoaded = NO;
    
    // Add an observer to detect if the app enters the foreground - if this happens we want to add the user to the public thread
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewDidAppear:) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    [self reloadData];
}

-(void) removeObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:_messageObserver];
    [[NSNotificationCenter defaultCenter] removeObserver:_userObserver];
    [[NSNotificationCenter defaultCenter] removeObserver:_typingObserver];
    [[NSNotificationCenter defaultCenter] removeObserver:_threadUsersObserver];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:Nil];
}

-(void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    

    //[self scrollToBottomOfTable:NO];
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
 
    // For public threads we add the user when we view the thread
    // TODO: This is called multiple times... maybe move it to view did load
    if (_thread.type.intValue & bThreadTypePublic) {
        id<PUser> user = [BNetworkManager sharedManager].a.core.currentUserModel;
        [[BNetworkManager sharedManager].a.core addUsers:@[user] toThread:_thread];
    }
    
    [self scrollToBottomOfTable:YES];
}

-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // The user's read the messages
    [_thread markRead];
    [self removeObservers];
    
    // Remove the user from the thread
    if (_thread.type.intValue & bThreadTypePublic && !_usersViewLoaded) {
        id<PUser> currentUser = [BNetworkManager sharedManager].a.core.currentUserModel;
        [[BNetworkManager sharedManager].a.core removeUsers:@[currentUser] fromThread:_thread];
    }

    // Typing Indicator
    // When the user leaves then automatically set them not to be typing in the thread
    [self userFinishedTypingWithState: bChatStateInactive];

}

-(void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    // Remove the observer when we leave the thread so the function isn't called when returning from foreground when not in chat view
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)dealloc {
    NSLog(@"Dealloc");
}

// When the view is tapped - dismiss the keyboard
-(void) viewTapped {
    [self hideKeyboard];
}

#pragma TableView delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView_ cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id<PMessage, PMessageLayout> message = self.messages[indexPath.row];
    
    BMessageCell<BMessageDelegate> * messageCell;
    
    NSString * cellIdentifier = Nil;
    switch (message.type.intValue) {
        case bMessageTypeText:
            cellIdentifier = bTextMessageCell;
            break;
        case bMessageTypeImage:
            cellIdentifier = bImageMessageCell;
            break;
        case bMessageTypeLocation:
            cellIdentifier = bLocationMessageCell;
            break;
        case bMessageTypeAudio:
            cellIdentifier = bAudioMessageCell;
            break;
        case bMessageTypeVideo:
            cellIdentifier = bVideoMessageCell;
            break;
        case bMessageTypeSticker:
            cellIdentifier = bStickerMessageCell;
            break;
        case bMessageTypeSystem:
            cellIdentifier = bSystemMessageCell;
            break;
        default:
            break;
    }
    
    messageCell = [tableView_ dequeueReusableCellWithIdentifier:cellIdentifier];
    messageCell.navigationController = self.navigationController;
    
    // Add a gradient to the cells
    float colorWeight = ((float) indexPath.row / (float) self.messages.count) * 0.15 + 0.85;
    
    [messageCell setMessage:message withColorWeight:colorWeight];
    
    return messageCell;
}

// A little bit of optimization
-(NSArray *) messages {
    if (!_messageCache || !_messageCache.count || _messageCacheDirty) {
        _messageCache = [_thread messagesOrderedByDateAsc];
        _messageCacheDirty = NO;
    }
    return _messageCache;
}

// Layout out the bubbles. Do this after the cell's been made so we have
// access to the cell dimensions
-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [((UITableViewCell<BMessageDelegate> *) cell) willDisplayCell];
    
}

// Set the message height based on the text height
- (CGFloat)tableView:(UITableView *)tableView_ heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.messages && self.messages.count > indexPath.row) {
        id<PMessage> message = self.messages[indexPath.row];
        id<PMessageLayout> l = [BMessageLayout layoutWithMessage:message];
        return l.cellHeight;
    }
    else {
        return 0;
    }
}

- (void)tableView:(UITableView *)tableView_ didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BMessageCell * cell = (BMessageCell *) [tableView_ cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:[BImageMessageCell class]]) {
        
        if (!_imageViewController) {
            _imageViewController = [[BImageViewController alloc] initWithNibName:nil bundle:Nil];
            _imageViewNavigationController = [[UINavigationController alloc] initWithRootViewController:_imageViewController];
        }

        // Only allow the user to click if the image is not still loading hence the alpha is 1
        if (cell.imageView.alpha == 1) {
            
            // TODO: Refactor this to use the JSON keys
            NSArray * myArray = [cell.message.textString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]];
            NSURL * url = [NSURL URLWithString:myArray[1]];
            
            // Add an activity indicator while the image is loading
            UIActivityIndicatorView * activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            activityIndicator.frame = CGRectMake(cell.imageView.fw/2 - 20, cell.imageView.fh/2 -20, 40, 40);
            [activityIndicator startAnimating];
            
            [cell.imageView addSubview:activityIndicator];
            [cell.imageView bringSubviewToFront:activityIndicator];
            cell.imageView.alpha = 0.75;
            
            [cell.imageView sd_setImageWithURL:url placeholderImage:cell.imageView.image completed: ^(UIImage * image, NSError * error, SDImageCacheType cacheType, NSURL * imageURL) {
                
                // Then remove it here
                [activityIndicator stopAnimating];
                [activityIndicator removeFromSuperview];
                cell.imageView.alpha = 1;
                
                _imageViewController.image = image;
                [self.navigationController presentViewController:_imageViewNavigationController animated:YES completion:Nil];
            }];
        }
    }
    if ([cell isKindOfClass:[BLocationCell class]]) {
        if (!_locationViewController) {
            _locationViewController = [[BLocationViewController alloc] initWithNibName:nil bundle:Nil];
            _locationViewNavigationController = [[UINavigationController alloc] initWithRootViewController:_locationViewController];
        }
        
        CLLocationCoordinate2D coord = [BCoreUtilities locationForString: cell.message.textString];
        
        // Set the location and display the controller
        _locationViewController.region = [BCoreUtilities regionForLongitude:coord.longitude latitude:coord.latitude];
        _locationViewController.annotation = [BCoreUtilities annotationForLongitude:coord.longitude latitude:coord.latitude];

        [self.navigationController presentViewController:_locationViewNavigationController animated:YES completion:Nil];
    }
    
#ifdef ChatSDKVideoMessagesModule
    if([BNetworkManager sharedManager].a.videoMessage) {
        if ([cell isKindOfClass:[BNetworkManager sharedManager].a.videoMessage.messageCellClass]) {
            
            // Only allow the user to click if the image is not still loading hence the alpha is 1
            if (cell.imageView.alpha == 1) {
                
                // TODO: Refactor this to use JSON keys
                NSArray * myArray = [cell.message.textString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]];
                NSURL * url = [NSURL URLWithString:myArray[0]];
                
                // Add an activity indicator while the image is loading
                UIActivityIndicatorView * activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                activityIndicator.frame = CGRectMake(cell.imageView.fw/2 - 20, cell.imageView.fh/2 -20, 40, 40);
                [activityIndicator startAnimating];
                
                [cell.imageView addSubview:activityIndicator];
                [cell.imageView bringSubviewToFront:activityIndicator];
                
                // Initialize the MPMoviePlayerController object using url
                _videoPlayer = [[MPMoviePlayerController alloc] initWithContentURL:url];
                
                // Set control style to default
                _videoPlayer.controlStyle = MPMovieControlStyleDefault;
                _videoPlayer.shouldAutoplay = YES;
                
                [self.view addSubview:_videoPlayer.view];
                
                [_videoPlayer setFullscreen:YES animated:YES];
                
                /*
                 if (!cell.message.attachmentDownloaded) {
                 
                 // To download the video we need to download it into our documents to a temporary location before saving to
                 NSURLSessionTask * download = [[NSURLSession sharedSession] downloadTaskWithURL:url completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
                 NSURL *documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject];
                 NSURL *tempURL = [documentsURL URLByAppendingPathComponent:[url lastPathComponent]];
                 [[NSFileManager defaultManager] moveItemAtURL:location toURL:tempURL error:nil];
                 UISaveVideoAtPathToSavedPhotosAlbum(tempURL.path, self, nil, nil);
                 }];
                 
                 [download resume];
                 }*/
            }
        }
    }
#endif

}

#pragma Message Delegate

-(void) sendText: (NSString *) message {

    // Typing indicator
    // Once a user sends a message they are no longer typing
    [self userFinishedTypingWithState: bChatStateActive];
    
    NSString * newMessage = [message stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    [self handleSendError:[[BNetworkManager sharedManager].a.core sendMessageWithText:newMessage
                                      withThreadEntityID:_thread.entityID]];
    [self reloadData];
}

-(void) sendImage: (UIImage *) image {
    
    // This may be called from another view so make sure we're registered as
    // a network activity listener
    [self addObservers];
    
    if ([BNetworkManager sharedManager].a.imageMessage) {
        [self handleSendError:[[BNetworkManager sharedManager].a.imageMessage sendMessageWithImage:image
                                                          withThreadEntityID:_thread.entityID]];
    }
    [self reloadData];
}

-(void) handleSendError: (RXPromise *) promise {
    promise.thenOnMain(Nil, ^id(NSError * error) {
        [[BNetworkManager sharedManager].a.core sendLocalSystemMessageWithText:error.localizedDescription
                                                                          type:bSystemMessageTypeError
                                                            withThreadEntityID:_thread.entityID];
        
        return Nil;
    });
}

-(void) sendAudio: (NSData *) data duration: (double) seconds {
    
    if (seconds > 2) {
        if ([BNetworkManager sharedManager].a.audioMessage) {
            [self handleSendError:[[BNetworkManager sharedManager].a.audioMessage sendMessageWithAudio:data
                                                                        duration:seconds
                                                              withThreadEntityID:_thread.entityID]];
        }
    }
    else {
        [UIView alertWithTitle:[NSBundle t:bErrorTitle]
                   withMessage:[NSBundle t: bHoldToSendAudioMessageError]];
    }
    
    [self reloadData];
}

-(void) sendVideo: (NSData *) data coverImage: (UIImage *) image {
    [self addObservers];
    if ([BNetworkManager sharedManager].a.videoMessage) {
        [self handleSendError:[[BNetworkManager sharedManager].a.videoMessage sendMessageWithVideo:data
                                                           coverImage:image
                                                   withThreadEntityID:_thread.entityID]];
    }
    
    [self reloadData];
}

- (void) sendSticker: (NSString *)stickerName {

    [[BNetworkManager sharedManager].a.stickerMessage sendMessageWithSticker:stickerName
                                                          withThreadEntityID:_thread.entityID];
    
    [self reloadData];
}

-(BOOL) showOptions {
    [_textInputView becomeFirstResponder];
    
    if (_optionsHandler.keyboardView) {
        _keyboardOverlay.alpha = 1;
        _keyboardOverlay.userInteractionEnabled = YES;
    }
    
    return [_optionsHandler show];
}

-(BOOL) hideOptions {
    [_textInputView becomeFirstResponder];
    _keyboardOverlay.alpha = 0;
    _keyboardOverlay.userInteractionEnabled = NO;
    return [_optionsHandler hide];
}

-(void) hideKeyboard {
    [_textInputView resignFirstResponder];
}

#pragma BChatOptionDelegate

-(id<PThread>) currentThread {
    return _thread;
}

-(UIViewController *) currentViewController {
    return self;
}

-(void) chatOptionActionExecuted:(RXPromise *)promise {
    [self handleSendError:promise];
    promise.thenOnMain(^id(id success) {
        [self reloadData];
        return Nil;
    }, Nil);
}

#pragma  Picture selection


-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id<PMessage> message = self.messages[indexPath.row];
    
    return message.flagged.intValue ? bUnflag : [NSBundle t:bFlag];
}

// Check that this is called for iOS7
- (void)tableView:(UITableView *)tableView_ commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id<PMessage> message = self.messages[indexPath.row];
    
    if (message.flagged.intValue) {
        [[BNetworkManager sharedManager].a.moderation unflagMessage:message.entityID].thenOnMain(^id(id success) {
            [tableView_ reloadData]; // Reload the tableView and not [self reloadData] so we don't go to the bottom of the tableView
            return Nil;
        }, Nil);
    }
    else {
        [[BNetworkManager sharedManager].a.moderation flagMessage:message.entityID].thenOnMain(^id(id success) {
            [tableView_ reloadData]; // Reload the tableView and not [self reloadData] so we don't go to the bottom of the tableView
            return Nil;
        }, Nil);
    }
    
    [tableView_ setEditing:NO animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // We can only flag posts in public threads
    return _thread.type.intValue & bThreadTypePublic ? YES : NO;
}

// This only works for iOS8
-(NSArray *)tableView:(UITableView *)tableView_ editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id<PMessage> message = self.messages[indexPath.row];
    
    NSString * flagTitle = message.flagged.intValue ? [NSBundle t:bUnflag] : [NSBundle t:bFlag];
    
    UITableViewRowAction * button = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:flagTitle handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        
        if (message.flagged.intValue) {
            [[BNetworkManager sharedManager].a.moderation unflagMessage:message.entityID].thenOnMain(^id(id success) {
                [tableView_ reloadData]; // Reload the tableView and not [self reloadData] so we don't go to the bottom of the tableView
                return Nil;
            }, Nil);

        }
        else {
            [[BNetworkManager sharedManager].a.moderation flagMessage:message.entityID].thenOnMain(^id(id success) {
                [tableView_ reloadData]; // Reload the tableView and not [self reloadData] so we don't go to the bottom of the tableView
                return Nil;
            }, Nil);

        }
    }];
    
    button.backgroundColor = message.flagged.intValue ? [UIColor greenColor] : [UIColor orangeColor]; //arbitrary color
    
    return @[button];
}

#pragma Handle keyboard

// Move the toolbar up
-(void) keyboardWillShow: (NSNotification *) notification {
    
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
    _textInputView.keepBottomInset.equal = keyboardBoundsConverted.size.height;
    
    [[UIApplication sharedApplication].windows.lastObject addSubview: _keyboardOverlay];
    _keyboardOverlay.frame = keyboardBounds;
    
    // Animate using this style because for some reason
    // using blocks doesn't give a smooth animation
    [UIView beginAnimations:Nil context:Nil];
    
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:duration.doubleValue];
    [UIView setAnimationCurve:curve.integerValue];
    
    [self.view layoutIfNeeded];

    [UIView commitAnimations];
    
    // Set the scroll view to the last message
    [self scrollToBottomOfTable:NO];
    
}

-(void) keyboardDidShow: (NSNotification *) notification {

    // Get the keyboard size
    CGRect keyboardBounds = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect keyboardBoundsConverted = [self.view convertRect:keyboardBounds toView:Nil];

    // Once the keyboard appears we remove the constraint to the toolbar
    // and add y displacement by adding an offset instead. This allows
    // the messages to scroll under the keyboard
    [UIView animateWithDuration:0.3 animations:^ {
        [self setTableViewBottomContentInset:keyboardBoundsConverted.size.height + _textInputView.fh];
        [tableView.keepBottomOffsetTo(_textInputView) remove];
    }];
    
    // Enable the tap gesture recognizer to hide the keyboard
    _tapRecognizer.enabled = YES;
}

-(void) keyboardWillHide: (NSNotification *) notification {
    
    NSNumber *duration = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    CGRect keyboardBounds = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    _keyboardOverlay.frame = keyboardBounds;

    _textInputView.keepBottomInset.equal = 0;
    [self.view setNeedsUpdateConstraints];
    
    [UIView beginAnimations:Nil context:Nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:duration.doubleValue];
    [UIView setAnimationCurve:curve.integerValue];
    
    [self.view layoutIfNeeded];
    
    // Set the inset so it's correct when we animate back to normal
    [self setTableViewBottomContentInset:_textInputView.fh];

    [UIView commitAnimations];
    
    // Disable the gesture recognizer so cell taps are recognized
    _tapRecognizer.enabled = NO;
    
}

-(void) keyboardDidHide: (NSNotification *) notification {
    // Do the reverse process to above. So the table sticks back to
    // the toolbar again
    tableView.keepBottomOffsetTo(_textInputView).equal = -_textInputView.fh;
    [_keyboardOverlay removeFromSuperview];

}

-(void) setTableViewBottomContentInset: (float) inset {
    UIEdgeInsets insets = tableView.contentInset;
    insets.bottom = inset;
    tableView.contentInset = insets;
}

-(void) scrollToBottomOfTable: (BOOL) animated {
    NSInteger lastSection = tableView.numberOfSections - 1;
    if (lastSection < 0) {
        return;
    }
    NSInteger lastRow = [tableView numberOfRowsInSection:lastSection] - 1;
    if (lastRow < 0) {
        return;
    }
    
    [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:lastRow inSection:lastSection] atScrollPosition:UITableViewScrollPositionBottom animated:animated];
}

-(void) reloadData {
    _messageCacheDirty = YES;
    [tableView reloadData];
    [self scrollToBottomOfTable:YES];
}

#pragma Utility Methods

-(void) dataUpdated {
    [tableView reloadData];
    [self scrollToBottomOfTable:YES];
}

- (void)loadUsersView {
    
    _usersViewLoaded = YES;
    
    NSMutableArray * users = [NSMutableArray arrayWithArray: _thread.model.users.allObjects];
    [users removeObject:[BNetworkManager sharedManager].a.core.currentUserModel];
    
    BUsersViewController * vc = [[BUsersViewController alloc] initWithThread:_thread];
    vc.parentNavigationController = self.navigationController;
    
    UINavigationController * nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nvc animated:YES completion:nil];
}

- (void)updateInterfaceForReachabilityStateChange {
    BOOL connected = [Reachability reachabilityForInternetConnection].isReachable;
    self.navigationItem.rightBarButtonItem.enabled = connected;
}

-(void) userFinishedTyping {
    [self userFinishedTypingWithState:bChatStateActive];
}

-(void) setChatState: (bChatState) state {
    if (state != _chatState) {
        [[BNetworkManager sharedManager].a.typingIndicator setChatState: state forThread: _thread];
    }
    _chatState = state;
}

-(void) userFinishedTypingWithState: (bChatState) state {
    [self setChatState:state];
    [_typingTimer invalidate];
}

@end
