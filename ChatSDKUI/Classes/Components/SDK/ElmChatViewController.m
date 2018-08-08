//
//  BChatViewController.m
//  Chat SDK
//
//  Created by Benjamin Smiley-andrews on 21/09/2013.
//  Copyright (c) 2013 deluge. All rights reserved.
//

#import "ElmChatViewController.h"

#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

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

-(instancetype) initWithDelegate: (id<ElmChatViewDelegate>) delegate_
{
    self.delegate = delegate_;
    self = [super initWithNibName:@"BChatViewController" bundle:[NSBundle uiBundle]];
    if (self) {
        
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
    }
    return self;
}

// The text input view sits on top of the keyboard
-(void) setupTextInputView {
    _sendBarView = [[BInterfaceManager sharedManager].a sendBarView];
    [_sendBarView setSendBarDelegate:self];
    
    [self.view addSubview:_sendBarView];
    
//    [_sendBarView.bottomAnchor constraintEqualToAnchor:self.view.layoutMarginsGuide.bottomAnchor constant:0];

    _sendBarView.keepBottomInset.equal = [self textInputViewBottomInset];
    _sendBarView.keepLeftInset.equal = 0;
    _sendBarView.keepRightInset.equal = 0;
    
    // Constrain the table to the top of the toolbar
    tableView.keepBottomOffsetTo(_sendBarView).equal = -_sendBarView.fh;
    [self setTableViewBottomContentInset:_sendBarView.fh];
}

-(void) registerMessageCells {
    
    // Default message types
    
    [self.tableView registerClass:[BTextMessageCell class] forCellReuseIdentifier:@(bMessageTypeText).stringValue];
    [self.tableView registerClass:[BImageMessageCell class] forCellReuseIdentifier:@(bMessageTypeImage).stringValue];
    [self.tableView registerClass:[BLocationCell class] forCellReuseIdentifier:@(bMessageTypeLocation).stringValue];
    [self.tableView registerClass:[BSystemMessageCell class] forCellReuseIdentifier:@(bMessageTypeSystem).stringValue];
    
    // Some optional message types
    if ([delegate respondsToSelector:@selector(customCellTypes)]) {
        for (NSArray * cell in delegate.customCellTypes) {
            [self.tableView registerClass:cell.firstObject forCellReuseIdentifier:[cell.lastObject stringValue]];
        }
    }
    
}

// The naivgation bar has three functions
// 1 - Shows the name of the chat
// 2 - Show's a message or the list of usersBTextInputView
// 3 - Show's who's typing
-(void) setupNavigationBar {
    
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

// The options handler is responsible for displaying options to the user
// when the options button is pressed. These can either be in an alert view
// or a collection view shown in the keyboard overlay
-(void) setupKeyboardOverlay {
    _keyboardOverlay = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.fh, self.view.fw, 0)];
    _keyboardOverlay.backgroundColor = [UIColor whiteColor];
    
    _optionsHandler = [[BInterfaceManager sharedManager].a chatOptionsHandlerWithDelegate:self];
    
    if(_optionsHandler.keyboardView) {
        [_keyboardOverlay addSubview:_optionsHandler.keyboardView];
        _optionsHandler.keyboardView.keepInsets.equal = 0;
    }
    
    _keyboardOverlay.alpha = 0;
    _keyboardOverlay.userInteractionEnabled = NO;
}

-(void) setTitle: (NSString *) title {
    _titleLabel.text = title;
}

-(void) setSubtitle: (NSString *) subtitle {
    _subtitleText = subtitle;
    _subtitleLabel.text = subtitle;
}

-(void) setMessages: (NSArray<BMessageSection *> *) messages {
    
    BOOL scroll = NO;   
    if ((tableView.contentSize.height - tableView.frame.size.height) - tableView.contentOffset.y <= bTableViewRefreshHeight) {
        scroll = YES;
    }
    
    [self setMessages:messages scrollToBottom:scroll];
}

