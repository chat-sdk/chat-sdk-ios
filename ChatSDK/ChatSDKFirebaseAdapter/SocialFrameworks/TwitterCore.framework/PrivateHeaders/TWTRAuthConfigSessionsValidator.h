//
//  TWTRAuthConfigSessionsValidator.h
//  TwitterCore
//
//  Created by Chase Latta on 10/8/15.
//  Copyright © 2015 Twitter Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TWTRAuthConfig;
@class TWTRAuthConfigStore;
@protocol TWTRSessionStore_Private;

NS_ASSUME_NONNULL_BEGIN

@interface TWTRAuthConfigSessionsValidator : NSObject

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithConfigStore:(TWTRAuthConfigStore *)configStore sessionStore:(id<TWTRSessionStore_Private>)sessionStore;

/**
 * Calling this method will check that the auth config used by the
 * session store matches the config stored in the config store.
 * If they do not match it will clear the sessions from the session store.
 * It will then store the session store's config in the config store.
 * @note If the config store does not have a saved auth config the store will not be purged. If we did not do this all users would be logged out the first time this validator is used.
 */
- (void)validateSessionStoreContainsValidAuthConfig;

@end

NS_ASSUME_NONNULL_END
