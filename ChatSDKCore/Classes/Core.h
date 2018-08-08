//
//  Core.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 13/11/2016.
//
//

#ifndef ChatCore_h
#define ChatCore_h

#define bCoreBundleName @"ChatCore"

#import <Reachability/Reachability.h>
#import <RXPromise/RXPromise.h>
#import <RXPromise/RXPromise+RXExtension.h>
#import <AFNetworking/AFNetworking.h>

#import <ChatSDK/NSArray+KeyPair.h>
#import <ChatSDK/NSObject+AssociatedObject.h>
#import <ChatSDK/RXPromise+Additions.h>
#import <ChatSDK/UIImage+Resize.h>
#import <ChatSDK/NSBundle+Additions.h>
#import <ChatSDK/RXPromise+PromiseKit.h>

#import <ChatSDK/BNetworkManager.h>
#import <ChatSDK/BStorageManager.h>
#import <ChatSDK/BNetworkFacade.h>
#import <ChatSDK/BAbstractNetworkAdapter.h>
#import <ChatSDK/BBaseHookHandler.h>

#import <ChatSDK/BCoreUtilities.h>

#import <ChatSDK/PEntity.h>
#import <ChatSDK/PEntityWrapper.h>
#import <ChatSDK/PUserConnection.h>
#import <ChatSDK/PMessage.h>
#import <ChatSDK/PMessageWrapper.h>
#import <ChatSDK/PThread_.h>
#import <ChatSDK/PThreadWrapper.h>
#import <ChatSDK/PUser.h>
#import <ChatSDK/PUserAccount.h>
#import <ChatSDK/PUserWrapper.h>
#import <ChatSDK/PGroup.h>
#import <ChatSDK/PModule.h>
#import <ChatSDK/PInterfaceFacade.h>

#import <ChatSDK/PElmMessage.h>
#import <ChatSDK/PElmThread.h>
#import <ChatSDK/PElmUser.h>

#import <ChatSDK/PCoreHandler.h>
#import <ChatSDK/PVideoMessageHandler.h>
#import <ChatSDK/PAudioMessageHandler.h>
#import <ChatSDK/PPushHandler.h>
#import <ChatSDK/PUploadHandler.h>
#import <ChatSDK/PAuthenticationHandler.h>
#import <ChatSDK/PContactHandler.h>
#import <ChatSDK/PTypingIndicatorHandler.h>
#import <ChatSDK/PImageMessageHandler.h>
#import <ChatSDK/PLocationMessageHandler.h>
#import <ChatSDK/PModerationHandler.h>
#import <ChatSDK/PSearchHandler.h>
#import <ChatSDK/PPublicThreadHandler.h>
#import <ChatSDK/PBlockingHandler.h>
#import <ChatSDK/PLastOnlineHandler.h>
#import <ChatSDK/PNearbyUsersHandler.h>
#import <ChatSDK/PReadReceiptHandler.h>
#import <ChatSDK/PStickerMessageHandler.h>
#import <ChatSDK/BStorageAdapter.h>
#import <ChatSDK/PSocialLoginHandler.h>
#import <ChatSDK/NSBundle+Core.h>
#import <ChatSDK/BAccountDetails.h>
#import <ChatSDK/BChatSDK.h>
#import <ChatSDK/BConfiguration.h>
#import <ChatSDK/PImageViewController.h>
#import <ChatSDK/PLocationViewController.h>
#import <ChatSDK/PFriendsListViewController.h>

#import <ChatSDK/BHook.h>
#import <ChatSDK/PHookHandler.h>
#import <ChatSDK/BNotificationObserverList.h>

#import <ChatSDK/BBaseContactHandler.h>
#import <ChatSDK/BBaseImageMessageHandler.h>
#import <ChatSDK/BBaseLocationMessageHandler.h>
#import <ChatSDK/BAudioManager.h>
#import <ChatSDK/BInterfaceManager.h>

#import <ChatSDK/bChatState.h>
#import <ChatSDK/BKeys.h>
#import <ChatSDK/BCoreDefines.h>
#import <ChatSDK/NM.h>
#import <ChatSDK/BModuleHelper.h>
#import <ChatSDK/BIntegrationHelper.h>
#import <ChatSDK/NSObject+Meta.h>

#import <ChatSDK/bPictureTypes.h>

#endif /* ChatCore_h */