-(void) setMessages: (NSArray<BMessageSection *> *) messages scrollToBottom: (BOOL) scroll {
    _messages = messages;
    [self.tableView reloadData];
    if (scroll) {
        [self scrollToBottomOfTable:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Large titles will interfere with the custom navigation bar
    self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;
    
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
    [self scrollToBottomOfTable:NO];
    
    [self setChatState:bChatStateActive];
    
    
    [self reloadData];
}

-(void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
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
    return _messages.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_messages[section] rowCount];
}

-(id<PElmMessage>) messageForIndexPath: (NSIndexPath *) path {
    return [_messages[path.section] messageForRow:path.row];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [_messages[section] view];
}

- (UITableViewCell *)tableView:(UITableView *)tableView_ cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id<PElmMessage> message = [self messageForIndexPath:indexPath];

    
    BMessageCell<BMessageDelegate> * messageCell;

    // We want to check if the message is a premium type but without the libraries added
    // Without this check the app crashes if the user doesn't have premium cell types
    if ((![BNetworkManager sharedManager].a.stickerMessage && message.type.integerValue == bMessageTypeSticker) ||
        (![BNetworkManager sharedManager].a.videoMessage && message.type.integerValue == bMessageTypeVideo) ||
        (![BNetworkManager sharedManager].a.audioMessage && message.type.integerValue == bMessageTypeAudio)) {
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
    [_notificationList add:[[NSNotificationCenter defaultCenter] addObserverForName:kReachabilityChangedNotification object:Nil queue:Nil usingBlock:^(NSNotification * notification) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf updateInterfaceForReachabilityStateChange];
        });
    }]];
    [_notificationList add:[[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillEnterForegroundNotification object:Nil queue:Nil usingBlock:^(NSNotification * notification) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf addUserToPublicThreadIfNecessary];
        });
    }]];
    
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
    if ([cell respondsToSelector:@selector(willDisplayCell)]) {
        [cell performSelector:@selector(willDisplayCell)];
    }
}

// Set the message height based on the text height
- (CGFloat)tableView:(UITableView *)tableView_ heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id<PElmMessage> message = [self messageForIndexPath:indexPath];
    if(message) {
        return [BMessageCell cellHeight:message maxWidth:[BMessageCell maxTextWidth:message]];
    }
    else {
        return 0;
    }
}

- (void)tableView:(UITableView *)tableView_ didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BMessageCell * cell = (BMessageCell *) [tableView_ cellForRowAtIndexPath:indexPath];
    
    if ([cell isKindOfClass:[BImageMessageCell class]]) {
        
        if (!_imageViewNavigationController) {
            _imageViewNavigationController = [[BInterfaceManager sharedManager].a imageViewNavigationController];
        }

        // Only allow the user to click if the image is not still loading hence the alpha is 1
        if (cell.imageView.alpha == 1) {
            
            // TODO: Refactor this to use the JSON keys
            NSURL * url = cell.message.imageURL;
            
            // Add an activity indicator while the image is loading
            UIActivityIndicatorView * activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            activityIndicator.frame = CGRectMake(cell.imageView.fw/2 - 20, cell.imageView.fh/2 -20, 40, 40);
            [activityIndicator startAnimating];
            
            [cell.imageView addSubview:activityIndicator];
            [cell.imageView bringSubviewToFront:activityIndicator];
            cell.imageView.alpha = 0.75;
            
            __weak __typeof__(self) weakSelf = self;
            [cell.imageView sd_setImageWithURL:url placeholderImage:cell.imageView.image completed: ^(UIImage * image, NSError * error, SDImageCacheType cacheType, NSURL * imageURL) {
                
                // Then remove it here
                [activityIndicator stopAnimating];
                [activityIndicator removeFromSuperview];
                cell.imageView.alpha = 1;
                
                [((id<PImageViewController>) _imageViewNavigationController.topViewController) setImage: image];
                [weakSelf.navigationController presentViewController:_imageViewNavigationController animated:YES completion:Nil];
            }];
        }
    }
    if ([cell isKindOfClass:[BLocationCell class]]) {
        if (!_locationViewNavigationController) {
            _locationViewNavigationController = [[BInterfaceManager sharedManager].a locationViewNavigationController];
        }
        
        float longitude = [[cell.message textAsDictionary][bMessageLongitude] floatValue];
        float latitude = [[cell.message textAsDictionary][bMessageLatitude] floatValue];
        
        [((id<PLocationViewController>) _locationViewNavigationController.topViewController) setLatitude:latitude longitude:longitude];

        [self.navigationController presentViewController:_locationViewNavigationController animated:YES completion:Nil];
    }
    
    if(NM.videoMessage) {
        if ([cell isKindOfClass:NM.videoMessage.messageCellClass]) {
            
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
                
            }
        }
    }

}

