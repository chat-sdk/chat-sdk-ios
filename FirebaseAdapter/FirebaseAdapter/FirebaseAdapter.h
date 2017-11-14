//
//  FirebaseAdapter.h
//  FirebaseAdapter
//
//  Created by Ben on 11/14/17.
//  Copyright © 2017 Ben. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for FirebaseAdapter.
FOUNDATION_EXPORT double FirebaseAdapterVersionNumber;

//! Project version string for FirebaseAdapter.
FOUNDATION_EXPORT const unsigned char FirebaseAdapterVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <FirebaseAdapter/PublicHeader.h>
#import <Firebase/Firebase.h>

#import "NSManagedObject+Status.h"

#import "CCThreadWrapper.h"
#import "CCUserWrapper.h"
#import "CCMessageWrapper.h"
#import "BStateManager.h"
#import "BFirebaseUsersHandler.h"
#import "BEntity.h"

#import "Firebase+Paths.h"

#import "BFirebaseNetworkAdapter.h"

#import "BFirebaseCoreHandler.h"
#import "BFirebaseAuthenticationHandler.h"
#import "BFirebaseSearchHandler.h"
#import "BFirebaseModerationHandler.h"
#import "BFirebasePublicThreadHandler.h"
#import "BFirebaseUsersHandler.h"

