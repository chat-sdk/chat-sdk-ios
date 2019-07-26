//
//  BApi.m
//  AFNetworking
//
//  Created by ben3 on 29/04/2019.
//

#import "BApi.h"
#import <ChatSDK/Core.h>

@implementation BApi

+(RXPromise *) userForEntityID: (NSString *) entityID {
    id<PUser> user = [BChatSDK.db fetchOrCreateEntityWithID:entityID withType:bUserEntity];
    return [BChatSDK.core observeUser:user].thenOnMain(^id(id success) {
        return user;
    }, Nil);
}

@end