#pragma Message Delegate

-(RXPromise *) sendTextMessage: (NSString *) message withMeta: (NSDictionary *)meta {
    
    // Typing indicator
    // Once a user sends a message they are no longer typing
    [self userFinishedTypingWithState: bChatStateActive];
    
    NSString * newMessage = [message stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return [self handleMessageSend:[delegate  sendText:newMessage withMeta:meta]];
}

-(RXPromise *) sendTextMessage: (NSString *) message {
    return [self sendTextMessage:message withMeta:Nil];
}

-(RXPromise *) sendImageMessage: (UIImage *) image {
    [self addObservers];
    return [self handleMessageSend:[delegate sendImage: image]];
}

-(RXPromise *) handleMessageSend: (RXPromise *) promise {
    [self reloadData];
    return promise.thenOnMain(^id(id success) {
        [self scrollToBottomOfTable:YES];
        return Nil;
    }, ^id(NSError * error) {
        [self handleMessageSend:[delegate sendSystemMessage: error.localizedDescription]];
        return Nil;
    });
}

-(void) sendAudioMessage: (NSData *) data duration: (double) seconds {
    
    if (seconds > 1) {
        [self handleMessageSend:[delegate sendAudio:data withDuration:seconds]];
    }
    else {
        // TODO: Make the tost position above the text bar programatically
        [self.view makeToast:[NSBundle t:bHoldToSendAudioMessageError]
                    duration:2
                    position:[NSValue valueWithCGPoint: CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height - 120)]];

    }
    
    [self reloadData];
}

-(RXPromise *) sendVideoMessage: (NSData *) data withCoverImage: (UIImage *) image {
    [self addObservers];
    return [self handleMessageSend:[delegate sendVideo:data withCoverImage:image]];
}

- (RXPromise *) sendStickerMessage: (NSString *)stickerName {
    return [self handleMessageSend:[delegate sendSticker: stickerName]];
}

-(RXPromise *) sendLocationMessage: (CLLocation *) location {
    return [self handleMessageSend:[delegate sendLocation: location]];
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
    if (fabsf(delta) > 0.01) {
        [self setTableViewBottomContentInsetWithDelta:delta];
        [self scrollToBottomOfTable:NO];
    }
}

-(void) hideKeyboard {
    [_sendBarView resignTextViewFirstResponder];
}

#pragma BChatOptionDelegate

-(UIViewController *) currentViewController {
    return self;
}

// TODO: Change this to handleMessageSend
-(void) chatOptionActionExecuted:(RXPromise *)promise {
    
    [self handleMessageSend:promise];
    __weak __typeof__(self) weakSelf = self;
    promise.thenOnMain(^id(id success) {
        __typeof__(self) strongSelf = weakSelf;
        [strongSelf reloadData];
        return Nil;
    }, Nil);
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
        [tableView_ reloadData];
        return Nil;
    }, Nil);
    
    [tableView_ setEditing:NO animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // We can only flag posts in public threads
    id<PElmMessage> message = [self messageForIndexPath:indexPath];
    return ![message.userModel isEqual:NM.currentUser];
}

