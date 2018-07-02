//
//  BThreadsViewController.m
//  Chat SDK
//
//  Created by Benjamin Smiley-andrews on 24/09/2013.
//  Copyright (c) 2013 deluge. All rights reserved.
//

#import "BThreadsViewController.h"

#import <AudioToolbox/AudioToolbox.h>

#import <ChatSDK/Core.h>
#import <ChatSDK/UI.h>

#define bCellIdentifier @"bCellIdentifier"

@interface BThreadsViewController ()

@end

@implementation BThreadsViewController

@synthesize tableView;
@synthesize threads = _threads;

-(instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _threads = [NSMutableArray new];
        _threadTypingMessages = [NSMutableDictionary new];
        _notificationList = [BNotificationObserverList new];
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    [self updateButtonStatusForInternetConnection];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Setup the table view
    tableView = [[UITableView alloc] init];
    tableView.delegate = self;
    tableView.dataSource = self;
    
    [self.view addSubview:tableView];
    
    tableView.keepInsets.equal = 0;
    
    // Sets the back button for the thread views as back meaning we have more space for the title
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:[NSBundle t:bBack] style:UIBarButtonItemStylePlain target:nil action:nil];
    
    [tableView registerNib:[UINib nibWithNibName:@"BThreadCell" bundle:[NSBundle uiBundle]] forCellReuseIdentifier:bCellIdentifier];
    
}

-(void) addObservers {
    [self removeObservers];
    __weak __typeof__(self) weakSelf = self;

    [_notificationList add:[[NSNotificationCenter defaultCenter] addObserverForName:bNotificationMessageAdded
                                                                         object:Nil
                                                                          queue:Nil
                                                                     usingBlock:^(NSNotification * notification) {
                                                                         dispatch_async(dispatch_get_main_queue(), ^{
                                                                             id<PMessage> messageModel = notification.userInfo[bNotificationMessageAddedKeyMessage];
                                                                             messageModel.delivered = @YES;
                                                                             
                                                                             // This makes the phone vibrate when we get a new message
                                                                             
                                                                             // Only vibrate if a message is received from a private thread
                                                                             if (messageModel.thread.type.intValue & bThreadFilterPrivate) {
                                                                                 if (![messageModel.userModel isEqual:NM.currentUser]) {
                                                                                     AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
                                                                                 }
                                                                             }
                                                                             
                                                                             // Move thread to top
                                                                             [weakSelf reloadData];
                                                                         });
    }]];
    [_notificationList add:[[NSNotificationCenter defaultCenter] addObserverForName:bNotificationMessageRemoved
                                                                         object:Nil
                                                                          queue:Nil
                                                                     usingBlock:^(NSNotification * notification) {
                                                                         dispatch_async(dispatch_get_main_queue(), ^{
                                                                             [weakSelf reloadData];
                                                                         });
    }]];
    [_notificationList add:[[NSNotificationCenter defaultCenter] addObserverForName:bNotificationUserUpdated
                                                                      object:Nil
                                                                       queue:Nil
                                                                  usingBlock:^(NSNotification * notification) {
                                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                                          [weakSelf reloadData];
                                                                      });
    }]];
    [_notificationList add:[[NSNotificationCenter defaultCenter] addObserverForName:kReachabilityChangedNotification
                                                                                    object:nil
                                                                                     queue:Nil
                                                                                usingBlock:^(NSNotification * notification) {
                                                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                                                        [weakSelf updateButtonStatusForInternetConnection];
                                                                                    });
    }]];
    
    [_notificationList add:[[NSNotificationCenter defaultCenter] addObserverForName:bNotificationTypingStateChanged
                                                                        object:nil
                                                                         queue:Nil
                                                                    usingBlock:^(NSNotification * notification) {
                                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                                            id<PThread> thread = notification.userInfo[bNotificationTypingStateChangedKeyThread];
                                                                            _threadTypingMessages[thread.entityID] = notification.userInfo[bNotificationTypingStateChangedKeyMessage];
                                                                            [weakSelf reloadData];
                                                                        });
    }]];
    [_notificationList add:[[NSNotificationCenter defaultCenter] addObserverForName:bNotificationThreadDeleted
                                                                        object:Nil
                                                                         queue:Nil
                                                                    usingBlock:^(NSNotification * notification) {
                                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                                            [weakSelf reloadData];
                                                                        });
    }]];
}

