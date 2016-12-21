//
//  BFirebaseManager.h
//  NekNominate
//
//  Created by Benjamin Smiley-andrews on 24/01/2014.
//  Copyright (c) 2014 deluge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ChatSDK/PMessage.h>

@class CDUser;
@protocol BNetworkFacade;

@interface BNetworkManager : NSObject {
}

@property (nonatomic, readwrite) id<BNetworkFacade> a;

+(BNetworkManager *) sharedManager;




@end
