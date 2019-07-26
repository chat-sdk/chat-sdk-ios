//
//  BInterfaceManager.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 14/09/2016.
//
//

#import "BInterfaceManager.h"
#import <ChatSDK/Core.h>

@implementation BInterfaceManager

static BInterfaceManager * manager;

+(BInterfaceManager *) sharedManager {
    return [[self alloc] init];
}

-(id<PInterfaceAdapter>) a {
    return BChatSDK.ui;
}


@end
