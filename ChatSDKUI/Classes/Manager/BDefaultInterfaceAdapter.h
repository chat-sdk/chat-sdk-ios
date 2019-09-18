//
//  BDefaultInterfaceAdapter.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 14/09/2016.
//
//

#import <Foundation/Foundation.h>
#import <ChatSDK/PInterfaceAdapter.h>

#define bColorMessageLink @"bColorMessageLink"

// Providers
#define bMessageSectionDateProvider @"BMessageSectionDateProvider"

@class BPrivateThreadsViewController;
@class BPublicThreadsViewController;
@class BFlaggedMessagesViewController;
@class BContactsViewController;
@class BProfilePicturesViewController;
@class UIViewController;
@class BFriendsListViewController;
@class BChatViewController;
@class BSearchViewController;
@protocol PUser;

@protocol PThread;
@protocol PUser;

@interface BDefaultInterfaceAdapter : NSObject<PInterfaceAdapter> {
    id<PChatOptionsHandler> _chatOptionsHandler;
    NSMutableArray * _additionalChatOptions;
    NSMutableArray * _additionalTabBarViewControllers;
    NSMutableDictionary * _additionalSearchViewControllers;
    NSMutableDictionary * _providers;

    // An array of arrays. Each sub array contains @[(Class) class, (NSNumber *) mesasageType]
    NSMutableArray * _messageCellTypes;
    BOOL _showLocalNotifications;
}

@property (nonatomic, readwrite) UIViewController * privateThreadsViewController;
@property (nonatomic, readwrite) UIViewController * publicThreadsViewController;
@property (nonatomic, readwrite) UIViewController * flaggedMessagesViewController;
@property (nonatomic, readwrite) UIViewController * contactsViewController;
@property (nonatomic, readwrite) UIViewController * mainViewController;
@property (nonatomic, readwrite) UIViewController * (^searchViewController)(NSArray * usersToExclude, void(^usersAdded)(NSArray * users));
@property (nonatomic, readwrite) UIViewController * (^searchIndexViewController)(NSArray * indexes, void(^callback)(NSArray *));
@property (nonatomic, readwrite) BFriendsListViewController * (^friendsListViewController)(NSArray * usersToExclude, void(^onComplete)(NSArray * users, NSString * groupName));
@property (nonatomic, readwrite) UIViewController * (^profileViewController)(id<PUser> user);
@property (nonatomic, readwrite) UIViewController * (^profilePicturesViewController)(id<PUser> user);
@property (nonatomic, readwrite) UIViewController * termsOfServiceViewController;
@property (nonatomic, readwrite) BChatViewController * (^chatViewController)(id<PThread> thread);
@property (nonatomic, readwrite) UIViewController * imageViewController;
@property (nonatomic, readwrite) UIViewController * locationViewController;
@property (nonatomic, readwrite) UIViewController * settingsViewController;
@property (nonatomic, readwrite) UIViewController * (^usersViewController)(id<PThread> thread, UINavigationController * parent);
@property (nonatomic, readwrite) UIViewController<PSplashScreenViewController> * splashScreenViewController;
@property (nonatomic, readwrite) UIViewController * loginViewController;

@end
