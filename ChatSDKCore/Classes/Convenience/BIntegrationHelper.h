//
//  BIntegrationHelper.h
//  AFNetworking
//
//  Created by Ben on 2/1/18.
//

#import <Foundation/Foundation.h>

@class RXPromise;

@interface BIntegrationHelper : NSObject

// Authenticate using a Firebase token
+(RXPromise *) authenticateWithToken: (NSString *) token;

// Update the username image and image url safely i.e. this method will wait until
// the user has been authenticated correctly by using the post auth hook
+(void) updateUserWithName: (NSString *) name image: (UIImage *) image url: (NSString *) url;

// Logout
+(RXPromise *) logout;

@end
