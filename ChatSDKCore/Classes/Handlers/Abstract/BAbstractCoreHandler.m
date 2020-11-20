//
//  BAbstractCoreHandler.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 12/11/2016.
//
//

#import "BAbstractCoreHandler.h"

#import <ChatSDK/Core.h>
#import <Foundation/Foundation.h>

@implementation BAbstractCoreHandler

-(instancetype) init {
    if ((self = [super init])) {
    }
    return self;
}

-(void) activate {
    __weak __typeof__(self) weakSelf = self;
    [BChatSDK.hook addHook:[BHook hook:^(NSDictionary * data) {
        // Resets the view which the tab bar loads on
        __typeof__(self) strongSelf = weakSelf;
        strongSelf->_currentUser = Nil;
    }] withName:bHookDidLogout];
}

-(void) save {
    [BChatSDK.db save];
}

//-(void) saveToStore {
//    [BChatSDK.db saveToStore];
//}


-(id<PUser>) userForEntityID: (NSString *) entityID {
    // Get the user and make sure it's updated
    return [BChatSDK.db fetchOrCreateEntityWithID:entityID withType:bUserEntity];
}

/**
 * @brief Update the user on the server
 */
-(RXPromise *) pushUser {
    assert(NO);
}

/**
 * @brief Return the current user data
 */
-(id<PUser>) currentUserModel {
    NSString * currentUserID = BChatSDK.auth.currentUserID;
    if (currentUserID && !_currentUser) {
        _currentUser = [BChatSDK.db fetchEntityWithID:currentUserID withType:bUserEntity];
    }
    return _currentUser;
}

-(RXPromise *) currentUserModelAsync {
    NSString * currentUserID = BChatSDK.auth.currentUserID;
    if (currentUserID.length && !_currentUser) {
        return [BChatSDK.db performOnMain:^id {
            _currentUser = [BChatSDK.db fetchEntityWithID:currentUserID withType:bUserEntity];
            return _currentUser;
        }];
    } else {
        return [RXPromise resolveWithResult:_currentUser];
    }
}

// TODO: Consider removing / refactoring this
/**
 * @brief Mark the user as online
 */
-(void) setUserOnline {
    if (self.currentUserModel) {
        self.currentUserModel.online = @YES;
        if(BChatSDK.lastOnline && [BChatSDK.lastOnline respondsToSelector:@selector(setLastOnlineForUser:)]) {
            [BChatSDK.lastOnline setLastOnlineForUser:self.currentUserModel];
        }
    }
}

/**
 * @brief Connect to the server
 */

-(void) goOffline {
    assert(NO);
}


/**
 * @brief Disconnect from the server
 */
-(void) goOnline {
    assert(NO);
}

// TODO: Consider removing / refactoring this
/**
 * @brief Subscribe to a user's updates
 */
-(RXPromise *)observeUser: (NSString *)entityID {
    assert(NO);
}

- (void)setUserOffline {
    if (BChatSDK.currentUser) {
        BChatSDK.currentUser.online = @NO;
    }
}

-(bConnectionStatus) connectionStatus {
    return bConnectionStatusConnected;
}

-(NSDate *) now {
    return [NSDate date];
}


@end
