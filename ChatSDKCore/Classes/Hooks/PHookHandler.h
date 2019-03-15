//
//  PHookHandler.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 30/05/2017.
//
//

#ifndef PHookHandler_h
#define PHookHandler_h

#define bHookDidAuthenticate @"bHookDidAuthenticate"
#define bHookDidAuthenticate_PUser @"bHookDidAuthenticate_PUser"

// Deprecated
#define bHookUserAuthFinished bHookDidAuthenticate
#define bHookUserAuthFinished_PUser bHookDidAuthenticate_PUser

#define bHookUserOn @"bHookUserOn"
#define bHookUserOn_PUser @"bHookUserOn_PUser"

#define bHookMessageRecieved @"bHookMessageRecieved"
#define bHookMessageReceived_PMessage @"bHookMessageReceived_PMessage"

#define bHookWillLogout @"bHookWillLogout"
#define bHookWillLogout_PUser @"bHookWillLogout_PUser"

#define bHookDidLogout @"bHookDidLogout"
#define bHookDidLogout_PUser @"bHookDidLogout_PUser"

#define bHookInternetConnectivityChanged @"bHookInternetConnectivityChanged"

@class BHook;

@protocol PHookHandler <NSObject>

-(void) addHook: (BHook *) hook withName: (NSString *) name;
-(void) removeHook: (BHook *) hook withName: (NSString *) name;
-(void) executeHookWithName: (NSString *) name data: (NSDictionary *) data;

@end

#endif /* PHookHandler_h */
