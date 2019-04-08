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
#define bHookWillLogout @"bHookWillLogout"
#define bHookDidLogout @"bHookDidLogout"

#define bHookUserOn @"bHookUserOn"

#define bHookContactWillBeAdded @"bHookContactWillBeAdded"
#define bHookContactWasAdded @"bHookContactWasAdded"
#define bHookContactWillBeDeleted @"bHookContactWillBeDeleted"
#define bHookContactWasDeleted @"bHookContactWasDeleted"

#define bHookMessageRecieved @"bHookMessageRecieved"

#define bHookMessageWillSend @"bHookMessageWillSend"
#define bHookMessageDidSend @"bHookMessageDidSend"
#define bHookMessageWillUpload @"bHookMessageWillUpload"
#define bHookMessageDidUpload @"bHookMessageDidUpload"

#define bHook_PMessage @"bHook_PMessage"
#define bHook_PUser @"bHook_PUser"

#define bHookInternetConnectivityDidChange @"bHookInternetConnectivityDidChange"

@class BHook;

@protocol PHookHandler <NSObject>

-(BHook *) addHook: (BHook *) hook withName: (NSString *) name;
-(void) executeHookWithName: (NSString *) name data: (NSDictionary *) data;

-(BHook *) addHook: (BHook *) hook withNames: (NSArray<NSString *> *) names;
-(void) removeHook: (BHook *) hook;
@end

#endif /* PHookHandler_h */
