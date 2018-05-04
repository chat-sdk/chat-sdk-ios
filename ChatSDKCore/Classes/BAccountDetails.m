//
//  BAccountDetails.m
//  AFNetworking
//
//  Created by Ben on 9/28/17.
//

#import "BAccountDetails.h"

@implementation BAccountDetails

-(instancetype) init {
    if ((self = [super init])) {
        _meta = [NSMutableDictionary new];
    }
    return self;
}

+(instancetype) username: (NSString *) username password: (NSString *) password {
    BAccountDetails * details = [self new];
    details.type = bAccountTypeUsername;
    details.username = username;
    details.password = password;
    return details;
}

+(instancetype) signUp: (NSString *) username password: (NSString *) password {
    BAccountDetails * details = [self new];
    details.type = bAccountTypeRegister;
    details.username = username;
    details.password = password;
    return details;
}

+(instancetype) facebook {
    BAccountDetails * details = [self new];
    details.type = bAccountTypeFacebook;
    return details;
}

+(instancetype) twitter {
    BAccountDetails * details = [self new];
    details.type = bAccountTypeTwitter;
    return details;
}

+(instancetype) google {
    BAccountDetails * details = [self new];
    details.type = bAccountTypeGoogle;
    return details;
}

+(instancetype) anonymous {
    BAccountDetails * details = [self new];
    details.type = bAccountTypeAnonymous;
    return details;
}

+(instancetype) token: (NSString *) token {
    BAccountDetails * details = [self new];
    details.type = bAccountTypeCustom;
    details.token = token;
    return details;
}

@end
