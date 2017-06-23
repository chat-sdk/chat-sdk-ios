//
//  TWTRTokenOnlyAuthSession.h
//  TwitterCore
//
//  Created by Chase Latta on 6/12/15.
//  Copyright (c) 2015 Twitter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TWTRAuthSession.h"

NS_ASSUME_NONNULL_BEGIN

@interface TWTRTokenOnlyAuthSession : NSObject <TWTRAuthSession>

@property (nonatomic, copy, readonly) NSString *authToken;

@property (nonatomic, copy, readonly) NSString *authTokenSecret;

/**
 * This value is here to satisfy TWTRAuthSession protocol but
 * it defaults to an empty string and cannot be updated.
 */
@property (nonatomic, copy, readonly) NSString *userID;

- (instancetype)initWithToken:(NSString *)authToken secret:(NSString *)authTokenSecret;
+ (instancetype)authSessionWithToken:(NSString *)authToken secret:(NSString *)authTokenSecret;

@end

NS_ASSUME_NONNULL_END
