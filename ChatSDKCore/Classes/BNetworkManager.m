//
//  BFirebaseManager.m
//  NekNominate
//
//  Created by Benjamin Smiley-andrews on 24/01/2014.
//  Copyright (c) 2014 deluge. All rights reserved.
//

#import <ChatSDK/Core.h>

@implementation BNetworkManager

static BNetworkManager * manager;

+(BNetworkManager *) sharedManager {
    
	@synchronized(self) {
		
		// If the sharedSoundManager var is nil then we need to allocate it.
		if(manager == nil) {
			// Allocate and initialize an instance of this class
			manager = [[self alloc] init];
		}
	}
    return manager;
}

-(instancetype) init {
    if ((self = [super init])) {

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(appDidResignActive)
                                                     name:UIApplicationWillResignActiveNotification
                                                   object:Nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(appDidBecomeActive)
                                                     name:UIApplicationDidBecomeActiveNotification
                                                   object:Nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(saveData)
                                                     name:UIApplicationWillTerminateNotification
                                                   object:Nil];
        
        
    }
    return self;
}

-(void) appDidResignActive {
    if(self.a) {
        [self.a.core save];
        [self.a.core goOffline];
    }
}

-(void) appDidBecomeActive {
    if(self.a) {
        // TODO: Check this
        [self.a.core goOnline];
    }
}

-(void) saveData {
    if (self.a) {
        [self.a.core save];
    }
}

@end

