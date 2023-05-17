//
//  BFirebaseTypingIndicatorHandler.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 12/11/2016.
//
//

#import "BFirebaseTypingIndicatorHandler.h"

#import <ChatSDK/Core.h>
#import <ChatSDKFirebase/FirebaseAdapter.h>
#import <ChatSDK/UI.h>

@implementation BFirebaseTypingIndicatorHandler

-(id) init {
    if((self = [super init])) {
        //BChatSDK.typingIndicator = self;
    }
    return self;
}

-(RXPromise *) setChatState:(bChatState) state forThread:(id<PThread>)thread {
    if(thread) {
        if (state == bChatStateComposing) {
            return [self startTyping: thread];
        }
        else {
            return [self stopTyping: thread];
        }
    }
    else {
        return [RXPromise resolveWithResult:Nil];
    }
}

// Typing Indicator
-(RXPromise *) startTyping: (id<PThread>) thread {
    
    id<PUser> currentUser = BChatSDK.currentUser;
    
    RXPromise * promise = [RXPromise new];
    FIRDatabaseReference * typingUsersRef = [[FIRDatabaseReference threadTypingRef:thread.entityID] child:currentUser.entityID];
    
    [typingUsersRef setValue:currentUser.name withCompletionBlock:^(NSError *error, FIRDatabaseReference *ref) {
        if (!error) {
            [promise resolveWithResult:nil];
        }
        else {
            [promise rejectWithReason:error];
        }
    }];
    [typingUsersRef onDisconnectRemoveValue];
    
    return promise;
}

// Typing Indicator
- (RXPromise *) stopTyping: (id<PThread>) thread {
    
    id<PUser> currentUser = BChatSDK.currentUser;
    
    RXPromise * promise = [RXPromise new];
    FIRDatabaseReference * typingUsersRef = [[FIRDatabaseReference threadTypingRef:thread.entityID] child:currentUser.entityID];
    
    [typingUsersRef removeValueWithCompletionBlock:^(NSError *error, FIRDatabaseReference *ref) {
        if (!error) {
            [promise resolveWithResult:nil];
        }
        else {
            [promise rejectWithReason:error];
        }
    }];
    
    return promise;
}

-(void) typingOn: (id<PThread>) thread {
    FIRDatabaseReference * typingRef = [FIRDatabaseReference threadTypingRef:thread.entityID];
    [typingRef observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot *snapshot) {
        
        NSString * message = @"";
        if(![snapshot.value isEqual:[NSNull null]]) {
            if([snapshot.value allKeys].count == 1 && snapshot.value[BChatSDK.currentUser.entityID]) {
                // In this case we are typing...
            }
            else {
                if (thread.type.intValue == bThreadType1to1) {
                    message = [NSBundle t: bTyping];
                }
                else {
                    message = [self typingMessageForNames:snapshot.value];
                }
                
                BOOL isBlocked = NO;
                if(BChatSDK.blocking && thread.type.intValue == bThreadType1to1) {
                    if ([BChatSDK.blocking isBlocked:thread.otherUser.entityID]) {
                        isBlocked = YES;
                    }
                }
                
                if (!isBlocked) {
                    [BHookNotification notificationTypingStateUpdated: thread text: message];
                }
            }
        } else {
            [BHookNotification notificationTypingStateUpdated: thread text: nil];
        }
    }];
}

-(void) typingOff: (id<PThread>) thread {
    FIRDatabaseReference * typingRef = [FIRDatabaseReference threadTypingRef:thread.entityID];
    [typingRef removeAllObservers];
}

-(NSString *) typingMessageForNames: (NSDictionary *) userIdNameMap {
    
    if (userIdNameMap.allKeys.count == 0) {
        return @"";
    }
    
    NSString * typingMessage = @"";
    for (NSString * key in userIdNameMap.allKeys) {
        if(![key isEqualToString:BChatSDK.currentUser.entityID]) {
            typingMessage = [typingMessage stringByAppendingFormat:@"%@, ", userIdNameMap[key]];
        }
    }
    // Remove the trailing comma
    if (typingMessage.length > 2) {
        typingMessage = [typingMessage substringToIndex:typingMessage.length - 2];
    }
    return [typingMessage stringByAppendingFormat:@" %@",[[NSBundle t: bTyping] lowercaseString]];
}



@end
