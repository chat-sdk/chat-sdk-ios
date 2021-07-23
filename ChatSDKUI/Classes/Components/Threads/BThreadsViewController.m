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
#import <ChatSDK/ChatSDK-Swift.h>

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
        _disposeOnDisappear = [BNotificationObserverList new];
        _disposeOnDealloc = [BNotificationObserverList new];
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
    
    self.navigationItem.titleView = [BReconnectingView new];
    
    __weak __typeof(self) weakSelf = self;
    [_disposeOnDealloc add:[BChatSDK.hook addHook:[BHook hookOnMain:^(NSDictionary * data) {
        [weakSelf updateBadge];
    }] withNames:@[bHookMessageRecieved, bHookMessageWasDeleted, bHookAllMessagesDeleted, bHookThreadRemoved]]];

}

-(void) addObservers {
    [self removeObservers];
    __weak __typeof__(self) weakSelf = self;
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];

    [_disposeOnDisappear add:[BChatSDK.hook addHook:[BHook hookOnMain:^(NSDictionary * dict) {
        id<PMessage> messageModel = dict[bHook_PMessage];
        [messageModel setDelivered:@YES];
        
        // This makes the phone vibrate when we get a new message
        
        // Only vibrate if a message is received from a private thread
        if (messageModel.thread.type.intValue & bThreadFilterPrivate) {
            if (!messageModel.userModel.isMe && [BChatSDK.currentUser.threads containsObject:messageModel.thread]) {
                AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
            }
        }
        
        // Just reload that thread
        [weakSelf sortAndReloadData];
    }] withNames: @[bHookMessageWillSend, bHookMessageRecieved]]];

    [_disposeOnDisappear add:[BChatSDK.hook addHook:[BHook hookOnMain:^(NSDictionary * dict) {
        [weakSelf sortAndReloadData];
    }] withNames: @[bHookMessageWasDeleted, bHookAllMessagesDeleted, bHookUserUpdated]]];
    
    [_disposeOnDisappear add:[BChatSDK.hook addHook:[BHook hookOnMain:^(NSDictionary * data) {
        [weakSelf updateButtonStatusForInternetConnection];
    }] withName:bHookInternetConnectivityDidChange]];

    [_disposeOnDisappear add:[BChatSDK.hook addHook:[BHook hookOnMain:^(NSDictionary * data) {
        id<PThread> thread = data[bHook_PThread];
        _threadTypingMessages[thread.entityID] = data[bHook_NSString];
        [weakSelf reloadDataForThread:thread];
    }] withName:bHookTypingStateUpdated]];
    
    [_disposeOnDisappear add:[BChatSDK.hook addHook:[BHook hookOnMain:^(NSDictionary * dict) {
        [weakSelf loadThreadsAndReloadData];
    }] withNames: @[bHookThreadAdded, bHookThreadRemoved, bHookThreadsUpdated]]];

    [_disposeOnDisappear add:[BChatSDK.hook addHook:[BHook hookOnMain:^(NSDictionary * dict) {
        id<PThread> thread = dict[bHook_PThread];
        if (thread) {
            [weakSelf reloadDataForThread:thread];
        }
    }] withNames: @[bHookThreadUpdated]]];

    // If we update the badge by message carbon i.e. if the message is read on another active device
    [_disposeOnDisappear add:[BChatSDK.hook addHook:[BHook hookOnMain:^(NSDictionary * data) {
        id<PMessage> message = data[bHook_PMessage];
        if (message) {
            [weakSelf reloadDataForThread:message.thread];
            [weakSelf updateBadge];
        }
    }] withNames:@[bHookMessageReadReceiptUpdated]]];

}

-(void) removeObservers {
    [_disposeOnDisappear dispose];
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
    
    // Stop the typing text from being frozen
    [_threadTypingMessages removeAllObjects];
    
    [self loadThreadsAndReloadData];
    
    [self updateLocalNotificationHandler];
    
    // Update the badge
    [self updateBadge];
    
}

-(void) updateLocalNotificationHandler {
    // Should  be overridden
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
    
    NSString * text = @"";// [NSBundle t:bNoMessages];
    
    id<PMessage> newestMessage = thread.newestMessage;
    if (newestMessage) {
        text = [NSBundle textForMessage:newestMessage];
    }
    
    if (threadDate) {
        cell.dateLabel.text = threadDate.threadTimeAgo;
    }
    else {
        cell.dateLabel.text = @"";
    }
    
    if(BChatSDK.config.threadTimeFont) {
        cell.dateLabel.font = BChatSDK.config.threadTimeFont;
    }
    
    if(BChatSDK.config.threadTitleFont) {
        cell.titleLabel.font = BChatSDK.config.threadTitleFont;
    }
    
    if(BChatSDK.config.threadSubtitleFont) {
        cell.messageTextView.font = BChatSDK.config.threadSubtitleFont;
    }
    
    cell.titleLabel.text = thread.displayName ? thread.displayName : [NSBundle t: bDefaultThreadName];
   
    [cell.profileImageView loadThreadImage:thread];
    
//    NSString * threadImagePath = thread.imageURL;
//    NSURL * threadURL = threadImagePath && threadImagePath.length ? [NSURL URLWithString:threadImagePath] : Nil;
//
//    if (threadURL) {
//        [cell.profileImageView sd_setImageWithURL:threadURL];
//    } else {
//        [thread imageForThread].thenOnMain(^id(UIImage * image) {
//            cell.profileImageView.image = image;
////            [cell.profileImageView sd_setImageWithURL:threadURL placeholderImage:image];
//            return Nil;
//        }, Nil);
//    }
    
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
        UIViewController * vc = [BChatSDK.ui chatViewControllerWithThread:thread];
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
        [BChatSDK.thread deleteThread:thread];
        [self reloadData];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return !_slideToDeleteDisabled;
}

-(void) reloadDataForThread: (id<PThread>) thread {
    int index = [_threads indexOfObject:thread];
    if (index >= 0) {
        [tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

// Load the threads from the database
// This should be implemented by the super class
-(void) loadThreads {
    
}

// Reload threads, sort and refresh the table view
-(void) loadThreadsAndReloadData {
    [self loadThreads];
    [self reloadData];
}

// Reload the tableView
-(void) sortAndReloadData {
    [_threads sortUsingComparator:^(id<PThread>t1, id<PThread> t2) {
        return [t2.orderDate compare:t1.orderDate];
    }];
    [self reloadData];
}

// Reload the tableView
-(void) reloadData {
    [tableView reloadData];
}

- (void)updateButtonStatusForInternetConnection {
    BOOL connected = BChatSDK.connectivity.isConnected;
    self.navigationItem.rightBarButtonItem.enabled = connected;
}

-(void) dealloc {
    [_disposeOnDealloc dispose];
    [_disposeOnDisappear dispose];

    tableView.delegate = Nil;
    tableView.dataSource = Nil;
}

-(void) updateBadge {
    
}

@end
