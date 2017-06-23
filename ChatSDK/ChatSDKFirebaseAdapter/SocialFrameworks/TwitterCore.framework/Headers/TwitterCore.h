//
//  TwitterCore.h
//
//  Copyright (c) 2015 Twitter. All rights reserved.
//

#import <Foundation/Foundation.h>
#if !TARGET_OS_TV
#import <Accounts/Accounts.h>
#endif
#import <CoreData/CoreData.h>
#if !TARGET_OS_TV
#import <Social/Social.h>
#endif
#import "TWTRDefines.h"

#if IS_UIKIT_AVAILABLE
#import <UIKit/UIKit.h>
#else
#import <Cocoa/Cocoa.h>
#endif

#if __IPHONE_OS_VERSION_MIN_REQUIRED < 80000
#error "TwitterCore doesn't support iOS 7.x and lower. Please, change your minimum deployment target to iOS 8.0"
#endif

#import "TWTRAPIErrorCode.h"
#import "TWTRAuthConfig.h"
#import "TWTRAuthSession.h"
#import "TWTRConstants.h"
#import "TWTRCoreOAuthSigning.h"
#import "TWTRGuestSession.h"
#import "TWTRSession.h"
#import "TWTRSessionStore.h"
