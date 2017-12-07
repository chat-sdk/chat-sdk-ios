//
//  BStorageManager.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 26/11/2015.
//
//

#import "BStorageManager.h"

@implementation BStorageManager

static BStorageManager * manager;

+(BStorageManager *) sharedManager {
    
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
