//
//  TWTRAuthConfigStore.h
//  TwitterCore
//
//  Created by Chase Latta on 10/8/15.
//  Copyright © 2015 Twitter Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TWTRAuthConfig;

NS_ASSUME_NONNULL_BEGIN

@interface TWTRAuthConfigStore : NSObject

- (instancetype)init NS_UNAVAILABLE;

/**
 * Initializes the auth config store
 *
 * @param nameSpace the namespace to associate with this store.
 */
- (instancetype)initWithNameSpace:(NSString *)nameSpace;

/**
 * Saves the given auth config replacing the last saved config.
 */
- (void)saveAuthConfig:(TWTRAuthConfig *)authConfig;

/**
 * Returns the auth config object that was last saved or nil
 * if there is none.
 */
- (nullable TWTRAuthConfig *)lastSavedAuthConfig;

/**
 * Removes the last saved auth config.
 */
- (void)forgetAuthConfig;

@end

NS_ASSUME_NONNULL_END
