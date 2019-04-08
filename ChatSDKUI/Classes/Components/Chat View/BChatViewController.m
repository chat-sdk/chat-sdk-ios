//
//  BChatViewController.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 02/02/2017.
//
//

#import "BChatViewController.h"

#import <ChatSDK/Core.h>
#import <ChatSDK/UI.h>

@implementation BChatViewController

@synthesize thread = _thread;
@synthesize usersViewLoaded = _usersViewLoaded;

-(instancetype) initWithThread: (id<PThread>) thread
{
    if (self) {
        _thread = thread;
        
        // Reset the working list (so we don't load any more messages than necessary)
        [_thread resetMessages];
        self = [super initWithDelegate:self];
        _messageCache = [NSMutableArray new];
    }
    return self;
}

-(void) viewDidLoad {
    [super viewDidLoad];
    
    [_sendBarView setMaxLines:BChatSDK.config.textInputViewMaxLines];
    [_sendBarView setMaxCharacters:BChatSDK.config.textInputViewMaxCharacters];

    // Set the title
    [self updateTitle];
    
    // Set the subtitle
    [self updateSubtitle];
    
    
    [super setAudioEnabled: BChatSDK.audioMessage != Nil];
}

-(void) updateSubtitle {
    
    if (BChatSDK.config.userChatInfoEnabled) {
        [self setSubtitle:[NSBundle t: bTapHereForContactInfo]];
    }
    
    if (_thread.type.intValue & bThreadFilterGroup) {
        [self setSubtitle:_thread.memberListString];
    } else {
        // 1-to-1 Chat
        if (_thread.otherUser.online.boolValue) {
            [self setSubtitle:[NSBundle t: bOnline]];
        } else if(BChatSDK.lastOnline) {
            __weak __typeof__(self) weakSelf = self;
            [BChatSDK.lastOnline getLastOnlineForUser:_thread.otherUser].thenOnMain(^id(NSDate * date) {
                [weakSelf setSubtitle:date.lastSeenTimeAgo];
                return Nil;
            }, Nil);
        }
    }
}

-(void) openInviteScreen{
    
    
    BFriendsListViewController * vc = [[BFriendsListViewController alloc] initWithUsersToExclude:_thread.users.allObjects onComplete:nil];
    //  [[BFriendsListViewController alloc] initWithUsersToExclude:usersToExclude onComplete:action]
    
    UINavigationController * nav = [BChatSDK.ui friendsNavigationControllerWithUsersToExclude:_thread.users.allObjects onComplete:^(NSArray * users, NSString * groupName){
        
        [BChatSDK.core addUsers:users toThread:_thread].thenOnMain(^id(id success){
            [UIView alertWithTitle:[NSBundle t:bSuccess] withMessage:[NSBundle t:bAdded]];
            // [self reloadData];
            return Nil;
        }, Nil);
    }];
    [((id<PFriendsListViewController>) nav.topViewController) setRightBarButtonActionTitle:[NSBundle t: bAdd]];
    [self.navigationController pushViewController:vc animated:YES];
    
    
    //[self presentViewController:nav animated:YES completion:Nil];
}

-(void) addObservers {
    [super addObservers];
    
    id<PUser> currentUserModel = BChatSDK.currentUser;
    
    __weak __typeof__(self) weakSelf = self;
    [_notificationList add:[[NSNotificationCenter defaultCenter] addObserverForName:bNotificationReadReceiptUpdated object:Nil queue:Nil usingBlock:^(NSNotification * notification) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf updateMessages];
        });
    }]];
   
    [_notificationList add:[BChatSDK.hook addHook:[BHook hook:^(NSDictionary * data) {
        id<PMessage> messageModel = data[bHook_PMessage];

        // If this is a message for another thread for this user
        if (messageModel && [currentUserModel.threads containsObject:_thread]) {
            if (![messageModel.thread isEqual:_thread.model]) {
                // If we are in chat and receive a message in another chat then vibrate the phone
                if (!messageModel.userModel.isMe) {
                    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
                }
            } else if (BChatSDK.readReceipt) {
                [BChatSDK.readReceipt markRead:_thread.model];
            }
        }
        messageModel.delivered = @YES;
        
        [weakSelf updateMessages];
    }] withNames:@[bHookMessageWillSend, bHookMessageRecieved, bHookMessageWillUpload]]];
    
    [_notificationList add:[[NSNotificationCenter defaultCenter] addObserverForName:bNotificationMessageRemoved
                                                                                object:Nil
                                                                                 queue:Nil
                                                                            usingBlock:^(NSNotification * notification) {
                                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                                    [weakSelf updateMessages];
                                                                                });
    }]];
    
    [_notificationList add:[[NSNotificationCenter defaultCenter] addObserverForName:bNotificationUserUpdated
                                                                      object:Nil
                                                                       queue:Nil
                                                                  usingBlock:^(NSNotification * notification) {
                                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                                          id<PUser> user = notification.userInfo[bNotificationUserUpdated_PUser];
                                                                          if (user && [weakSelf.thread.users containsObject:user]) {
                                                                              [weakSelf updateMessages];
                                                                              [weakSelf updateSubtitle];
                                                                          }
                                                                      });
    }]];
    
    [_notificationList add:[[NSNotificationCenter defaultCenter] addObserverForName:bNotificationTypingStateChanged
                                                                        object:nil
                                                                         queue:Nil
                                                                    usingBlock:^(NSNotification * notification) {
                                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                                            id<PThread> thread = notification.userInfo[bNotificationTypingStateChangedKeyThread];
                                                                            if ([thread isEqual: weakSelf.thread]) {
                                                                                [weakSelf startTypingWithMessage:notification.userInfo[bNotificationTypingStateChangedKeyMessage]];
                                                                            }
                                                                        });
    }]];
    
    
    [_notificationList add:[[NSNotificationCenter defaultCenter] addObserverForName:bNotificationThreadUsersUpdated
                                                                             object:Nil
                                                                              queue:Nil
                                                                         usingBlock:^(NSNotification * notification) {
                                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                                 [weakSelf updateSubtitle];
                                                                                 [weakSelf updateTitle];
                                                                            });
    }]];
    
}

