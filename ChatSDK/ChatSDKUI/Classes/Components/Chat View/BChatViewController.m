//
//  BChatViewController.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 02/02/2017.
//
//

#import "BChatViewController.h"

#import <ChatSDKCore/ChatCore.h>
#import <ChatSDKUI/ChatUI.h>

@implementation BChatViewController

- (id)initWithThread: (id<PThread>) thread
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
    [self setTitle:_thread.displayName ? _thread.displayName : [NSBundle t: bDefaultThreadName]];
    
    // Set the subtitle
    [self updateSubtitle];
    
    // Setup last online
    if (_thread.type.intValue == bThreadType1to1) {
        if(NM.lastOnline) {
            [NM.lastOnline getLastOnlineForUser:_thread.otherUser].thenOnMain(^id(NSDate * date) {
                [self setSubtitle:date.lastSeenTimeAgo];
                
                return Nil;
            }, Nil);
        }
    }
    
    [super setAudioEnabled: NM.audioMessage != Nil];
}

-(void) updateSubtitle {
    
    if ([BSettingsManager userChatInfoEnabled]) {
        [self setSubtitle:[NSBundle t: bTapHereForContactInfo]];
    }
    
    if (_thread.type.intValue & bThreadFilterGroup) {
        [self setSubtitle:_thread.memberListString];
    }
}

-(void) addObservers {
    [self removeObservers];
    
    [super addObservers];
    
    id<PUser> currentUserModel = NM.currentUser;
    
    [_notificationList add:[[NSNotificationCenter defaultCenter] addObserverForName:bNotificationReadReceiptUpdated object:Nil queue:Nil usingBlock:^(NSNotification * notification) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateMessages];
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
            
            [self updateMessages];
        });
    }]];
    
    [_notificationList add:[[NSNotificationCenter defaultCenter] addObserverForName:bNotificationMessageRemoved
                                                                                object:Nil
                                                                                 queue:Nil
                                                                            usingBlock:^(NSNotification * notification) {
                                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                                                        [self updateMessages];
                                                                                    });
                                                                                });
    }]];

    
    [_notificationList add:[[NSNotificationCenter defaultCenter] addObserverForName:bNotificationUserUpdated
                                                                      object:Nil
                                                                       queue:Nil
                                                                  usingBlock:^(NSNotification * notification) {
                                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                                          [self updateMessages];
                                                                      });
    }]];
    
    [_notificationList add:[[NSNotificationCenter defaultCenter] addObserverForName:bNotificationTypingStateChanged
                                                                        object:nil
                                                                         queue:Nil
                                                                    usingBlock:^(NSNotification * notification) {
                                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                                            id<PThread> thread = notification.userInfo[bNotificationTypingStateChangedKeyThread];
                                                                            if ([thread isEqual: _thread]) {
                                                                                [self startTypingWithMessage:notification.userInfo[bNotificationTypingStateChangedKeyMessage]];
                                                                            }
                                                                        });
    }]];
    
    
    [_notificationList add:[[NSNotificationCenter defaultCenter] addObserverForName:bNotificationThreadUsersUpdated
                                                                             object:Nil
                                                                              queue:Nil
                                                                         usingBlock:^(NSNotification * notification) {
                                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                                 [self updateSubtitle];
                                                                            });
    }]];
    
}

-(void) removeObservers {
    [super removeObservers];
    
    [_notificationList dispose];
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
    
    
}

-(RXPromise *) handleMessageSend: (RXPromise *) promise {
    [self updateMessages];
    [NM.core save];
    //[self reloadData];
    return promise;
}

-(RXPromise *) sendText: (NSString *) text withMeta:(NSDictionary *)meta {
    return [self handleMessageSend:[NM.core sendMessageWithText:text withThreadEntityID:_thread.entityID withMetaData:meta]];
}

-(RXPromise *) sendText: (NSString *) text {
    return [self handleMessageSend:[NM.core sendMessageWithText:text withThreadEntityID:_thread.entityID]];
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
    return [NM.core loadMoreMessagesForThread:_thread].thenOnMain(^id(NSArray * messages) {
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

-(NSArray *) customCellTypes {
    NSMutableArray * types = [NSMutableArray new];
    
    if(NM.audioMessage) {
        [types addObject: @[NM.audioMessage.messageCellClass, @(bMessageTypeAudio)]];
    }

    if(NM.videoMessage) {
        [types addObject: @[NM.videoMessage.messageCellClass, @(bMessageTypeVideo)]];
    }
    
    if([BNetworkManager sharedManager].a.stickerMessage) {
        [types addObject: @[[BNetworkManager sharedManager].a.stickerMessage.messageCellClass, @(bMessageTypeSticker)]];
    }

    return types;
}

-(void) navigationBarTapped {
    _usersViewLoaded = YES;
    NSMutableArray * users = [NSMutableArray arrayWithArray: _thread.model.users.allObjects];
    [users removeObject:NM.currentUser];
    
    UIViewController * vc = [[BInterfaceManager sharedManager].a usersViewControllerWithThread:_thread
                                                                    parentNavigationController:self.navigationController];
    
    UINavigationController * nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nvc animated:YES completion:nil];
    
}


@end
