//
//  BAbstractAuthenticationHandler.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 12/11/2016.
//
//

#import "BAbstractAuthenticationHandler.h"
#import <ChatSDK/ChatCore.h>

@implementation BAbstractAuthenticationHandler

-(BOOL) accountTypeEnabled: (bAccountType) accountType {
    NSString * key = @"";
    
    switch (accountType) {
        case bAccountTypeFacebook:
            key = [BSettingsManager facebookAppId];
            break;
        case bAccountTypeTwitter:
            key = [BSettingsManager twitterApiKey];
            break;
        case bAccountTypeGoogle:
            key = [BSettingsManager googleApiKey];
            break;
        case bAccountTypeAnonymous:
            key = [BSettingsManager anonymousLoginEnabled] ? @"YES" : @"";
        default:
            break;
    }
    return key.length ? YES : NO;
}

-(NSString *) currentUserEntityID {
    return [[NSUserDefaults standardUserDefaults] dictionaryForKey:bCurrentUserLoginInfo][bAuthenticationIDKey];
}

-(void) setLoginInfo: (NSDictionary *) info {
    [[NSUserDefaults standardUserDefaults] setObject:info forKey:bCurrentUserLoginInfo];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSDictionary *) loginInfo {
    return [[NSUserDefaults standardUserDefaults] dictionaryForKey:bCurrentUserLoginInfo];
}

@end
