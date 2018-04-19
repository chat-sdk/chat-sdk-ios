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
#define bHookUserAuthFinished_PUser @"bHookUserAuthFinished_PUser"

#define bHookUserOn @"bHookUserOn"
#define bHookUserOn_PUser @"bHookUserOn_PUser"

#define bHookMessageRecieved @"bHookMessageRecieved"
#define bHookMessageReceived_PMessage @"bHookMessageReceived_PMessage"

#define bHookLogout @"bHookLogout"
#define bHookLogout_PUser @"bHookLogout_PUser"


@class BHook;

@protocol PHookHandler <NSObject>

-(void) addHook: (BHook *) hook withName: (NSString *) name;
-(void) removeHook: (BHook *) hook withName: (NSString *) name;
-(void) executeHookWithName: (NSString *) name data: (NSDictionary *) data;

@end

#endif /* PHookHandler_h */
