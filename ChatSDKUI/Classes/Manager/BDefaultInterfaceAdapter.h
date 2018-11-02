//
//  BDefaultInterfaceAdapter.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 14/09/2016.
//
//

#import <Foundation/Foundation.h>
#import <ChatSDK/PInterfaceFacade.h>

#define bColorMessageLink @"bColorMessageLink"

@class BPrivateThreadsViewController;
@class BPublicThreadsViewController;
@class BFlaggedMessagesViewController;
@class BContactsViewController;
@class UIViewController;
@class BFriendsListViewController;
@class BChatViewController;
@class BSearchViewController;

@protocol PThread;
@protocol PUser;

@interface BDefaultInterfaceAdapter : NSObject<PInterfaceFacade> {
    UIViewController * _privateThreadsViewController;
    UIViewController * _publicThreadsViewController;
    id<PChatOptionsHandler> _chatOptionsHandler;
    NSMutableArray * _additionalChatOptions;
    NSMutableArray * _additionalTabBarViewControllers;
    NSMutableDictionary * _additionalSearchViewControllers;
    
    // An array of arrays. Each sub array contains @[(Class) class, (NSNumber *) mesasageType]
    NSMutableArray * _customMessageCellTypes;
    BOOL _showLocalNotifications;
}

@end
