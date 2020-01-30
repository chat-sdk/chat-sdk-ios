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
        self = [super initWithDelegate:self];
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
    
    // Add the initial batch of messages
    NSArray<PMessage> * messages = [BChatSDK.db loadMessagesForThread:_thread newest:BChatSDK.config.messagesToLoadPerBatch];
    messages = [messages sortedArrayUsingComparator:[BMessageSorter oldestFirst]];
    [self setMessages:messages scrollToBottom:NO animate:NO force: YES];
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

-(void) addObservers {
    [super addObservers];
    
    id<PUser> currentUserModel = BChatSDK.currentUser;
    
    __weak __typeof__(self) weakSelf = self;
    [_notificationList add:[[NSNotificationCenter defaultCenter] addObserverForName:bNotificationReadReceiptUpdated object:Nil queue:Nil usingBlock:^(NSNotification * notification) {
        dispatch_async(dispatch_get_main_queue(), ^{
            id<PMessage> message = notification.userInfo[bNotificationReadReceiptUpdatedKeyMessage];
            [weakSelf reloadDataForMessage:message];
        });
    }]];
   
    [_notificationList add:[BChatSDK.hook addHook:[BHook hook:^(NSDictionary * data) {
        id<PMessage> message = data[bHook_PMessage];

        if (![message.thread isEqualToEntity:_thread]) {
            // If we are in chat and receive a message in another chat then vibrate the phone
            if (!message.userModel.isMe && BChatSDK.config.vibrateOnNewMessage) {
                AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
            }
        } else {
            if (BChatSDK.readReceipt) {
                [BChatSDK.readReceipt markRead:_thread.model];
            }
            [message setDelivered:@YES];
            [weakSelf addMessage:message];
        }
        
    }] withNames:@[bHookMessageWillSend, bHookMessageRecieved, bHookMessageWillUpload]]];

    [_notificationList add:[BChatSDK.hook addHook:[BHook hook:^(NSDictionary * data) {
        id<PMessage> message = data[bHook_PMessage];
        if (message && [message.thread isEqualToEntity:_thread]) {
            [self removeMessage:message];
        }
    }] withNames:@[bHookMessageWillBeDeleted]]];

    [_notificationList add:[BChatSDK.hook addHook:[BHook hook:^(NSDictionary * data) {
        [self reloadData];
    }] withNames:@[bHookMessageWasDeleted]]];

    
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
                                                                            if ([thread isEqualToEntity: weakSelf.thread]) {
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

-(void) updateMessages {
    [self reloadData];
}

-(void) updateTitle {
    [self setTitle:_thread.displayName ? _thread.displayName : [NSBundle t: bDefaultThreadName]];
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [BChatSDK.ui setLocalNotificationHandler:^(id<PThread> thread) {
        return NO;
    }];
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
    if (_thread.type.intValue & bThreadFilterPublic && (!BChatSDK.config.publicChatAutoSubscriptionEnabled || [_thread.meta valueForKey:bMute]) && !_usersViewLoaded) {
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
    id<PMessage> oldestMessage = _messageManager.oldestMessage;
    return [BChatSDK.core loadMoreMessagesFromDate:oldestMessage ? oldestMessage.date : Nil forThread:_thread];
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
}


@end
