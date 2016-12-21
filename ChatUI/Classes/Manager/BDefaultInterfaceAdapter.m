//
//  BDefaultInterfaceAdapter.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 14/09/2016.
//
//

#import "BDefaultInterfaceAdapter.h"

#import <ChatSDK/ChatCore.h>
#import <ChatSDK/ChatUI.h>

@implementation BDefaultInterfaceAdapter

-(BPrivateThreadsViewController *) privateThreadsViewController {
    if (!_privateThreadsViewController) {
        _privateThreadsViewController = [[BPrivateThreadsViewController alloc] init];
    }
    return _privateThreadsViewController;
}

-(BPublicThreadsViewController *) publicThreadsViewController {
    return [[BPublicThreadsViewController alloc] init];
}

-(BContactsViewController *) contactsViewController {
    return [[BContactsViewController alloc] init];
}

-(BFriendsListViewController *) friendsViewControllerWithUsersToExclude: (NSArray *) usersToExclude {
    return [[BFriendsListViewController alloc] initWithUsersToExclude:usersToExclude];
}

-(BProfileTableViewController *) profileViewControllerWithUser: (id<PUser>) user {
    
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Profile"
                                                          bundle:[NSBundle chatUIBundle]];
    
    BProfileTableViewController * controller = [storyboard instantiateInitialViewController];

    controller.user = user;
    return controller;
}

-(BChatViewController *) chatViewControllerWithThread: (id<PThread>) thread {
    return [[BChatViewController alloc] initWithThread:thread];
}

-(NSArray *) tabBarViewControllers {
    return @[self.privateThreadsViewController,
             self.publicThreadsViewController,
             self.contactsViewController,
             [self profileViewControllerWithUser: Nil]];
}

-(NSArray *) tabBarNavigationViewControllers {
    NSMutableArray * controllers = [NSMutableArray new];
    for (id vc in self.tabBarViewControllers) {
        [controllers addObject:[[UINavigationController alloc] initWithRootViewController:vc]];
    }
    return controllers;
}

-(NSMutableArray *) chatOptions {
   
    NSMutableArray * options = [NSMutableArray new];
    
    BOOL videoEnabled = [BNetworkManager sharedManager].a.videoMessage != Nil;
    BOOL audioEnabled = [BNetworkManager sharedManager].a.audioMessage != Nil;
    BOOL imageEnabled = [BNetworkManager sharedManager].a.imageMessage != Nil;
    BOOL locationEnabled = [BNetworkManager sharedManager].a.locationMessage != Nil;
    
    if (imageEnabled && videoEnabled) {
        [options addObject:[[BMediaChatOption alloc] initWithType:bPictureTypeCameraVideo]];
    }
    else if (imageEnabled)  {
        [options addObject:[[BMediaChatOption alloc] initWithType:bPictureTypeCameraImage]];
    }
    
    if (imageEnabled) {
        [options addObject:[[BMediaChatOption alloc] initWithType:bPictureTypeAlbumImage]];
    }
    if (videoEnabled) {
        [options addObject:[[BMediaChatOption alloc] initWithType:bPictureTypeAlbumVideo]];
    }
    if (locationEnabled) {
        [options addObject:[[BLocationChatOption alloc] init]];
    }
    
#ifdef ChatSDKStickerMessagesModule
    [options addObject: [[BStickerChatOption alloc] init]];
#endif
    
    return options;
    
}

-(BSearchViewController *) searchViewControllerExcludingUsers: (NSArray *) users usersAdded: (void(^)(NSArray * users)) usersAdded {
    BSearchViewController * vc = [[BSearchViewController alloc] initWithUsersToExclude: users];
    vc.usersSelected = usersAdded;
    return [[UINavigationController alloc] initWithRootViewController:vc];
}

-(id<PChatOptionsHandler>) chatOptionsHandlerWithChatViewController: (BChatViewController *) chatViewController {
#ifdef ChatSDKKeyboardOverlayOptionsModule
    return [[BChatOptionsCollectionView alloc] initWithChatViewController:chatViewController];
#else
    return [[BChatOptionsActionSheet alloc] initWithChatViewController:chatViewController];
#endif
    
}


@end
