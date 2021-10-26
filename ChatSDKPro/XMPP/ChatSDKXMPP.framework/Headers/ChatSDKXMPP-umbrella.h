#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "ChatSDKXMPP.h"
#import "BSearchHandlerDelegate.h"
#import "BXMPPKeys.h"
#import "BXMPPModule.h"
#import "BXMPPNetworkAdapter.h"
#import "BXMPPServerDetails.h"
#import "NSBundle+XMPP.h"
#import "NSXMLElement+Additions.h"
#import "XMPPPresence+ChatSDK.h"
#import "XMPPRoom+Additions.h"
#import "XMPPStream+Additions.h"
#import "BXMPPRoster.h"
#import "BXMPPAuthenticationHandler.h"
#import "BXMPPBlockingHandler.h"
#import "BXMPPContactHandler.h"
#import "BXMPPCoreHandler.h"
#import "BXMPPImageMessageHandler.h"
#import "BXMPPLastOnlineHandler.h"
#import "BXMPPLocationMessageHandler.h"
#import "BXMPPModerationHandler.h"
#import "BXMPPSearchHandler.h"
#import "BXMPPThreadHandler.h"
#import "BXMPPTypingIndicatorHandler.h"
#import "LoggingLevel.h"
#import "BXMPPChatManager.h"
#import "BXMPPDeliveryReceiptListener.h"
#import "BXMPPManager.h"
#import "BXMPPMUCManager.h"
#import "BXMPPMUCMessageManager.h"
#import "BXMPPTypingIndicatorManager.h"
#import "BXMPPUserManager.h"
#import "BXMPPService.h"
#import "BXMPPServiceDiscovery.h"
#import "XMPPCoreDataStorage+BundleSwizzle.h"
#import "BXMPPAuthType.h"
#import "BDelegateCallbackListener.h"
#import "BDelegateCallbackManager.h"
#import "BJIDEntityID.h"
#import "BXMPPSearchHelper.h"
#import "BXMPPServerCache.h"
#import "BUserSubscriptionCell.h"
#import "BXMPPContactRequestViewController.h"
#import "BXMPPInterfaceAdapter.h"
#import "BXMPPLoginViewController.h"
#import "BXMPPServerConfigViewController.h"
#import "BXMPPThreadWrapper.h"
#import "BXMPPUserConnectionWrapper.h"
#import "BXMPPUserWrapper.h"
#import "XMPPAdapter.h"
#import "XMPPStreamManagementNSUserDefaultsStorage.h"
#import "BXMPPReadReceiptHandler.h"

FOUNDATION_EXPORT double ChatSDKXMPPVersionNumber;
FOUNDATION_EXPORT const unsigned char ChatSDKXMPPVersionString[];

