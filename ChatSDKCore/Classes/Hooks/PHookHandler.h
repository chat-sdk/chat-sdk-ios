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

#define bHook_AuthenticationType @"bHook_AuthenticationType"
#define bHook_AuthenticationTypeLogin @"login"
#define bHook_AuthenticationTypeSignUp @"signup"
#define bHook_AuthenticationTypeCached @"cached"

#define bHookWillLogout @"bHookWillLogout"
#define bHookDidLogout @"bHookDidLogout"

#define bHookUserOn @"bHookUserOn"

#define bHookContactWillBeAdded @"bHookContactWillBeAdded"
#define bHookContactWasAdded @"bHookContactWasAdded"
#define bHookContactWillBeDeleted @"bHookContactWillBeDeleted"
#define bHookContactWasDeleted @"bHookContactWasDeleted"

#define bHookMessageRecieved @"bHookMessageRecieved"

#define bHookMessageWillSend @"bHookMessageWillSend"
#define bHookMessageSending @"bHookMessageSending"
#define bHookMessageDidSend @"bHookMessageDidSend"
#define bHookMessageWillUpload @"bHookMessageWillUpload"
#define bHookMessageDidUpload @"bHookMessageDidUpload"

#define bHookMessageWillBeDeleted @"bHookMessageWillBeDeleted"
#define bHookMessageWasDeleted @"bHookMessageWasDeleted"
#define bHookAllMessagesDeleted @"bHookAllMessagesDeleted"

#define bHookThreadsUpdated @"bHookThreadsUpdated"
#define bHookThreadAdded @"bHookThreadAdded"
#define bHookThreadRemoved @"bHookThreadRemoved"
#define bHookThreadUpdated @"bHookThreadUpdated"
#define bHookThreadUsersUpdated @"bHookThreadUsersUpdated"
#define bHookThreadUserRoleUpdated @"bHookThreadUserRoleUpdated"
#define bHookThreadMarkedRead @"bHookThreadMarkedRead"

#define bHookMessageReadReceiptUpdated @"bHookMessageReadReceiptUpdated"

#define bHookWillPushUser @"bHookWillPushUser"
#define bHookUserUpdated @"bHookUserUpdated"

#define bHookServerPingFailed @"bHookServerPingFailed"

#define bHookServerConnectionStatusUpdated @"bHookServerConnectionStatusUpdated"

#define bHookGlobalAlertMessage @"bHookGlobalAlertMessage"
#define bHookSettingsUpdated @"bHookSettingsUpdated"

#define bHook_PMessage @"bHook_PMessage"
#define bHook_PUser @"bHook_PUser"
#define bHook_PThread @"bHook_PThread"
#define bHook_PThreads @"bHook_PThreads"
#define bHook_UIApplication @"bHook_UIApplication"

#define bHook_TitleString @"bHook_TitleString"
#define bHook_MessageString @"bHook_MessageString"

#define bHook_StringId @"bHook_StringId"
#define bHook_ObjectValue @"bHook_ObjectValue"


#define bHookInternetConnectivityDidChange @"bHookInternetConnectivityDidChange"
#define bHookUserWillDisconnect @"bHookUserWillDisconnect"

@class BHook;

@protocol PHookHandler <NSObject>

-(BHook *) addHook: (BHook *) hook withName: (NSString *) name;
-(void) executeHookWithName: (NSString *) name data: (NSDictionary *) data;

-(BHook *) addHook: (BHook *) hook withNames: (NSArray<NSString *> *) names;
-(void) removeHook: (BHook *) hook;
@end

#endif /* PHookHandler_h */
