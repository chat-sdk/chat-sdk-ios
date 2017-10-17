//
//  PSearchHandler.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 12/11/2016.
//
//

#ifndef PSearchHandler_h
#define PSearchHandler_h

#import <ChatSDK/PUser.h>

@protocol PSearchHandler <NSObject>

/**
 * @brief Methods to handle search
 */
-(RXPromise *) updateIndexForUser: (id<PUser>) userModel __attribute__((deprecated("We now search the users/[user id]/meta path directly")));

/**
 * @brief Get users for a given index i.e. name, email with the value...
 */
-(RXPromise *) usersForIndexes: (NSArray *) indexes withValue: (NSString *) value limit: (int) limit userAdded: (void(^)(id<PUser> user)) userAdded;

-(RXPromise *) availableIndexes;

@end

#endif /* PSearchHandler_h */
