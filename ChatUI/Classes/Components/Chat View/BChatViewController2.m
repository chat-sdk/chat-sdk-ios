//
//  BChatViewController2.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 02/02/2017.
//
//

#import "BChatViewController2.h"

#import <ChatSDK/ChatCore.h>
#import <ChatSDK/ChatUI.h>

@implementation BChatViewController2

- (id)initWithThread: (id<PThread>) thread
{
    _thread = thread;
    self = [super initWithDelegate:self];
    if (self) {
        _messageCache = [NSMutableArray new];
    }
    return self;
}

-(void) viewDidLoad {
    [super viewDidLoad];
    
    // Set the title
    [self setTitle:_thread.displayName ? _thread.displayName : [NSBundle t: bDefaultThreadName]];
    
    // Set the subtitle
    [self updateSubtitle];
    
    // Setup last online
    if (_thread.type.intValue == bThreadType1to1) {
        if([BNetworkManager sharedManager].a.lastOnline) {
            [[BNetworkManager sharedManager].a.lastOnline getLastOnlineForUser:_thread.otherUser].thenOnMain(^id(NSDate * date) {
                [self setSubtitle:date.lastSeenTimeAgo];
                
                return Nil;
            }, Nil);
        }
    }
    
    [super setAudioEnabled: [BNetworkManager sharedManager].a.audioMessage != Nil];
    
}

-(void) updateSubtitle {
    [self setSubtitle:[NSBundle t: bTapHereForContactInfo]];
    if (_thread.type.intValue & bThreadTypeGroup) {
        [self setSubtitle:_thread.memberListString];
    }
}

-(void) addObservers {
    [self removeObservers];
    
    [super addObservers];
    
    id<PUser> currentUserModel = [BNetworkManager sharedManager].a.core.currentUserModel;
    
    _readReceiptObserver = [[NSNotificationCenter defaultCenter] addObserverForName:bNotificationReadReceiptUpdated object:Nil queue:Nil usingBlock:^(NSNotification * notification) {
        [self updateMessages];
    }];
    
    _messageObserver = [[NSNotificationCenter defaultCenter] addObserverForName:bNotificationMessageAdded object:Nil queue:Nil usingBlock:^(NSNotification * notification) {
        
        id<PMessage> messageModel = notification.userInfo[bNotificationMessageAddedKeyMessage];
        
        if (![messageModel.thread isEqual:_thread.model] && [currentUserModel.threads containsObject:_thread] && messageModel) {
            
            // If we are in chat and receive a message in another chat then vibrate the phone
            if (![messageModel.userModel isEqual:currentUserModel]) {
                AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
            }
        }
        else {
            [[BNetworkManager sharedManager].a.readReceipt markRead:_thread.model];
        }
        messageModel.delivered = @YES;
        
        [self updateMessages];
        
    }];
    _userObserver = [[NSNotificationCenter defaultCenter] addObserverForName:bNotificationUserUpdated object:Nil queue:Nil usingBlock:^(NSNotification * notification) {
        [self updateMessages];
    }];
    
    _typingObserver = [[NSNotificationCenter defaultCenter] addObserverForName:bNotificationTypingStateChanged object:nil queue:Nil usingBlock:^(NSNotification * notification) {
        id<PThread> thread = notification.userInfo[bNotificationTypingStateChangedKeyThread];
        if ([thread isEqual: _thread]) {
            [self startTypingWithMessage:notification.userInfo[bNotificationTypingStateChangedKeyMessage]];
        }
    }];
    
    
    _threadUsersObserver = [[NSNotificationCenter defaultCenter] addObserverForName:bNotificationThreadUsersUpdated object:Nil queue:Nil usingBlock:^(NSNotification * notification) {
        [self updateSubtitle];
    }];
    
}

-(void) removeObservers {
    [super removeObservers];
    
    [[NSNotificationCenter defaultCenter] removeObserver:_messageObserver];
    [[NSNotificationCenter defaultCenter] removeObserver:_userObserver];
    [[NSNotificationCenter defaultCenter] removeObserver:_typingObserver];
    [[NSNotificationCenter defaultCenter] removeObserver:_threadUsersObserver];
    
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateMessages];
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    _usersViewLoaded = NO;
    
    // For public threads we add the user when we view the thread
    // TODO: This is called multiple times... maybe move it to view did load
    if (_thread.type.intValue & bThreadTypePublic) {
        id<PUser> user = [BNetworkManager sharedManager].a.core.currentUserModel;
        [[BNetworkManager sharedManager].a.core addUsers:@[user] toThread:_thread];
    }
    
}

-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // Remove the user from the thread
    if (_thread.type.intValue & bThreadTypePublic && !_usersViewLoaded) {
        id<PUser> currentUser = [BNetworkManager sharedManager].a.core.currentUserModel;
        [[BNetworkManager sharedManager].a.core removeUsers:@[currentUser] fromThread:_thread];
    }
    
    
}

-(RXPromise *) handleMessageSend: (RXPromise *) promise {
    [self updateMessages];
    return promise;
}

-(RXPromise *) sendText: (NSString *) text {
    return [self handleMessageSend:[[BNetworkManager sharedManager].a.core sendMessageWithText:text
                                                                            withThreadEntityID:_thread.entityID]];
}

-(RXPromise *) sendImage: (UIImage *) image {
    if ([BNetworkManager sharedManager].a.imageMessage) {
        return [self handleMessageSend:[[BNetworkManager sharedManager].a.imageMessage sendMessageWithImage:image
                                                                                         withThreadEntityID:_thread.entityID]];
    }
    return [RXPromise rejectWithReasonDomain:bErrorTitle code:0 description:bImageMessagesNotSupported];
}

