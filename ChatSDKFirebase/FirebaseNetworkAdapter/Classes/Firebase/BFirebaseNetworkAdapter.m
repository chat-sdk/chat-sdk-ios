//
//  BFirebaseNetworkAdapter.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 13/11/2016.
//
//

#import "BFirebaseNetworkAdapter.h"

#import <ChatSDK/ChatCore.h>
#import "ChatFirebaseAdapter.h"

@implementation BFirebaseNetworkAdapter

-(id) init {
    if((self = [super init])) {
        
        if ([BChatSDK config].firebaseShouldConfigureAutomatically) {
            NSString * plist = [BChatSDK config].firebaseGoogleServicesPlistName;
            if (plist) {
                plist = [plist stringByReplacingOccurrencesOfString:@".plist" withString:@""];
                NSString * path = [[NSBundle mainBundle] pathForResource:plist ofType:@"plist"];
                FIROptions * options = [[FIROptions alloc] initWithContentsOfFile:path];
                [FIRApp configureWithOptions:options];
            }
            else {
                [FIRApp configure];
            }
        }
        
        self.core = [[BFirebaseCoreHandler alloc] init];
        self.auth = [[BFirebaseAuthenticationHandler alloc] init];
        self.search = [[BFirebaseSearchHandler alloc] init];
        self.moderation = [[BFirebaseModerationHandler alloc] init];
        self.contact = [[BBaseContactHandler alloc] init];
        self.publicThread = [[BFirebasePublicThreadHandler alloc] init];
        self.users = [[BFirebaseUsersHandler alloc] init];

    }
    return self;
}

@end
