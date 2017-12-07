//
//  BInterfaceManager.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 14/09/2016.
//
//

#import "BInterfaceManager.h"

@implementation BInterfaceManager

static BInterfaceManager * manager;

@synthesize a;

+(BInterfaceManager *) sharedManager {
    
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
    }
    return self;
}


@end
