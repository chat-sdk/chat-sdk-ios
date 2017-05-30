//
//  PHookHandler.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 30/05/2017.
//
//

#ifndef PHookHandler_h
#define PHookHandler_h

#define bHookUserAuthFinished @"bHookUserAuthFinished"
#define bHookUserAuthFinished_PUser_User @"bHookUserAuthFinished_PUser_User"

@class BHook;

@protocol PHookHandler <NSObject>

-(void) addHook: (BHook *) hook withName: (NSString *) name;
-(void) removeHook: (BHook *) hook withName: (NSString *) name;
-(void) executeHookWithName: (NSString *) name data: (NSDictionary *) data;

@end

#endif /* PHookHandler_h */
