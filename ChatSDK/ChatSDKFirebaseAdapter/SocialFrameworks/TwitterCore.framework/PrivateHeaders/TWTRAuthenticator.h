//
//  TWTRAuthenticator.h
//  TWTRAuthenticator
//
//  Created by Mustafa Furniturewala on 2/4/14.
//  Copyright (c) 2014 Mustafa Furniturewala. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TwitterCore/TwitterCore.h>
#import "TWTRAuthenticationConstants.h"

/**
 * The TWTRAuthenticator has been deprecated. Users should use the TWTRSessionStore
 * in favor of the authenticator.
 */
@interface TWTRAuthenticator : NSObject

+ (NSDictionary *)authenticationResponseForAuthType:(TWTRAuthType)authType __attribute__((deprecated("This class is removed in favor of TWTRSessionStore")));
+ (void)logoutAuthType:(TWTRAuthType)authType __attribute__((deprecated("This class is removed in favor of TWTRSessionStore")));

/**
 *  Save authentiation information to keychain and to disk.
 *
 *  @param authDict Authentication dictionary received from the Twitter API.
 *  @param authType The TWTRAuthType of the response being saved.
 *  @param error    An error object to return information about any error situations encountered.
 *
 *  @return Returns YES if everything saved correctly, NO if errors were encountered.
 */
+ (BOOL)saveAuthenticationWithDictionary:(NSDictionary *)authDict forAuthType:(TWTRAuthType)authType error:(out NSError *__autoreleasing *)error __attribute__((deprecated("This class is removed in favor of TWTRSessionStore")));

@end
