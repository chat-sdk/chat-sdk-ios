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

#import "VirgilSDK.h"
#import "VSSKeyEntry.h"
#import "VSSKeyStoragePublic.h"
#import "VSSKeyAttrs.h"
#import "VSSKeyStorage.h"
#import "VSSKeyStorageConfiguration.h"
#import "VSSKeyStoragePlatformSpecificPublic.h"

FOUNDATION_EXPORT double VirgilSDKVersionNumber;
FOUNDATION_EXPORT const unsigned char VirgilSDKVersionString[];

