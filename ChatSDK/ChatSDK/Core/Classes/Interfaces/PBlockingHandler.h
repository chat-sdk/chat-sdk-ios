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

-(RXPromise *) blockUser: (id<PUser>) user;
-(RXPromise *) unblockUser: (id<PUser>) user;
-(BOOL) isBlocked: (id<PUser>) user;

@end


#endif /* PBlockingHandler_h */
