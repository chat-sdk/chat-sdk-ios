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

@protocol PThread;

@interface BChatViewController : ElmChatViewController<ElmChatViewDelegate> {
    id<PThread> _thread;
    
    BOOL _usersViewLoaded;
    

}

@property (nonatomic, readwrite) id<PThread> thread;
@property (nonatomic, readwrite) BOOL usersViewLoaded;

-(instancetype) initWithThread: (id<PThread>) thread;
-(instancetype) initWithThread: (id<PThread>) thread nibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil;

-(void) updateSubtitle;
-(void) updateTitle;
-(void) doViewWillDisappear: (BOOL) animated;

@end
