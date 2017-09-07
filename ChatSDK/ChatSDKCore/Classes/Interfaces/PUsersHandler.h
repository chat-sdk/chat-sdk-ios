//
//  PUserHandler.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 12/11/2016.
//
//

#ifndef PUserHandler_h
#define PUserHandler_h

@protocol PUsersHandler <NSObject>

@optional

-(NSArray *) allUsers;
-(void) allUsersOn;
-(void) allUsersOff;

@end


#endif /* PUserHandler_h */
