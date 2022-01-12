//
//  BFirebaseSearchHandler.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 12/11/2016.
//
//

#import "BFirebaseSearchHandler.h"

#import <ChatSDKFirebase/FirebaseAdapter.h>
#import <ChatSDKFirebase/ChatSDKFirebase-Swift.h>

@implementation BFirebaseSearchHandler

-(RXPromise *) usersForIndex: (NSString *) index withValue: (NSString *) value limit: (int) limit userAdded: (void(^)(id<PUser> user)) userAdded {
    RXPromise * promise = [RXPromise new];
    
    if ([index isEqualToString:bNameKey]) {
        index = bUserNameLowercase;
    }
    
    if ([index isEqual:bUserNameLowercase]) {
        value = [value lowercaseString];
    }

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        if(!index || !index.length || !value || !value.length) {
            // TODO: Localise this
            [promise rejectWithReason:[NSError errorWithDomain:@"" code:0 userInfo:@{NSLocalizedDescriptionKey: @"Index or value is blank"}]];
        }
        else {
            NSString * childPath = [NSString stringWithFormat:@"%@/%@", bMetaPath, index];
            
            FIRDatabaseQuery * query = [[FIRDatabaseReference usersRef] queryOrderedByChild: childPath];
            [query keepSynced:true];
            query = [query queryStartingAtValue:value];
            query = [query queryLimitedToFirst:limit];

            [query observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * snapshot) {
                NSMutableArray * users = [NSMutableArray new];
                if(snapshot.value != [NSNull null]) {
                    for(NSString * key in [snapshot.value allKeys]) {
                        NSDictionary * meta = snapshot.value[key][bMetaPath];
                        if(meta && [meta[index] containsString:value]) {
                            CCUserWrapper * wrapper = [FirebaseNetworkAdapterModule.shared.firebaseProvider userWrapperWithSnapshot:[snapshot childSnapshotForPath:key]];
                            if(![wrapper.model isEqual:BChatSDK.currentUser]) {
                                userAdded(wrapper.model);
                                [users addObject:wrapper.model];
                            }
                        }
                    }
                }
                [promise resolveWithResult:nil];
            }];
        }
    });
    
    return promise;
}

-(RXPromise *) usersForIndexes: (NSArray *) indexes withValue: (NSString *) value limit: (int) limit userAdded: (void(^)(id<PUser> user)) userAdded {
    
    if(!indexes) {
        indexes = BChatSDK.config.searchIndexes;
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

-(NSString *) processForQuery: (NSString *) string {
    return [[string stringByReplacingOccurrencesOfString:@" " withString:@""] lowercaseString];
}

-(RXPromise *) availableIndexes {
    return [RXPromise resolveWithResult:Nil];
}


@end
