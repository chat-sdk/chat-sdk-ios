//
//  BDefaultInterfaceAdapter.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 14/09/2016.
//
//

#import "BDefaultInterfaceAdapter.h"

#import <ChatSDK/Core.h>
#import <ChatSDK/UI.h>
#import <ChatSDK/BChatViewController.h>
#import <ChatSDK/BChatOptionDelegate.h>

#define bControllerKey @"bControllerKey"
#define bControllerNameKey @"bControllerNameKey"


@implementation BDefaultInterfaceAdapter

@synthesize privateThreadsViewController = _privateThreadsViewController;
@synthesize publicThreadsViewController = _publicThreadsViewController;

-(instancetype) init {
    if((self = [super init])) {
        _additionalChatOptions = [NSMutableArray new];
        _additionalTabBarViewControllers = [NSMutableArray new];
        _additionalSearchViewControllers = [NSMutableDictionary new];
        _messageCellTypes = [NSMutableArray new];
        _providers = [NSMutableDictionary new];
        // MEM1
        //[[SDWebImageDownloader sharedDownloader] setShouldDecompressImages:NO];
        
        [self registerMessageWithCellClass:BTextMessageCell.class messageType:@(bMessageTypeText)];
        [self registerMessageWithCellClass:BImageMessageCell.class messageType:@(bMessageTypeImage)];
        [self registerMessageWithCellClass:BLocationCell.class messageType:@(bMessageTypeLocation)];
        [self registerMessageWithCellClass:BSystemMessageCell.class messageType:@(bMessageTypeSystem)];
        
        // Setup default providers
        [self setProvider:[BMessageSectionDateProvider new] forName:bMessageSectionDateProvider];
    }
    return self;
}

-(id<PProvider>) providerForName: (NSString *) name {
    return _providers[name];
}

-(void) setProvider: (id<PProvider>) provider forName: (NSString *) name {
    [_providers setObject:provider forKey:name];
}

-(void) addTabBarViewController: (UIViewController *) controller atIndex: (int) index {
    [_additionalTabBarViewControllers addObject:@[controller, @(index)]];
}

-(void) removeTabBarViewControllerAtIndex: (int) index {
    int i = 0;
    BOOL found = false;
    for(NSArray * array in _additionalTabBarViewControllers) {
        if(array.count > 1 && [array.lastObject intValue] == index) {
            found = true;
            break;
        }
        i++;
    }
    if (found) {
        [_additionalTabBarViewControllers removeObjectAtIndex:i];
    }
}

-(UIViewController *) privateThreadsViewController {
    if (!_privateThreadsViewController) {
        _privateThreadsViewController = [[BPrivateThreadsViewController alloc] init];
    }
    return _privateThreadsViewController;
}

-(UIViewController *) publicThreadsViewController {
    if (!_publicThreadsViewController) {
        _publicThreadsViewController = [[BPublicThreadsViewController alloc] init];
    }
    return _publicThreadsViewController;
}

-(UIViewController *) flaggedMessagesViewController {
    if (!_flaggedMessagesViewController) {
        _flaggedMessagesViewController = [[BFlaggedMessagesViewController alloc] init];
    }
    return _flaggedMessagesViewController;
}

-(UIViewController *) contactsViewController {
    if (!_contactsViewController) {
        _contactsViewController = [[BContactsViewController alloc] init];
    }
    return _contactsViewController;
}

-(BFriendsListViewController *) friendsViewControllerWithUsersToExclude: (NSArray *) usersToExclude onComplete: (void(^)(NSArray * users, NSString * groupName)) action{
    if (_friendsListViewController != Nil) {
        return _friendsListViewController(usersToExclude, action);
    }
    return [[BFriendsListViewController alloc] initWithUsersToExclude:usersToExclude onComplete:action];
}

-(UINavigationController *) friendsNavigationControllerWithUsersToExclude: (NSArray *) usersToExclude onComplete: (void(^)(NSArray * users, NSString * name)) action {
    return [self navigationControllerWithRootViewController:[self friendsViewControllerWithUsersToExclude:usersToExclude onComplete:action]];
}
-(UIViewController *) appTabBarViewController __deprecated {
    return [self splashScreenNavigationController];
}

-(UIViewController *) mainViewController {
    if (!_mainViewController) {
        _mainViewController = [[BAppTabBarController alloc] initWithNibName:Nil bundle:Nil];
    }
    return _mainViewController;
}

-(UIViewController *) profileViewControllerWithUser: (id<PUser>) user {
    if (_profileViewController != Nil) {
        return _profileViewController(user);
    }
    BDetailedProfileTableViewController * controller = [[UIStoryboard storyboardWithName:@"DetailedProfile"
                                                                              bundle:[NSBundle uiBundle]] instantiateInitialViewController];
    controller.user = user;
    return controller;
}