-(void) updateTitle {
    [self setTitle:_thread.displayName ? _thread.displayName : [NSBundle t: bDefaultThreadName]];
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [BChatSDK.ui setShowLocalNotifications:NO];
    [self updateMessages];
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    _usersViewLoaded = NO;
    
    [self addUserToPublicThreadIfNecessary];
    
}

-(void) addUserToPublicThreadIfNecessary {
    // For public threads we add the user when we view the thread
    // TODO: This is called multiple times... maybe move it to view did load
    if (_thread.type.intValue & bThreadFilterPublic) {
        id<PUser> user = BChatSDK.currentUser;
        [BChatSDK.core addUsers:@[user] toThread:_thread];
    }
}

-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // Remove the user from the thread
    if (_thread.type.intValue & bThreadFilterPublic && !_usersViewLoaded) {
        id<PUser> currentUser = BChatSDK.currentUser;
        [BChatSDK.core removeUsers:@[currentUser] fromThread:_thread];
    }
}

-(RXPromise *) setMessageFlagged: (id<PElmMessage>) message isFlagged: (BOOL) flagged {
    if (flagged) {
        return [BChatSDK.moderation unflagMessage:message.entityID];
    }
    else {
        return [BChatSDK.moderation flagMessage:message.entityID];
    }
}

-(RXPromise *) setChatState: (bChatState) state {
    return [BChatSDK.typingIndicator setChatState: state forThread: _thread];
}

// Do you want to enable the audio mic?
-(BOOL) audioEnabled {
    return BChatSDK.audioMessage != Nil;
}

// You can pull more messages from the server and add them to the thread object
-(RXPromise *) loadMoreMessages {
    __weak __typeof__(self) weakSelf = self;
    return [BChatSDK.core loadMoreMessagesForThread:_thread].thenOnMain(^id(NSArray * messages) {
        [weakSelf updateMessages];
        return Nil;
    },^id(NSError * error) {
        return Nil;
    });
}

-(void) updateMessages {
    _messageCacheDirty = YES;
    [self setMessages:self.messages];
}

// TODO: We could make this more efficient
-(NSArray *) messages {
    if (!_messageCache || !_messageCache.count || _messageCacheDirty) {
        [_messageCache removeAllObjects];

        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        NSCalendar *calendar = [NSCalendar currentCalendar];
        dateFormatter.dateFormat = @"ddMMyyyy";

        // Don't load any additional messages - we will already load the
        // number of messages as defined the config.chatMessagesToLoad property
        NSArray * messages = [_thread loadMoreMessages:0];
        NSDate * lastMessageDate;
        BMessageSection * section;
        
        for (id<PElmMessage> message in messages) {
            // This is a new day
            // It is a new day if either the calendar date has changed
            NSString * lastDateString = [dateFormatter stringFromDate:lastMessageDate];
            NSString * dateString = [dateFormatter stringFromDate:message.date];
            
            if (!lastMessageDate || ![dateString isEqual:lastDateString]) {
                section = [[BMessageSection alloc] init];
                [_messageCache addObject:section];
            }
            [section addMessage:message];
            lastMessageDate = message.date;
        }
        if (![_messageCache containsObject:section] && section) {
            [_messageCache addObject:section];
        }
        
        _messageCacheDirty = NO;
    }
    return _messageCache;
}

-(void) viewDidScroll: (UIScrollView *) scrollView withOffset: (int) offset {

}

-(void) markRead {
    if(BChatSDK.readReceipt) {
        [BChatSDK.readReceipt markRead:_thread];
    }
    else {
        [_thread markRead];
    }
}

-(bThreadType) threadType {
    return _thread.type.intValue;
}

-(void) navigationBarTapped {
    _usersViewLoaded = YES;
    NSMutableArray * users = [NSMutableArray arrayWithArray: _thread.model.users.allObjects];
    [users removeObject:BChatSDK.currentUser];
    
    UINavigationController * nvc = [BChatSDK.ui usersViewNavigationControllerWithThread:_thread
                                                                    parentNavigationController:self.navigationController];
    
    [self presentViewController:nvc animated:YES completion:nil];
    
}

-(NSString *) threadEntityID {
    return _thread.entityID;
}

-(void) dealloc {
    [_thread clearMessageCache];
}


@end
