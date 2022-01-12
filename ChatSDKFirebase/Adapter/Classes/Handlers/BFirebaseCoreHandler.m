//
//  BFirebaseMessagingHandler.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 12/11/2016.
//
//

#import "BFirebaseCoreHandler.h"

#import <ChatSDKFirebase/FirebaseAdapter.h>
#import <ChatSDKFirebase/ChatSDKFirebase-Swift.h>

@implementation BFirebaseCoreHandler

-(RXPromise *) pushUser: (BOOL) uploadAvatar {
    [self save];
    id<PUser> currentUser = self.currentUserModel;
    
    if(currentUser && currentUser.entityID) {
        [BHookNotification notificationWillPushUser:currentUser];
        
        RXPromise * promise = [RXPromise resolveWithResult:nil];
        if (uploadAvatar && BChatSDK.upload) {
            promise = [BChatSDK.upload uploadImage:currentUser.imageAsImage].thenOnMain(^id(NSDictionary * urls) {
                NSString * url = urls[bImagePath];
                if (url) {
                    [BChatSDK.currentUser setImageURL:url];
                }
                return urls;
            }, Nil);
        }
        
        return promise.then(^id(id result) {
            return [self.userWrapper push];
        }, nil);
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
        [self.userWrapper goOnline];
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
        [self.userWrapper goOffline];
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

-(id<PUser>) userForEntityID:(NSString *)entityID {
    id<PUser> user = [super userForEntityID:entityID];
    CCUserWrapper * wrapper = [self userWrapper:user];
    if (!BChatSDK.config.disablePresence) {
        [wrapper onlineOn];
    }
    [wrapper metaOn];
    return user;
}

-(RXPromise *)observeUser: (NSString *)entityID {
    id<PUser> userModel = [super userForEntityID:entityID];
    CCUserWrapper * wrapper = [self userWrapper:userModel];
    if (!BChatSDK.config.disablePresence) {
        [wrapper onlineOn];
    }
    return [wrapper metaOn];
}

-(CCUserWrapper *) userWrapper {
    return [self userWrapper:self.currentUserModel];
}

-(CCUserWrapper *) userWrapper: (id<PUser>) user {
    return [FirebaseNetworkAdapterModule.shared.firebaseProvider userWrapperWithModel:user];
}

#pragma Static methods

+(NSDate *) timestampToDate:(NSNumber *)timestamp {
    return [NSDate dateWithTimeIntervalSince1970:timestamp.doubleValue / 1000];
}

+(NSNumber *) dateToTimestamp:(NSDate *)date {
    return @((double)date.timeIntervalSince1970 * 1000);
}

@end
