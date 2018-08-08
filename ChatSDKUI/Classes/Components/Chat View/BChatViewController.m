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
        _notificationList = [BNotificationObserverList new];
    }
    return self;
}

-(void) viewDidLoad {
    [super viewDidLoad];
    
    // Set the title
    [self updateTitle];
    
    // Set the subtitle
    [self updateSubtitle];
    
    // Setup last online
    if (_thread.type.intValue == bThreadType1to1) {
        if(NM.lastOnline) {
            __weak __typeof__(self) weakSelf = self;
            [NM.lastOnline getLastOnlineForUser:_thread.otherUser].thenOnMain(^id(NSDate * date) {
                [weakSelf setSubtitle:date.lastSeenTimeAgo];
                return Nil;
            }, Nil);
        }
    }
    
    [super setAudioEnabled: NM.audioMessage != Nil];
}

-(void) updateSubtitle {
    
    if (BChatSDK.config.userChatInfoEnabled) {
        [self setSubtitle:[NSBundle t: bTapHereForContactInfo]];
    }
    
    if (_thread.type.intValue & bThreadFilterGroup) {
        [self setSubtitle:_thread.memberListString];
    }
}

-(void) addObservers {
    [super addObservers];
    
    id<PUser> currentUserModel = NM.currentUser;
    
    __weak __typeof__(self) weakSelf = self;
    [_notificationList add:[[NSNotificationCenter defaultCenter] addObserverForName:bNotificationReadReceiptUpdated object:Nil queue:Nil usingBlock:^(NSNotification * notification) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf updateMessages];
        });
    }]];
    
    [_notificationList add:[[NSNotificationCenter defaultCenter] addObserverForName:bNotificationMessageAdded object:Nil queue:Nil usingBlock:^(NSNotification * notification) {
        dispatch_async(dispatch_get_main_queue(), ^{
            id<PMessage> messageModel = notification.userInfo[bNotificationMessageAddedKeyMessage];
            
            if (![messageModel.thread isEqual:_thread.model] && [currentUserModel.threads containsObject:_thread] && messageModel) {
                
                // If we are in chat and receive a message in another chat then vibrate the phone
                if (![messageModel.userModel isEqual:currentUserModel]) {
                    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
                }
            }
            else {
                [NM.readReceipt markRead:_thread.model];
            }
            messageModel.delivered = @YES;
            
            [weakSelf updateMessages];
        });
    }]];
    
    [_notificationList add:[[NSNotificationCenter defaultCenter] addObserverForName:bNotificationMessageRemoved
                                                                                object:Nil
                                                                                 queue:Nil
                                                                            usingBlock:^(NSNotification * notification) {
                                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                                                        [weakSelf updateMessages];
                                                                                    });
                                                                                });
    }]];

    
    [_notificationList add:[[NSNotificationCenter defaultCenter] addObserverForName:bNotificationUserUpdated
                                                                      object:Nil
                                                                       queue:Nil
                                                                  usingBlock:^(NSNotification * notification) {
                                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                                          id<PUser> user = notification.userInfo[bNotificationUserUpdated_PUser];
                                                                          if (user && [_thread.users containsObject:user]) {
                                                                              [weakSelf updateMessages];
                                                                          }
                                                                      });
    }]];
    
    [_notificationList add:[[NSNotificationCenter defaultCenter] addObserverForName:bNotificationTypingStateChanged
                                                                        object:nil
                                                                         queue:Nil
                                                                    usingBlock:^(NSNotification * notification) {
                                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                                            id<PThread> thread = notification.userInfo[bNotificationTypingStateChangedKeyThread];
                                                                            if ([thread isEqual: _thread]) {
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
    [[BInterfaceManager sharedManager].a setShowLocalNotifications:NO];
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
        id<PUser> user = NM.currentUser;
        [NM.core addUsers:@[user] toThread:_thread];
    }
}

-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // Remove the user from the thread
    if (_thread.type.intValue & bThreadFilterPublic && !_usersViewLoaded) {
        id<PUser> currentUser = NM.currentUser;
        [NM.core removeUsers:@[currentUser] fromThread:_thread];
    }
    
    //[NM.core saveToStore];
    
}

-(RXPromise *) handleMessageSend: (RXPromise *) promise {
    [self updateMessages];
    [NM.core save];
    return promise;
}

-(RXPromise *) sendText: (NSString *) text withMeta:(NSDictionary *)meta {
    return [self handleMessageSend:[NM.core sendMessageWithText:text
                                             withThreadEntityID:_thread.entityID
                                                   withMetaData:meta]];
}

-(RXPromise *) sendText: (NSString *) text {
    return [self handleMessageSend:[NM.core sendMessageWithText:text
                                             withThreadEntityID:_thread.entityID]];
}

-(RXPromise *) sendImage: (UIImage *) image {
    if (NM.imageMessage) {
        return [self handleMessageSend:[NM.imageMessage sendMessageWithImage:image
                                                          withThreadEntityID:_thread.entityID]];
    }
    return [RXPromise rejectWithReasonDomain:bErrorTitle code:0 description:bImageMessagesNotSupported];
}

-(RXPromise *) sendLocation: (CLLocation *) location {
    if (NM.locationMessage) {
        return [self handleMessageSend:[NM.locationMessage sendMessageWithLocation:location
                                                                withThreadEntityID:_thread.entityID]];
    }
    return [RXPromise rejectWithReasonDomain:bErrorTitle code:0 description:bLocationMessagesNotSupported];
}

-(RXPromise *) sendAudio: (NSData *) audio withDuration: (double) duration {
    if (NM.audioMessage) {
        return [self handleMessageSend:[NM.audioMessage sendMessageWithAudio:audio
                                                                    duration:duration
                                                          withThreadEntityID:_thread.entityID]];
    }
    
    return [RXPromise rejectWithReasonDomain:bErrorTitle code:0 description:bAudioMessagesNotSupported];
}

-(RXPromise *) sendVideo: (NSData *) video withCoverImage: (UIImage *) coverImage {
    if (NM.videoMessage) {
        return [self handleMessageSend:[NM.videoMessage sendMessageWithVideo:video
                                                                  coverImage:coverImage
                                                          withThreadEntityID:_thread.entityID]];
    }
    return [RXPromise rejectWithReasonDomain:bErrorTitle code:0 description:bVideoMessagesNotSupported];
}

-(RXPromise *) sendSystemMessage: (NSString *) text {
    [NM.core sendLocalSystemMessageWithText:text withThreadEntityID:_thread.entityID];
    return [RXPromise resolveWithResult:Nil];
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
        return [NM.moderation unflagMessage:message.entityID];
    }
    else {
        return [NM.moderation flagMessage:message.entityID];
    }
    
}

