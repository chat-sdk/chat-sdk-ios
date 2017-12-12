//
//  BAccountDetails.m
//  AFNetworking
//
//  Created by Ben on 9/28/17.
//

#import "BAccountDetails.h"

@implementation BAccountDetails

+(id) username: (NSString *) username password: (NSString *) password {
    BAccountDetails * details = [self new];
    details.type = bAccountTypeUsername;
    details.username = username;
    details.password = password;
    return details;
}

+(id) signUp: (NSString *) username password: (NSString *) password {
    BAccountDetails * details = [self new];
    details.type = bAccountTypeRegister;
    details.username = username;
    details.password = password;
    return details;
}

+(id) facebook {
    BAccountDetails * details = [self new];
    details.type = bAccountTypeFacebook;
    return details;
}

+(id) twitter {
    BAccountDetails * details = [self new];
    details.type = bAccountTypeTwitter;
    return details;
}

+(id) google {
    BAccountDetails * details = [self new];
    details.type = bAccountTypeGoogle;
    return details;
}

+(id) anonymous {
    BAccountDetails * details = [self new];
    details.type = bAccountTypeAnonymous;
    return details;
}

+(id) token: (NSString *) token {
    BAccountDetails * details = [self new];
    details.type = bAccountTypeCustom;
    details.token = token;
    return details;
}

@end
