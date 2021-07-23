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
    return [self initWithThread:thread nibName:nil bundle:nil];
}

-(instancetype) initWithThread: (id<PThread>) thread nibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil {
    if (self) {
        _thread = thread;
        
        // Reset the working list (so we don't load any more messages than necessary)
        self = [super initWithDelegate:self nibName:nibNameOrNil bundle:nibBundleOrNil];
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

-(void) traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [self reloadData];
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
        
    __weak __typeof__(self) weakSelf = self;

    [BChatSDK.hook addHook:[BHook hookOnMain:^(NSDictionary * dict){
        id<PMessage> message = dict[bHook_PMessage];
        if (message && [message.thread isEqualToEntity:weakSelf.thread]) {
            [weakSelf reloadDataForMessage:message];
        }
    }] withName:bHookMessageReadReceiptUpdated];
   
    [_notificationList add:[BChatSDK.hook addHook:[BHook hookOnMain:^(NSDictionary * data) {
        id<PMessage> message = data[bHook_PMessage];

        if ([message.thread isEqualToEntity:weakSelf.thread]) {
            if (!message.userModel.isMe) {
                [self markRead];
            } else {
                [message setDelivered:@YES];
            }
            [weakSelf addMessage:message];
        }
        
    }] withNames:@[bHookMessageWillSend, bHookMessageRecieved, bHookMessageWillUpload]]];

    // Can't be hook on main... because otherwise we get into a race condition where the message
    // has been deleted before it's removed
    [_notificationList add:[BChatSDK.hook addHook:[BHook hook:^(NSDictionary * data) {
        id<PMessage> message = data[bHook_PMessage];
//        if (message && [message.thread isEqualToEntity:weakSelf.thread]) {
        if (message) {
            [weakSelf removeMessage:message];
        }
    }] withNames:@[bHookMessageWillBeDeleted]]];

    [_notificationList add:[BChatSDK.hook addHook:[BHook hook:^(NSDictionary * data) {
        [weakSelf reloadData];


    }] withNames:@[bHookMessageWasDeleted]]];

    [_notificationList add:[BChatSDK.hook addHook:[BHook hookOnMain:^(NSDictionary * data) {
        NSArray * threads = data[bHook_PThreads];
        if ([threads containsObject:weakSelf.thread]) {
            [weakSelf.messageManager clear];
            [weakSelf reloadData];
        }
    }] withNames:@[bHookAllMessagesDeleted]]];
    
    [_notificationList add:[BChatSDK.hook addHook:[BHook hookOnMain:^(NSDictionary * dict) {
        id<PThread> thread = dict[bHook_PThread];
        if (thread && [thread.entityID isEqualToString:weakSelf.thread.entityID]) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    }] withNames: @[bHookThreadRemoved]]];
    
    [_notificationList add:[BChatSDK.hook addHook:[BHook hookOnMain:^(NSDictionary * dict) {
        id<PUser> user = dict[bHook_PUser];
        if (user && [weakSelf.thread.users containsObject:user]) {
            [weakSelf updateMessages];
            [weakSelf updateSubtitle];
            [weakSelf updateTitle];
        }
    }] withName:bHookUserUpdated]];

    [_notificationList add:[BChatSDK.hook addHook:[BHook hookOnMain:^(NSDictionary * dict) {
        id<PUser> user = dict[bHook_PUser];
        id<PThread> thread = dict[bHook_PThread];
        if ([thread isEqualToEntity:weakSelf.thread] && user.isMe) {
            BOOL hasVoice = [BChatSDK.thread hasVoice:thread.entityID forUser:user.entityID];
            [weakSelf setReadOnly:!hasVoice];
        }
    }] withName:bHookThreadUserRoleUpdated]];
    
    
    [_notificationList add:[BChatSDK.hook addHook:[BHook hookOnMain:^(NSDictionary * data) {
        id<PThread> thread = data[bHook_PThread];
        
        if ([thread isEqualToEntity: weakSelf.thread]) {
            [weakSelf startTypingWithMessage:data[bHook_NSString]];
        }
    }] withName:bHookTypingStateUpdated]];
    
    [_notificationList add:[BChatSDK.hook addHook:[BHook hookOnMain:^(NSDictionary * data) {
        [weakSelf updateSubtitle];
        [weakSelf updateTitle];
    }] withName:bHookThreadUsersUpdated]];

}

-(void) updateMessages {
    [self reloadData];
}

-(void) updateTitle {
    [self setTitle:_thread.displayName ? _thread.displayName : [NSBundle t: bDefaultThreadName]];
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    [BChatSDK.ui setLocalNotificationHandler:^(id<PThread> thread) {
//        return ![_thread isEqualToEntity:thread];
//    }];

    __weak __typeof__(self) weakSelf = self;
    [BChatSDK.ui setLocalNotificationHandler:^(id<PThread> thread) {
        __typeof__(self) strongSelf = weakSelf;
        BOOL enable = ![strongSelf.thread isEqualToEntity:thread];
        enable = enable && BChatSDK.config.showLocalNotificationInChat && (!BChatSDK.encryption || BChatSDK.config.showLocalNotificationForEncryptedChats);
        return enable;
    }];
    
    if (!self.sendBarView.text.length && [_thread respondsToSelector:@selector(draft)]) {
        self.sendBarView.text = [_thread draft];
    }
    
    // Add the initial batch of messages
    
    [_messageManager clear];
    
    [BCoreUtilities checkDuplicateThread];
    [BCoreUtilities checkOnMain];

    // Testing
    [BChatSDK.db fetchEntityWithID:_thread.entityID withType:bThreadEntity];
    
    // End
    
    NSArray<PMessage> * messages = [BChatSDK.db loadMessagesForThread:_thread newest:BChatSDK.config.messagesToLoadPerBatch];
    messages = [messages sortedArrayUsingComparator:[BMessageSorter oldestFirst]];
    [self setMessages:messages scrollToBottom:NO animate:NO force: YES];
    
    if([BChatSDK.thread rolesEnabled:_thread.entityID]) {
        BOOL hasVoice = [BChatSDK.thread hasVoice:_thread.entityID forUser:BChatSDK.currentUserID];
        if (!hasVoice) {
            [self setReadOnly:true];
        }
    }

}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    _usersViewLoaded = NO;
    
    [self addUserToPublicThreadIfNecessary];
    
}

-(void) setupTextInputView: (BOOL) forceSuper {
    if (!_thread.isReadOnly || forceSuper) {
        [super setupTextInputView: forceSuper];
    }
}


-(void) addUserToPublicThreadIfNecessary {
    // For public threads we add the user when we view the thread
    // TODO: This is called multiple times... maybe move it to view did load
    if (_thread.type.intValue & bThreadFilterPublic) {
        id<PUser> user = BChatSDK.currentUser;
        [BChatSDK.thread addUsers:@[user] toThread:_thread];
    }
}

-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self doViewWillDisappear:animated];
    
    if ([_thread respondsToSelector:@selector(draft)]) {
        _thread.draft = self.sendBarView.text;
    }
    
}

