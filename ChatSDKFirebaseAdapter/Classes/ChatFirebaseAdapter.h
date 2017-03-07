//
//  ChatFirebaseAdapter.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 13/11/2016.
//
//

#ifndef ChatFirebaseAdapter_h
#define ChatFirebaseAdapter_h

#import <Facebook-iOS-SDK/FBSDKCoreKit/FBSDKCoreKit.h>
//#import <Google/SignIn.h>
#import <Firebase/Firebase.h>

#import <ChatSDKFirebaseAdapter/NSManagedObject+Status.h>

#import <ChatSDKFirebaseAdapter/CCThreadWrapper.h>
#import <ChatSDKFirebaseAdapter/CCUserWrapper.h>
#import <ChatSDKFirebaseAdapter/CCMessageWrapper.h>
#import <ChatSDKFirebaseAdapter/BStateManager.h>

#import <ChatSDKFirebaseAdapter/Firebase+Paths.h>

#import <ChatSDKFirebaseAdapter/BFirebaseNetworkAdapter.h>

#import <ChatSDKFirebaseAdapter/BFirebaseCoreHandler.h>
#import <ChatSDKFirebaseAdapter/BFirebaseUploadHandler.h>
#import <ChatSDKFirebaseAdapter/BFirebaseAuthenticationHandler.h>
#import <ChatSDKFirebaseAdapter/BFirebaseSearchHandler.h>
#import <ChatSDKFirebaseAdapter/BFirebaseModerationHandler.h>
#import <ChatSDKFirebaseAdapter/BFirebasePublicThreadHandler.h>
#import <ChatSDKFirebaseAdapter/BGoogleLoginHelper.h>

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



#endif /* ChatFirebaseAdapter_h */
