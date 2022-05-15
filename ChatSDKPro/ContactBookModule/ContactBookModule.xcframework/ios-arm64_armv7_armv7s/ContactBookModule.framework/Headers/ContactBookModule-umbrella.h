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

#import "BContactBookModule.h"
#import "BPhonebookManager.h"
#import "BPhonebookSearchViewController.h"
#import "BPhoneBookUser.h"
#import "ContactBook.h"

FOUNDATION_EXPORT double ContactBookModuleVersionNumber;
FOUNDATION_EXPORT const unsigned char ContactBookModuleVersionString[];