-(RXPromise *) sendLocation: (CLLocation *) location {
    if ([BNetworkManager sharedManager].a.locationMessage) {
        return [self handleMessageSend:[[BNetworkManager sharedManager].a.locationMessage sendMessageWithLocation:location
                                                                                               withThreadEntityID:_thread.entityID]];
    }
    return [RXPromise rejectWithReasonDomain:bErrorTitle code:0 description:bLocationMessagesNotSupported];
}

-(RXPromise *) sendAudio: (NSData *) audio withDuration: (double) duration {
    if ([BNetworkManager sharedManager].a.audioMessage) {
        return [self handleMessageSend:[[BNetworkManager sharedManager].a.audioMessage sendMessageWithAudio:audio
                                                                                                   duration:duration
                                                                                         withThreadEntityID:_thread.entityID]];
    }
    
    return [RXPromise rejectWithReasonDomain:bErrorTitle code:0 description:bAudioMessagesNotSupported];
}

-(RXPromise *) sendVideo: (NSData *) video withCoverImage: (UIImage *) coverImage {
    if ([BNetworkManager sharedManager].a.videoMessage) {
        return [self handleMessageSend:[[BNetworkManager sharedManager].a.videoMessage sendMessageWithVideo:video
                                                                                                 coverImage:coverImage
                                                                                         withThreadEntityID:_thread.entityID]];
    }
    return [RXPromise rejectWithReasonDomain:bErrorTitle code:0 description:bVideoMessagesNotSupported];
}

-(RXPromise *) sendSystemMessage: (NSString *) text {
    return [self handleMessageSend:[[BNetworkManager sharedManager].a.stickerMessage sendMessageWithSticker:text
                                                                                         withThreadEntityID:_thread.entityID]];
}

-(RXPromise *) sendSticker: (NSString *) name {
    if([BNetworkManager sharedManager].a.stickerMessage) {
        return [self handleMessageSend:[[BNetworkManager sharedManager].a.stickerMessage sendMessageWithSticker:name
                                                                                             withThreadEntityID:_thread.entityID]];
    }
    return [RXPromise rejectWithReasonDomain:bErrorTitle code:0 description:bStickerMessagesNotSupported];
}

-(RXPromise *) setMessageFlagged: (id<PElmMessage>) message isFlagged: (BOOL) flagged {
    if (flagged) {
        return [[BNetworkManager sharedManager].a.moderation flagMessage:message.entityID];
    }
    else {
        return [[BNetworkManager sharedManager].a.moderation unflagMessage:message.entityID];
    }
    
}

-(RXPromise *) setChatState: (bChatState) state {
    return [[BNetworkManager sharedManager].a.typingIndicator setChatState: state forThread: _thread];
}

// Do you want to enable the audio mic?
-(BOOL) audioEnabled {
    return [BNetworkManager sharedManager].a.audioMessage != Nil;
}

// You can pull more messages from the server and add them to the thread object
-(RXPromise *) loadMoreMessages {
    return [[BNetworkManager sharedManager].a.core loadMoreMessagesForThread:_thread].thenOnMain(^id(NSArray * messages) {
        [self updateMessages];
        return Nil;
    },^id(NSError * error) {
        return Nil;
    });
}

-(void) updateMessages {
    _messageCacheDirty = YES;
    [self setMessages:self.messages];
}

-(NSArray *) messages {
    if (!_messageCache || !_messageCache.count || _messageCacheDirty) {
        [_messageCache removeAllObjects];
        
        NSArray * messages = [_thread messagesOrderedByDateAsc];
        id<PMessage> lastMessageDate;
        BMessageSection * section;
        
        for (id<PMessage> message in messages) {
            // This is a new day
            if (!lastMessageDate || abs([message.date daysFrom:lastMessageDate]) > 0) {
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

-(void) markRead {
    if([BNetworkManager sharedManager].a.readReceipt) {
        [[BNetworkManager sharedManager].a.readReceipt markRead:_thread];
    }
    else {
        [_thread markRead];
    }
}

-(bThreadType) threadType {
    return _thread.type.intValue;
}

-(NSArray *) customCellTypes {
    NSMutableArray * types = [NSMutableArray new];
    
#ifdef ChatSDKAudioMessagesModule
    if([BNetworkManager sharedManager].a.audioMessage) {
        [types addObject: @[[BNetworkManager sharedManager].a.audioMessage.messageCellClass, @(bMessageTypeAudio)]];
    }
#endif
    
#ifdef ChatSDKVideoMessagesModule
    if([BNetworkManager sharedManager].a.videoMessage) {
        [types addObject: @[[BNetworkManager sharedManager].a.videoMessage.messageCellClass, @(bMessageTypeVideo)]];
    }
#endif
    
#ifdef ChatSDKStickerMessagesModule
    if([BNetworkManager sharedManager].a.stickerMessage) {
        [types addObject: @[[BNetworkManager sharedManager].a.stickerMessage.messageCellClass, @(bMessageTypeSticker)]];
    }
#endif
    
    return types;
}

-(void) navigationBarTapped {
    _usersViewLoaded = YES;
    NSMutableArray * users = [NSMutableArray arrayWithArray: _thread.model.users.allObjects];
    [users removeObject:[BNetworkManager sharedManager].a.core.currentUserModel];
    
    UIViewController * vc = [[BInterfaceManager sharedManager].a usersViewControllerWithThread:_thread
                                                                    parentNavigationController:self.navigationController];
    
    UINavigationController * nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nvc animated:YES completion:nil];
    
}


@end
