//
//  PElmThread.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 01/02/2017.
//
//

#ifndef PElmThread_h
#define PElmThread_h

@protocol PElmMessage;

@protocol PElmThread <NSObject>

-(NSString *) entityID;
-(NSNumber *) type;
-(NSString *) displayName;
-(NSString *) memberListAsString;
-(NSArray *) messagesOrderedByDateAsc;
-(void) markRead;

@end

#endif /* PElmThread_h */
