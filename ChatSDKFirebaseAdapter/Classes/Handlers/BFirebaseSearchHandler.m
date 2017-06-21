//
//  BFirebaseSearchHandler.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 12/11/2016.
//
//

#import "BFirebaseSearchHandler.h"

#import <ChatSDKFirebaseAdapter/ChatFirebaseAdapter.h>
#import <ChatSDKCore/ChatCore.h>

@implementation BFirebaseSearchHandler

-(RXPromise *) usersForIndex: (NSString *) index withValue: (NSString *) value limit: (int) limit userAdded: (void(^)(id<PUser> user)) userAdded {

    RXPromise * promise = [RXPromise new];

    
    // Make the query lower case and bunch it up
    value = [self processForQuery:value];
    
    if (!value.length) {
        [promise rejectWithReason:Nil];
        return promise;
    }
    
    // Make the query
    FIRDatabaseQuery * query = [[[[FIRDatabaseReference searchIndexRef] queryOrderedByChild:index] queryStartingAtValue:value] queryLimitedToFirst:limit];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{

        // Execute the query
        [query observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * snapshot) {
            
            if(snapshot.value != [NSNull null]) {
                
                // Get the keys of the dictionary
                NSDictionary * dict = snapshot.value;
                
                // Only add users that match the original query
                NSArray * keys = dict.allKeys;
                NSString * resultValue;
                
                NSMutableArray * validUIDs = [NSMutableArray new];
                
                // Loop over the dictionary keys
                for (NSString * key in keys) {
                    
                    // Don't return the current user!
                    id<PUser> currentUserID = NM.auth.currentUserEntityID;
                    
                    if ([key isEqualToString:currentUserID]) {
                        continue;
                    }
                    
                    resultValue = dict[key][index];
                    if(resultValue) {
                        // Transform the result value to lower case / no spaces
                        resultValue = [self processForQuery:resultValue];
                        
                        // If the query is longer than the result then it's obviously not a match
                        if (resultValue.length < value.length) {
                            continue;
                        }
                        
                        // Trim it to the length of the input query
                        resultValue = [resultValue substringToIndex:value.length];
                        
                        // If they match add it to the result
                        if ([value isEqualToString:resultValue]) {
                            [validUIDs addObject:key];
                        }
                    }
                }
                
                if(validUIDs.count) {
                    
                    NSMutableArray * userPromises = [NSMutableArray new];
                    
                    // Loop over the IDs and get the users
                    for(NSString * entityID in validUIDs) {
                        
                        CCUserWrapper * user = [CCUserWrapper userWithEntityID:entityID];
                        [userPromises addObject:[user once].thenOnMain(^id(id<PUserWrapper> u) {
                            
                            // Call add user again to udpate the list with the
                            // correct image - only add users who have names
                            if (u.model.name.length) {
                                userAdded(user.model);
                            }
                            return Nil;
                        }, Nil)];
                    }
                    
                    [RXPromise all: userPromises].then(^id(id success) {
                        [promise resolveWithResult:success];
                        return Nil;
                    }, Nil);
                }
                else {
                    [promise resolveWithResult:Nil];
                }
            }
            else {
                [promise resolveWithResult:Nil];
            }
        }];
        
    });
    
    return promise;
}

-(RXPromise *) usersForIndexes: (NSArray *) indexes withValue: (NSString *) value limit: (int) limit userAdded: (void(^)(id<PUser> user)) userAdded {
    
    if(!indexes) {
        indexes = @[bNameKey, bEmailKey, bPhoneKey];
    }
    
    NSMutableArray * promises = [NSMutableArray new];
    for (NSString * index in indexes) {
        [promises addObject:[self usersForIndex:index withValue:value limit: limit userAdded:userAdded]];
    }
    
    // Return null when all the promises finish
    return [RXPromise all:promises].thenOnMain(^id(id success) {
        return Nil;
    }, Nil);
}

-(RXPromise *) updateIndexForUser: (id<PUser>) userModel {
    
    RXPromise * promise = [RXPromise new];
    
    FIRDatabaseReference * ref = [[FIRDatabaseReference searchIndexRef] child:NM.auth.currentUserEntityID];
    
    NSString * email = [userModel metaStringForKey:bEmailKey];
    NSString * phone = [userModel metaStringForKey:bPhoneKey];
    
    NSDictionary * value = @{bNameKey: userModel.name ? [self processForQuery:userModel.name] : @"",
                             bEmailKey: email ? [self processForQuery:email] : @"",
                             bPhoneKey: phone ? [self processForQuery:phone] : @""};
    
    // The search index works like: /searchIndex/[user entity id]/user details
    [ref setValue:value withCompletionBlock:^(NSError * error, FIRDatabaseReference * firebase) {
        if (!error) {
            [promise resolveWithResult:Nil];
        }
        else {
            [promise rejectWithReason:error];
        }
    }];
    
    return promise;
}

-(NSString *) processForQuery: (NSString *) string {
    return [[string stringByReplacingOccurrencesOfString:@" " withString:@""] lowercaseString];
}

/**
 * @brief Get an array of the available search indexes
 */
// TODO: maybe we should just disable this
//-(RXPromise *) availableIndexes {
//    return [RXPromise resolveWithResult:@[bNameKey, bEmailKey, bPhoneKey]];
//}


@end
