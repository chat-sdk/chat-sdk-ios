//
//  BFirebaseNetworkAdapter.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 13/11/2016.
//
//

#import "BFirebaseNetworkAdapter.h"

#import <ChatSDKFirebase/FirebaseAdapter.h>

@implementation BFirebaseNetworkAdapter

-(id) init {
    if((self = [super init])) {
        
        [FIRDatabase database].persistenceEnabled = YES;

        self.core = [[BFirebaseCoreHandler alloc] init];
        self.auth = [[BFirebaseAuthenticationHandler alloc] init];
        self.search = [[BFirebaseSearchHandler alloc] init];
        self.moderation = [[BFirebaseModerationHandler alloc] init];
        self.contact = [[BBaseContactHandler alloc] init];
        self.publicThread = [[BFirebasePublicThreadHandler alloc] init];
        self.users = [[BFirebaseUsersHandler alloc] init];
        self.contact = [[BFirebaseContactHandler alloc] init];
        self.event = [[BFirebaseEventHandler alloc] init];
        self.thread = [[BFirebaseThreadHandler alloc] init];

    }
    return self;
}

-(void) activate {
    [self activate:self.core];
    [self activate:self.auth];
    [self activate:self.moderation];
}

-(void) activate: (id) handler {
    if([handler respondsToSelector:@selector(activate)]) {
        [handler activate];
    }
}

@end
