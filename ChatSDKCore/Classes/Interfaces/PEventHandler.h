//
//  PEventHandler.h
//  Pods
//
//  Created by Benjamin Smiley-Andrews on 08/03/2019.
//

#ifndef PEventHandler_h
#define PEventHandler_h

@protocol PEventHandler <NSObject>

-(void) currentUserOn: (NSString *) entityID;
-(void) currentUserOff: (NSString *) entityID;

@end

#endif /* PEventHandler_h */