-(void) doViewWillDisappear: (BOOL) animated {
    // Remove the user from the thread
    if (_thread.type.intValue & bThreadFilterPublic && (!BChatSDK.config.publicChatAutoSubscriptionEnabled || [_thread.meta valueForKey:bMute]) && !_usersViewLoaded) {
        [BChatSDK.thread removeUsers:@[BChatSDK.currentUserID] fromThread:_thread];
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
    if (_chatState != state) {
        _chatState = state;
        return [BChatSDK.typingIndicator setChatState: state forThread: _thread];
    } else {
        return [RXPromise resolveWithResult:nil];
    }
}

// Do you want to enable the audio mic?
-(BOOL) audioEnabled {
    return BChatSDK.audioMessage != Nil;
}

// You can pull more messages from the server and add them to the thread object
-(RXPromise *) loadMoreMessages {
    id<PMessage> oldestMessage = _messageManager.oldestMessage;
    return [BChatSDK.thread loadMoreMessagesFromDate:oldestMessage ? oldestMessage.date : Nil forThread:_thread];
}

-(void) markRead {
    if(BChatSDK.readReceipt) {
        [BChatSDK.readReceipt markRead:_thread];
    } else {
        [_thread markRead];
    }
}

-(bThreadType) threadType {
    return _thread.type.intValue;
}

-(void) navigationBarTapped {
    _usersViewLoaded = YES;
    NSMutableArray * users = [NSMutableArray arrayWithArray: _thread.users.allObjects];
    [users removeObject:BChatSDK.currentUser];
    
    UINavigationController * nvc = [BChatSDK.ui usersViewNavigationControllerWithThread:_thread
                                                                    parentNavigationController:self.navigationController];
    
    [self presentViewController:nvc animated:YES completion:nil];
    
}

-(NSString *) threadEntityID {
    return _thread.entityID;
}


@end
