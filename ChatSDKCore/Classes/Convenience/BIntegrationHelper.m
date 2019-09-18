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
    return [BChatSDK.auth authenticate:[BAccountDetails token:token]];
}

+(RXPromise *) logout {
    return [BChatSDK.auth logout];
}

+(void) updateUserWithName: (NSString *) name image: (UIImage *) image url: (NSString *) url {
    
    void(^pushUser)(void) = ^{
        id<PUser> user = BChatSDK.currentUser;
        [user setName:name];
        if(url) {
            [user setImageURL:url];
        }
        if(image) {
            [user setImage:UIImagePNGRepresentation(image)];
        }
        [BChatSDK.core pushUser];
    };
    
    id<PUser> user = BChatSDK.currentUser;
    if(user) {
        pushUser();
    }
    else {
        [BChatSDK.hook addHook:[BHook hook:^(NSDictionary * dict) {
            pushUser();
        }] withName:bHookDidAuthenticate];
    }
}

@end
