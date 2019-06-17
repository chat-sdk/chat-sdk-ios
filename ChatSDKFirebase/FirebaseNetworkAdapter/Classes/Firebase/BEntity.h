//
//  PEntity+Chatcat.h
//  Chat SDK
//
//  Created by Benjamin Smiley-andrews on 09/02/2015.
//  Copyright (c) 2015 deluge. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RXPromise;

@interface BEntity : NSObject {
}

+(RXPromise *) pushThreadDetailsUpdated: (NSString *) threadID;
+(RXPromise *) pushThreadUsersUpdated: (NSString *) threadID;
+(RXPromise *) pushThreadMessagesUpdated: (NSString *) threadID;
+(RXPromise *) pushUserMetaUpdated: (NSString *) userID;
+(RXPromise *) pushUserThreadsUpdated: (NSString *) userID;

@end