-(RXPromise *) setChatState: (bChatState) state {
    return [NM.typingIndicator setChatState: state forThread: _thread];
}

// Do you want to enable the audio mic?
-(BOOL) audioEnabled {
    return NM.audioMessage != Nil;
}

// You can pull more messages from the server and add them to the thread object
-(RXPromise *) loadMoreMessages {
    __weak __typeof__(self) weakSelf = self;
    return [NM.core loadMoreMessagesForThread:_thread].thenOnMain(^id(NSArray * messages) {
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
    if(NM.readReceipt) {
        [NM.readReceipt markRead:_thread];
    }
    else {
        [_thread markRead];
    }
}

-(bThreadType) threadType {
    return _thread.type.intValue;
}

-(NSMutableArray *) customCellTypes {
    NSMutableArray * types = [NSMutableArray new];
    
    if(NM.audioMessage) {
        [types addObject: @[NM.audioMessage.messageCellClass, @(bMessageTypeAudio)]];
    }

    if(NM.videoMessage) {
        [types addObject: @[NM.videoMessage.messageCellClass, @(bMessageTypeVideo)]];
    }
    
    if([BNetworkManager sharedManager].a.stickerMessage) {
        [types addObject: @[NM.stickerMessage.messageCellClass, @(bMessageTypeSticker)]];
    }

    return types;
}


-(void) navigationBarTapped {
    _usersViewLoaded = YES;
    NSMutableArray * users = [NSMutableArray arrayWithArray: _thread.model.users.allObjects];
    [users removeObject:NM.currentUser];
    
    UINavigationController * nvc = [[BInterfaceManager sharedManager].a usersViewNavigationControllerWithThread:_thread
                                                                    parentNavigationController:self.navigationController];
    
    [self presentViewController:nvc animated:YES completion:nil];
    
}

-(void) dealloc {
    [_thread clearMessageCache];
}


@end