// This only works for iOS8
-(NSArray *)tableView:(UITableView *)tableView_ editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id<PElmMessage> message = [self messageForIndexPath:indexPath];
    
    NSString * flagTitle = message.flagged.intValue ? [NSBundle t:bUnflag] : [NSBundle t:bFlag];
    
    UITableViewRowAction * button = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:flagTitle handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        
        [delegate setMessageFlagged:message isFlagged:message.flagged.intValue].thenOnMain(^id(id success) {
            // Reload the tableView and not [self reloadData] so we don't go to the bottom of the tableView
            [tableView_ reloadData];
            return Nil;
        }, Nil);

    }];
    
    button.backgroundColor = message.flagged.intValue ? [UIColor darkGrayColor] : [UIColor redColor];
    
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
    _sendBarView.keepBottomInset.equal = keyboardBoundsConverted.size.height;
    
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
    __weak __typeof__(self) weakSelf = self;

    [UIView animateWithDuration:0.3 animations:^ {
        [weakSelf setTableViewBottomContentInset:keyboardBoundsConverted.size.height + _sendBarView.fh];
        [tableView.keepBottomOffsetTo(_sendBarView) deactivate];
    }];
    
    // Enable the tap gesture recognizer to hide the keyboard
    _tapRecognizer.enabled = YES;
}

-(void) keyboardWillHide: (NSNotification *) notification {
    
    NSNumber *duration = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    CGRect keyboardBounds = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    _keyboardOverlay.frame = keyboardBounds;
    
    _sendBarView.keepBottomInset.equal = [self textInputViewBottomInset];
    [self.view setNeedsUpdateConstraints];
    
    [UIView beginAnimations:Nil context:Nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:duration.doubleValue];
    [UIView setAnimationCurve:curve.integerValue];
    
    [self.view layoutIfNeeded];
    
    // Set the inset so it's correct when we animate back to normal
    [self setTableViewBottomContentInset:_sendBarView.fh];

    [UIView commitAnimations];
    
    // Disable the gesture recognizer so cell taps are recognized
    _tapRecognizer.enabled = NO;
    
}

-(float) textInputViewBottomInset {
    // Fix for the iPhone X
    // Move the text input up to avoid the bottom area
    if([UIScreen mainScreen].nativeBounds.size.height == 2436) {
        return 30;
    }
    return 0;
}

-(void) keyboardDidHide: (NSNotification *) notification {
    // Do the reverse process to above. So the table sticks back to
    // the toolbar again
    tableView.keepBottomOffsetTo(_sendBarView).equal = -_sendBarView.fh;
    [_keyboardOverlay removeFromSuperview];

}

-(void) setTableViewBottomContentInset: (float) inset {
    UIEdgeInsets insets = tableView.contentInset;
    insets.bottom = inset;
    tableView.contentInset = insets;
}

-(void) setTableViewBottomContentInsetWithDelta: (float) delta {
    UIEdgeInsets insets = tableView.contentInset;
    insets.bottom += delta;
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
    [tableView reloadData];
    [self scrollToBottomOfTable:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    float scrollViewHeight = scrollView.frame.size.height;
    float scrollContentSizeHeight = scrollView.contentSize.height;
    float scrollOffset = scrollView.contentOffset.y;
    
    if (scrollOffset == 0)
    {
        // then we are at the top
    }
    else if (scrollOffset + scrollViewHeight == scrollContentSizeHeight)
    {
        
    }
    if(scrollOffset < 50) {
    }
    if([delegate respondsToSelector:@selector(viewDidScroll:withOffset:)]) {
        [delegate viewDidScroll:scrollView withOffset:scrollOffset];
    }
}

#pragma Utility Methods

-(void) dataUpdated {
    [tableView reloadData];
    [self scrollToBottomOfTable:YES];
}

- (void) navigationBarTapped {
    
    [delegate navigationBarTapped];
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


@end