-(UIViewController *) termsOfServiceViewController {
    if (!_termsOfServiceViewController) {
        _termsOfServiceViewController = [[BTermsOfServiceViewController alloc] init];
    }
    return _termsOfServiceViewController;
}

-(UINavigationController *) termsOfServiceNavigationController {
    return [self navigationControllerWithRootViewController:self.eulaViewController];
}

-(UIViewController *) profilePicturesViewControllerWithUser: (id<PUser>) user {
    if (_profilePicturesViewController != Nil) {
        return _profilePicturesViewController(user);
    }
    BProfilePicturesViewController * controller = [[BProfilePicturesViewController alloc] init];
    controller.user = user;
    return controller;
}

-(UIViewController *) eulaViewController __deprecated {
    return [self termsOfServiceViewController];
}

-(UINavigationController *) eulaNavigationController __deprecated {
    return [self termsOfServiceNavigationController];
}

-(UIViewController *) chatViewControllerWithThread: (id<PThread>) thread {
    if (_chatViewController != Nil) {
        return _chatViewController(thread);
    }
    return [[BChatViewController alloc] initWithThread:thread];
}

-(NSArray *) defaultTabBarViewControllers {
    NSMutableArray * dict = [NSMutableArray arrayWithArray:@[self.privateThreadsViewController,
                                                             self.publicThreadsViewController,
                                                             self.contactsViewController,
                                                             [self profileViewControllerWithUser: Nil]]];
    
    if(BChatSDK.config.enableMessageModerationTab) {
        [dict addObject: self.flaggedMessagesViewController];
    }
    
    return dict;
}

-(NSArray *) tabBarViewControllers {
    NSMutableArray * tabs = [NSMutableArray arrayWithArray:[self defaultTabBarViewControllers]];
   
    for(NSArray * tab in _additionalTabBarViewControllers) {
        [tabs insertObject:tab.firstObject atIndex:[tab.lastObject intValue]];
    }
    
    return tabs;
}

-(NSArray *) tabBarNavigationViewControllers {
    NSMutableArray * controllers = [NSMutableArray new];
    for (id vc in self.tabBarViewControllers) {
        UINavigationController * controller = [self navigationControllerWithRootViewController:vc];
        
        if (@available(iOS 11.0, *)) {
            controller.navigationBar.prefersLargeTitles = BChatSDK.config.prefersLargeTitles;
        }
        
        [controllers addObject:controller];
    }
    return controllers;
}

-(NSMutableArray *) chatOptions {
   
    NSMutableArray * options = [NSMutableArray new];
    
    BOOL videoEnabled = BChatSDK.videoMessage != Nil;
    BOOL imageEnabled = BChatSDK.imageMessage != Nil && BChatSDK.config.imageMessagesEnabled;
    BOOL locationEnabled = BChatSDK.locationMessage != Nil && BChatSDK.config.locationMessagesEnabled;
    
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
    
    for(BChatOption * option in _additionalChatOptions) {
        [options addObject:option];
    }
    
    return options;
    
}

-(UIViewController *) searchViewControllerWithType: (NSString *) type excludingUsers: (NSArray *) users usersAdded: (void(^)(NSArray * users)) usersAdded {
    
    UIViewController<PSearchViewController> * vc;
    
    if([type isEqualToString:bSearchTypeNameSearch]) {
        vc = [self searchViewControllerExcludingUsers:users usersAdded:usersAdded];
    }
    else {
        vc = _additionalSearchViewControllers[type][bControllerKey];
        if(vc) {
            [vc setSelectedAction:usersAdded];
            [vc setExcludedUsers:users];
        }
    }
//    return vc;
    return [self navigationControllerWithRootViewController:vc];
    
}

-(UIViewController<PImageViewController> *) imageViewController {
    return [[BImageViewController alloc] initWithNibName:nil bundle:Nil];
}

-(UINavigationController *) imageViewNavigationController {
    return [self navigationControllerWithRootViewController:[self imageViewController]];
}

-(UIViewController<PLocationViewController> *) locationViewController {
    return [[BLocationViewController alloc] initWithNibName:nil bundle:Nil];
}

-(UINavigationController *) locationViewNavigationController {
    return [self navigationControllerWithRootViewController:self.locationViewController];
}

-(NSDictionary *) additionalSearchControllerNames {
    NSMutableDictionary * nameForType = [NSMutableDictionary new];
    for(NSString * key in [_additionalSearchViewControllers allKeys]) {
        nameForType[key] = _additionalSearchViewControllers[key][bControllerNameKey];
    }
    return nameForType;
}