-(void) removeObservers {
    [_notificationList dispose];
}

-(void) createThread {
    NSLog(@"This must be overridden");
    assert(NO);
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self addObservers];

    // Stop multiple touches opening multiple chat views
    [tableView setUserInteractionEnabled:YES];

    [self reloadData];
}


-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self removeObservers];
}


-(void) toggleEditing {
    [self setEditingEnabled:!tableView.editing];
}

-(void) setEditingEnabled: (BOOL) enabled {
    if (enabled) {
        [_editButton setTitle:[NSBundle t:bDone]];
    }
    else {
        [_editButton setTitle:[NSBundle t:bEdit]];
    }
    [tableView setEditing:enabled animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _threads.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView_ cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    BThreadCell * cell = [tableView_ dequeueReusableCellWithIdentifier:bCellIdentifier];
    
    id<PThread> thread = _threads[indexPath.row];
    
    NSDate * threadDate = thread.orderDate;
    
    NSString * text = [NSBundle t:bNoMessages];
    
    id<PMessage> lastMessage = thread.lazyLastMessage;
    if (lastMessage) {
        text = [NSBundle textForMessage:lastMessage];
    }
    
    if (threadDate) {
        cell.dateLabel.text = threadDate.threadTimeAgo;
    }
    else {
        cell.dateLabel.text = @"";
    }
    
    if([BChatSDK config].threadTimeFont) {
        cell.dateLabel.font = [BChatSDK config].threadTimeFont;
    }
    
    if([BChatSDK config].threadTitleFont) {
        cell.titleLabel.font = [BChatSDK config].threadTitleFont;
    }

    if([BChatSDK config].threadSubtitleFont) {
        cell.messageTextView.font = [BChatSDK config].threadSubtitleFont;
    }

    cell.titleLabel.text = thread.displayName ? thread.displayName : [NSBundle t: bDefaultThreadName];
        
    cell.profileImageView.image = thread.imageForThread;
    
//    cell.unreadView.hidden = !thread.unreadMessageCount;
    
    int unreadCount = thread.unreadMessageCount;
    cell.unreadMessagesLabel.hidden = !unreadCount;
    cell.unreadMessagesLabel.text = [@(unreadCount) stringValue];
    
    // Add the typing indicator
    NSString * typingText = _threadTypingMessages[thread.entityID];
    if (typingText && typingText.length) {
        [cell startTypingWithMessage:typingText];
    }
    else {
        [cell stopTypingWithMessage:text];
    }
    
    return cell;
}

-(void) tableView:(UITableView *)tableView_ didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id<PThread> thread = _threads[indexPath.row];
    [self pushChatViewControllerWithThread:thread];
    [tableView_ deselectRowAtIndexPath:indexPath animated:YES];
}

-(void) pushChatViewControllerWithThread: (id<PThread>) thread {
    if (thread) {
        UIViewController * vc = [[BInterfaceManager sharedManager].a chatViewControllerWithThread:thread];
        [self.navigationController pushViewController:vc animated:YES];
        // Stop multiple touches opening multiple chat views
        [tableView setUserInteractionEnabled:NO];
    }
}

// Fix divider lines not being full width on the iPad
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

// Called when a thread is to be deleted
- (void)tableView:(UITableView *)tableView_ commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *) indexPath {

    if (editingStyle == UITableViewCellEditingStyleDelete )
    {
        id<PThread> thread = _threads[indexPath.row];
        [NM.core deleteThread:thread];
        [self reloadData];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return !_slideToDeleteDisabled;
}

-(void) reloadData {
    [_threads sortUsingComparator:^(id<PThread>t1, id<PThread> t2) {
        return [t2.orderDate compare:t1.orderDate];
    }];
    [tableView reloadData];
}

- (void)updateButtonStatusForInternetConnection {
    
    BOOL connected = [Reachability reachabilityForInternetConnection].isReachable;
    self.navigationItem.rightBarButtonItem.enabled = connected;
}

-(void) dealloc {
    tableView.delegate = Nil;
    tableView.dataSource = Nil;
}

@end
