//
//  PBlockingHandler.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 15/11/2016.
//
//

#ifndef PBlockingHandler_h
#define PBlockingHandler_h

@class RXPromise;
@protocol PUser;

@protocol PBlockingHandler <NSObject>

-(RXPromise *) blockUser: (NSString *) userEntityID;
-(RXPromise *) unblockUser: (NSString *) userEntityID;
-(BOOL) isBlocked: (NSString *) userEntityID;
-(BOOL) serviceAvailable;

@end


#endif /* PBlockingHandler_h */