-(void) addSearchViewController: (UIViewController *) controller withType: (NSString *) type withName: (NSString *) name {
    [_additionalSearchViewControllers setObject:@{bControllerKey: controller, bControllerNameKey: name}
                                         forKey:type];
}

-(void) removeSearchViewControllerWithType: (NSString *) type {
    [_additionalSearchViewControllers removeObjectForKey:type];
}


-(UIViewController<PSearchViewController> *) searchViewControllerExcludingUsers: (NSArray *) users usersAdded: (void(^)(NSArray * users)) usersAdded {
    if (_searchViewController != Nil) {
        return _searchViewController(users, usersAdded);
    }
    BSearchViewController * vc = [[BSearchViewController alloc] initWithUsersToExclude: users];
    [vc setSelectedAction:usersAdded];
    [vc setExcludedUsers:users];
    return vc;
}

-(void) setChatOptionsHandler:(id<PChatOptionsHandler>)handler {
    _chatOptionsHandler = handler;
}

-(id<PChatOptionsHandler>) chatOptionsHandlerWithDelegate: (id<BChatOptionDelegate>) delegate {
    if (_chatOptionsHandler) {
        [_chatOptionsHandler setDelegate:delegate];
        return _chatOptionsHandler;
    }
    return [[BChatOptionsActionSheet alloc] initWithDelegate:delegate];
}

-(UIViewController *) usersViewControllerWithThread: (id<PThread>) thread parentNavigationController: (UINavigationController *) parent {
    if (_usersViewController != Nil) {
        return _usersViewController(thread, parent);
    }
    BUsersViewController * vc = [[BUsersViewController alloc] initWithThread:thread];
    vc.parentNavigationController = parent;
    return vc;
}

-(UINavigationController *) usersViewNavigationControllerWithThread: (id<PThread>) thread parentNavigationController: (UINavigationController *) parent {
    return [self navigationControllerWithRootViewController:[self usersViewControllerWithThread:thread parentNavigationController:parent]];
}

-(UINavigationController *) navigationControllerWithRootViewController: (UIViewController *) viewController {
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:viewController];
    return nav;
}


-(void) addChatOption: (BChatOption *) option {
    if(![_additionalChatOptions containsObject:option]) {
        [_additionalChatOptions addObject:option];
    }
}

-(void) removeChatOption: (BChatOption *) option {
    if([_additionalChatOptions containsObject:option]) {
        [_additionalChatOptions removeObject:option];
    }
}

-(UIViewController *) settingsViewController {
    return _settingsViewController;
}

-(UIColor *) colorForName: (NSString *) name {
    return Nil;
}

-(UIView<PSendBar> *) sendBarView {
    return [[BTextInputView alloc] initWithFrame:CGRectZero];
}

-(BOOL) showLocalNotification: (id) notification {
    return _showLocalNotifications && BChatSDK.config.showLocalNotifications;
}

-(void) setShowLocalNotifications: (BOOL) show {
    _showLocalNotifications = show;
}

-(UIViewController *) searchIndexViewControllerWithIndexes: (NSArray *) indexes withCallback: (void(^)(NSArray * index)) callback {
    if (_searchIndexViewController != Nil) {
        return _searchIndexViewController(indexes, callback);
    }
    return [[BSearchIndexViewController alloc] initWithIndexes:indexes withCallback:callback];
}

-(UINavigationController *) searchIndexNavigationControllerWithIndexes: (NSArray *) indexes withCallback: (void(^)(NSArray * index)) callback {
    return [self navigationControllerWithRootViewController:[self searchIndexViewControllerWithIndexes:indexes withCallback:callback]];
}

-(void) registerMessageWithCellClass: (Class) cellClass messageType: (NSNumber *) type {
    [_messageCellTypes addObject:@[cellClass, type]];
}

-(NSArray *) messageCellTypes {
    return _messageCellTypes;
}

-(Class) cellTypeForMessageType: (NSNumber *) messageType {
    for(NSArray * array in self.messageCellTypes) {
        if([array.lastObject isEqualToNumber:messageType]) {
            return array.firstObject;
        }
    }
    return Nil;
}

-(UIViewController<PSplashScreenViewController> *) splashScreenViewController {
    if (!_splashScreenViewController) {
        _splashScreenViewController = [[BSplashScreenViewController alloc] initWithNibName:Nil bundle:Nil];
    }
    return _splashScreenViewController;
}

-(UINavigationController *) splashScreenNavigationController {
    return [self navigationControllerWithRootViewController:self.splashScreenViewController];
}

-(UIViewController *) loginViewController {
    if (!_loginViewController) {
        _loginViewController = [[BLoginViewController alloc] initWithNibName:Nil bundle:Nil];
    }
    return _loginViewController;
}

@end
