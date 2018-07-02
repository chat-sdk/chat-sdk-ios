//
//  BIntegrationHelper.m
//  AFNetworking
//
//  Created by Ben on 2/1/18.
//

#import "BIntegrationHelper.h"
#import <ChatSDK/Core.h>

@implementation BIntegrationHelper

+(RXPromise *) authenticateWithToken: (NSString *) token {
    return [NM.auth authenticate:[BAccountDetails token:token]];
}

+(RXPromise *) logout {
    return [NM.auth logout];
}

+(void) updateUserWithName: (NSString *) name image: (UIImage *) image url: (NSString *) url {
    
    void(^pushUser)(void) = ^{
        id<PUser> user = NM.currentUser;
        [user setName:name];
        if(url) {
            [user setImageURL:url];
        }
        if(image) {
            [user setImage:UIImagePNGRepresentation(image)];
        }
        [NM.core pushUser];
    };
    
    id<PUser> user = NM.currentUser;
    if(user) {
        pushUser();
    }
    else {
        [NM.hook addHook:[BHook hook:^(NSDictionary * dict) {
            pushUser();
        }] withName:bHookUserAuthFinished];
    }
}

@end
