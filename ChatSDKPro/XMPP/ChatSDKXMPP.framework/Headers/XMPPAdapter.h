//
//  XMPPNetworkAdapter.h
//  XMPPChat
//
//  Created by Benjamin Smiley-andrews on 21/11/2016.
//  Copyright © 2016 deluge. All rights reserved.
//

#ifndef XMPPNetworkAdapter_h
#define XMPPNetworkAdapter_h

#define bXMPPBundleName @"ChatXMPPAdapter"

#import <SAMKeychain/SAMKeychain.h>
#import <ChatSDK/Core.h>

//@import XMPPFramework;
#import <ChatSDKXMPP/XMPPFramework.h>
#import <ChatSDKXMPP/BXMPPManager.h>
#import <ChatSDKXMPP/BXMPPUserManager.h>
#import <ChatSDKXMPP/BXMPPServerDetails.h>
#import <ChatSDKXMPP/BXMPPSearchHelper.h>
#import <ChatSDKXMPP/BXMPPMUCManager.h>
#import <ChatSDKXMPP/BXMPPThreadWrapper.h>
#import <ChatSDKXMPP/BXMPPInterfaceAdapter.h>
#import <ChatSDKXMPP/BXMPPTypingIndicatorManager.h>
#import <ChatSDKXMPP/NSBundle+XMPP.h>
#import <ChatSDKXMPP/BXMPPChatManager.h>
#import <ChatSDKXMPP/XMPPRoom+Additions.h>
#import <ChatSDKXMPP/BXMPPServerCache.h>
#import <ChatSDKXMPP/BXMPPDeliveryReceiptListener.h>
#import <ChatSDKXMPP/BXMPPThreadHandler.h>

#import <ChatSDKXMPP/LoggingLevel.h>
#import <ChatSDKXMPP/BDelegateCallbackManager.h>
#import <ChatSDKXMPP/BXMPPUserWrapper.h>
#import <ChatSDKXMPP/BXMPPUserConnectionWrapper.h>
#import <ChatSDKXMPP/NSXMLElement+Additions.h>
#import <ChatSDKXMPP/BXMPPKeys.h>
#import <ChatSDKXMPP/LoggingLevel.h>
#import <ChatSDKXMPP/XMPPStream+Additions.h>
#import <ChatSDKXMPP/XMPPStreamManagementNSUserDefaultsStorage.h>
#import <ChatSDKXMPP/BXMPPServerConfigViewController.h>
#import <ChatSDKXMPP/BXMPPLoginViewController.h>
#import <ChatSDKXMPP/BXMPPServiceDiscovery.h>
#import <ChatSDKXMPP/BXMPPService.h>
#import <ChatSDKXMPP/BXMPPRoster.h>
#import <ChatSDKXMPP/BXMPPAuthType.h>

#import <ChatSDKXMPP/XMPPPresence+ChatSDK.h>

#import <ChatSDKXMPP/BXMPPCoreHandler.h>
#import <ChatSDKXMPP/BXMPPAuthenticationHandler.h>
#import <ChatSDKXMPP/BXMPPContactHandler.h>
#import <ChatSDKXMPP/BXMPPBlockingHandler.h>
#import <ChatSDKXMPP/BXMPPLastOnlineHandler.h>
#import <ChatSDKXMPP/BXMPPModerationHandler.h>
#import <ChatSDKXMPP/BXMPPSearchHandler.h>
#import <ChatSDKXMPP/BXMPPTypingIndicatorHandler.h>
#import <ChatSDKXMPP/BXMPPLocationMessageHandler.h>
#import <ChatSDKXMPP/BXMPPImageMessageHandler.h>
#import <ChatSDKXMPP/BJIDEntityID.h>

#import <ChatSDKXMPP/BXMPPNetworkAdapter.h>
#import <ChatSDKXMPP/BXMPPInterfaceAdapter.h>
#import <ChatSDKXMPP/XMPPJingle.h>

#import <ChatSDKXMPP/BXMPPModule.h>

#import <ChatSDKXMPP/XMPPCoreDataStorage+BundleSwizzle.h>

#endif /* XMPPNetworkAdapter_h */
