//
//  BChatViewController.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 02/02/2017.
//
//

#import <Foundation/Foundation.h>
#import <ChatSDK/ElmChatViewController.h>
#import <ChatSDK/ElmChatViewDelegate.h>

@class BNotificationObserverList;
@protocol PThread;

@interface BChatViewController : ElmChatViewController<ElmChatViewDelegate> {
    id<PThread> _thread;
    
    BOOL _usersViewLoaded;
    
    NSMutableArray * _messageCache;
    BOOL _messageCacheDirty;
    BNotificationObserverList * _notificationList;

}

- (id)initWithThread: (id<PThread>) thread;
- (void) updateSubtitle;

@end
