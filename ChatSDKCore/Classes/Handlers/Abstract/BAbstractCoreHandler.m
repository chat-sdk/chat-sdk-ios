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

-(void) save {
    [BChatSDK.db save];
}

-(id<PUser>) userForEntityID: (NSString *) entityID {
    // Get the user and make sure it's updated
    return [BChatSDK.db fetchOrCreateEntityWithID:entityID withType:bUserEntity];
}

/**
 * @brief Update the user on the server
 */
-(RXPromise *) pushUser {
    return [self pushUser:NO];
}

-(RXPromise *) pushUser: (BOOL) uploadAvatar {
    assert(NO);
}


/**
 * @brief Return the current user data
 */
-(id<PUser>) currentUserModel {
    return BChatSDK.auth.currentUser;
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
    return bConnectionStatusNone;
}

-(NSDate *) now {
    return [NSDate date];
}


@end
