//
//  BContactBookModule.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 13/04/2017.
//
//


#import "NearbyUsers.h"
#import <ChatSDK/Core.h>
#import <ChatSDK/UI.h>


@implementation BNearbyUsersModule {
    BOOL _serviceRunning;
}

@synthesize disabled;

static BNearbyUsersModule * instance;

+(nonnull BNearbyUsersModule *) shared {
    
    @synchronized(self) {
        
        // If the sharedSoundManager var is nil then we need to allocate it.
        if(instance == nil) {
            // Allocate and initialize an instance of this class
            instance = [[self alloc] init];
        }
    }
    return instance;
}

-(instancetype) init {
    if((self = [super init])) {

    }
    return self;
}

-(void) activate {
    BChatSDK.shared.networkAdapter.nearbyUsers = [[BGeoFireManager alloc] init];
    [BChatSDK.ui addTabBarViewController: [[BNearbyContactsViewController alloc] init] atIndex: 2];
    
    _locationUpdater = [[BLocationUpdater alloc] init];
    
    __weak __typeof(self) weakSelf = self;
    [BChatSDK.hook addHook:[BHook hook:^(NSDictionary * data) {
        if (!weakSelf.disabled) {
            [weakSelf startService];
        }
    }] withName:bHookDidAuthenticate];

    [BChatSDK.hook addHook:[BHook hook:^(NSDictionary * data) {
        if (!weakSelf.disabled) {
            [weakSelf stopService];
        }
    }] withName:bHookWillLogout];

    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillEnterForegroundNotification
                                                      object:Nil
                                                       queue:Nil
                                                  usingBlock:^(NSNotification * notification) {
        if (!weakSelf.disabled) {
            [weakSelf startService];
        }
    }];

    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification
                                                      object:Nil
                                                       queue:Nil
                                                  usingBlock:^(NSNotification * notification) {
        if (!weakSelf.disabled) {
            [weakSelf stopService];
        }
    }];
    
}

-(void) startService {
    if (BChatSDK.auth.isAuthenticatedThisSession && !_serviceRunning) {
        _serviceRunning = true;

        [self addCurrentUserItem];
        [_locationUpdater startUpdatingLocation];
    }
}

-(void) stopService {
    if (BChatSDK.auth.isAuthenticatedThisSession && _serviceRunning) {
        _serviceRunning = false;

        [_locationUpdater stopUpdatingLocation];
        [_locationUpdater reset];
        [BGeoFireManager.sharedManager stopListeningForItems];
        [BGeoFireManager.sharedManager resetLocation];
        
        [BHookNotification notificationUserUpdated:nil];
    }
}

-(void) addCurrentUserItem {
    [_locationUpdater reset].thenOnMain(^id(id success) {
        [_locationUpdater addItem:self.currentUserItem];
        return Nil;
    }, Nil);
}

-(BGeoItem *) currentUserItem {
    return [BGeoItem item:BChatSDK.currentUser.entityID];
}

@end
