//
//  BInterfaceManager.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 14/09/2016.
//
//

#import "BInterfaceManager.h"
#import <objc/runtime.h>
#import "BProfileTableViewController.h"


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

-(id) init {
    if ((self = [super init])) {
        a = [[BDefaultInterfaceAdapter alloc] init];
    }
    return self;
}


@end
