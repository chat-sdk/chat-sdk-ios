//
//  BThreadsViewController.m
//  Chat SDK
//
//  Created by Benjamin Smiley-andrews on 24/09/2013.
//  Copyright (c) 2013 deluge. All rights reserved.
//

#import "BThreadsViewController.h"

#import <AudioToolbox/AudioToolbox.h>

#import <ChatSDK/ChatCore.h>
#import <ChatSDK/ChatUI.h>

#define bCellIdentifier @"bCellIdentifier"

@interface BThreadsViewController ()

@end

@implementation BThreadsViewController

@synthesize tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
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
    
    [tableView registerNib:[UINib nibWithNibName:@"BThreadCell" bundle:[NSBundle chatUIBundle]] forCellReuseIdentifier:bCellIdentifier];
    
}

-(void) addObservers {
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
                                                                             [self reloadData];
                                                                         });
    }]];
    [_notificationList add:[[NSNotificationCenter defaultCenter] addObserverForName:bNotificationMessageRemoved
                                                                         object:Nil
                                                                          queue:Nil
                                                                     usingBlock:^(NSNotification * notification) {
                                                                         dispatch_async(dispatch_get_main_queue(), ^{
                                                                             [self reloadData];
                                                                         });
    }]];
    [_notificationList add:[[NSNotificationCenter defaultCenter] addObserverForName:bNotificationUserUpdated
                                                                      object:Nil
                                                                       queue:Nil
                                                                  usingBlock:^(NSNotification * notification) {
                                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                                          [self reloadData];
                                                                      });
    }]];
    [_notificationList add:[[NSNotificationCenter defaultCenter] addObserverForName:kReachabilityChangedNotification
                                                                                    object:nil
                                                                                     queue:Nil
                                                                                usingBlock:^(NSNotification * notification) {
                                                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                                                        [self updateButtonStatusForInternetConnection];
                                                                                    });
    }]];
    
    [_notificationList add:[[NSNotificationCenter defaultCenter] addObserverForName:bNotificationTypingStateChanged
                                                                        object:nil
                                                                         queue:Nil
                                                                    usingBlock:^(NSNotification * notification) {
                                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                                            id<PThread> thread = notification.userInfo[bNotificationTypingStateChangedKeyThread];
                                                                            _threadTypingMessages[thread.entityID] = notification.userInfo[bNotificationTypingStateChangedKeyMessage];
                                                                            [self reloadData];
                                                                        });
    }]];
    [_notificationList add:[[NSNotificationCenter defaultCenter] addObserverForName:bNotificationThreadDeleted
                                                                        object:Nil
                                                                         queue:Nil
                                                                    usingBlock:^(NSNotification * notification) {
                                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                                            [self reloadData];
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
    
    id<PMessage> message = Nil;
    
    if (thread.allMessages.count) {
        // Get the last message
        message = [thread messagesOrderedByDateDesc].firstObject;
        
        if (message.type.intValue == bMessageTypeImage) {
            text = [NSBundle core_t:bImageMessage];
        }
        else if(message.type.intValue == bMessageTypeLocation) {
            text = [NSBundle core_t:bLocationMessage];
        }
        else if(message.type.intValue == bMessageTypeAudio) {
            text = [NSBundle core_t:bAudioMessage];
        }
        else if(message.type.intValue == bMessageTypeVideo) {
            text = [NSBundle core_t:bVideoMessage];
        }
        else if(message.type.intValue == bMessageTypeSticker) {
            text = [NSBundle core_t:bStickerMessage];
        }
        else {
            text = message.textString;
        }
    }
    
    if (threadDate) {
        cell.dateLabel.text = threadDate.threadTimeAgo;
    }
    else {
        cell.dateLabel.text = @"";
    }

    cell.titleLabel.text = thread.displayName ? thread.displayName : [NSBundle t: bDefaultThreadName];
        
    cell.profileImageView.image = thread.imageForThread;
    
    cell.unreadView.hidden = !thread.unreadMessageCount;
    
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

@end
