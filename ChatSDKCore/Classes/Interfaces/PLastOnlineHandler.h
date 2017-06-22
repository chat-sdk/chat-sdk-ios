//
//  PLastOnlineHandler.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 15/11/2016.
//
//

#ifndef PLastOnlineHandler_h
#define PLastOnlineHandler_h

@class RXPromise;
@protocol PUser;

@protocol PLastOnlineHandler <NSObject>

-(RXPromise *) getLastOnlineForUser: (id<PUser>) user;
-(RXPromise *) setLastOnlineForUser: (id<PUser>) user;

@end


#endif /* PLastOnlineHandler_h */
