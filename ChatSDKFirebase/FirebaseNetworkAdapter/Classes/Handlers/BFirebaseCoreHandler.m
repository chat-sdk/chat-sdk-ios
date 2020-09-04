//
//  BFirebaseMessagingHandler.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 12/11/2016.
//
//

#import "BFirebaseCoreHandler.h"

#import <ChatSDKFirebase/FirebaseAdapter.h>

@implementation BFirebaseCoreHandler

-(RXPromise *) pushUser {
    [self save];
    if(self.currentUser && self.currentUser.entityID) {
        return [self.currentUser push];
    }
    else return [RXPromise rejectWithReason:Nil];
}

-(void) setUserOnline {
    if (!BChatSDK.config.disablePresence && BChatSDK.auth.isAuthenticatedThisSession) {
        [super setUserOnline];
        id<PUser> user = self.currentUserModel;
        if(!user || !user.entityID) {
            return;
        }
        [[CCUserWrapper userWithModel:user] goOnline];
    }
}

-(void) setUserOffline {
    if (!BChatSDK.config.disablePresence) {
        [super setUserOffline];
        id<PUser> user = self.currentUserModel;
        if(!user || !user.entityID) {
            return;
        }

        [BHookNotification notificationUserWillDisconnect];
        [[CCUserWrapper userWithModel:user] goOffline];
    }
}
-(void) goOnline {
    [FIRDatabaseReference goOnline];
    if (self.currentUserModel) {
        [self setUserOnline];
    }
}

-(void) goOffline {
    [FIRDatabaseReference goOffline];
}

-(RXPromise *)observeUser: (NSString *)entityID {
    id<PUser> userModel = [BChatSDK.db fetchOrCreateEntityWithID:entityID withType:bUserEntity];
    if (!BChatSDK.config.disablePresence) {
        [[CCUserWrapper userWithModel:userModel] onlineOn];
    }
    return [[CCUserWrapper userWithModel:userModel] metaOn];
}



#pragma Private methods

-(CCUserWrapper *) currentUser {
    return [CCUserWrapper userWithModel:self.currentUserModel];
}

#pragma Static methods

+(NSDate *) timestampToDate:(NSNumber *)timestamp {
    return [NSDate dateWithTimeIntervalSince1970:timestamp.doubleValue / 1000];
}

+(NSNumber *) dateToTimestamp:(NSDate *)date {
    return @((double)date.timeIntervalSince1970 * 1000);
}

+(FIRApp *) app {
    if (BChatSDK.config.firebaseApp) {
        return [FIRApp appNamed:BChatSDK.config.firebaseApp];
    }
    return [FIRApp defaultApp];
}

+(FIRDatabase *) database {
    return [FIRDatabase databaseForApp:self.app];
}

+(FIRAuth *) auth {
    return [FIRAuth authWithApp:self.app];
}


@end
