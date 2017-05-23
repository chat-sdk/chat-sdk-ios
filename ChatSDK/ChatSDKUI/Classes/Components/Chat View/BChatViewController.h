//
//  BChatViewController.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 02/02/2017.
//
//

#import <Foundation/Foundation.h>
#import <ChatSDKUI/ElmChatViewController.h>
#import <ChatSDKUI/ElmChatViewDelegate.h>

@protocol PThread;

@interface BChatViewController : ElmChatViewController<ElmChatViewDelegate> {
    id<PThread> _thread;
    
    id _messageObserver;
    id _userObserver;
    id _typingObserver;
    id _readReceiptObserver;
    id _threadUsersObserver;
    
    BOOL _usersViewLoaded;
    
    NSMutableArray * _messageCache;
    BOOL _messageCacheDirty;

}

- (id)initWithThread: (id<PThread>) thread;

@end
