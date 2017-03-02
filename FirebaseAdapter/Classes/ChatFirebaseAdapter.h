//
//  ChatFirebaseAdapter.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 13/11/2016.
//
//

#ifndef ChatFirebaseAdapter_h
#define ChatFirebaseAdapter_h

#import <Firebase/Firebase.h>

#import <ChatSDK/NSManagedObject+Status.h>

#import <ChatSDK/CCThreadWrapper.h>
#import <ChatSDK/CCUserWrapper.h>
#import <ChatSDK/CCMessageWrapper.h>
#import <ChatSDK/BStateManager.h>

#import <ChatSDK/Firebase+Paths.h>

#import <ChatSDK/BFirebaseNetworkAdapter.h>

#import <ChatSDK/BFirebaseCoreHandler.h>
#import <ChatSDK/BFirebaseUploadHandler.h>
#import <ChatSDK/BFirebaseAuthenticationHandler.h>
#import <ChatSDK/BFirebaseSearchHandler.h>
#import <ChatSDK/BFirebaseModerationHandler.h>
#import <ChatSDK/BFirebasePublicThreadHandler.h>

#ifdef ChatSDKReadReceiptsModule
#import <ChatSDKFirebase/BFirebaseReadReceiptHandler.h>
#endif

#ifdef ChatSDKAudioMessagesModule
#import <ChatSDKFirebase/BFirebaseAudioMessageHandler.h>
#endif

#ifdef ChatSDKTypingIndicatorModule
#import <ChatSDKFirebase/BFirebaseTypingIndicatorHandler.h>
#endif

#ifdef ChatSDKVideoMessagesModule
#import <ChatSDKFirebase/BFirebaseVideoMessageHandler.h>
#endif

#ifdef ChatSDKNearbyUsersModule
#import <ChatSDKFirebase/BGeoFireManager.h>
#import <ChatSDKFirebase/BGeoFireInterfaceAdapter.h>
#import <GeoFire.h>
#endif

#ifdef ChatSDKContactBookModule
#import <ChatSDKFirebase/BFirebasePhonebookContactHandler.h>
#endif

#ifdef ChatSDKSocialLoginModule
#import <ChatSDKFirebase/BFirebaseSocialLoginHandler.h>
#endif


#endif /* ChatFirebaseAdapter_h */
