//
//  BFirebaseNetworkAdapter.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 13/11/2016.
//
//

#import "BFirebaseNetworkAdapter.h"

#import <ChatSDk/ChatCore.h>
#import <ChatSDK/ChatFirebaseAdapter.h>

@implementation BFirebaseNetworkAdapter

-(id) init {
    if((self = [super init])) {
        self.core = [[BFirebaseCoreHandler alloc] init];
        self.upload = [[BFirebaseUploadHandler alloc] init];
        self.auth = [[BFirebaseAuthenticationHandler alloc] init];
        self.search = [[BFirebaseSearchHandler alloc] init];
        self.moderation = [[BFirebaseModerationHandler alloc] init];
        self.contact = [[BBaseContactHandler alloc] init];
        self.publicThread = [[BFirebasePublicThreadHandler alloc] init];

// Enable the read receipt module if it exists
#ifdef ChatSDKReadReceiptsModule
        self.readReceipt = [[BFirebaseReadReceiptHandler alloc] init];
#endif

// Enable the read receipt module if it exists
#ifdef ChatSDKAudioMessagesModule
        self.audioMessage = [[BFirebaseAudioMessageHandler alloc] init];
#endif
        
#ifdef ChatSDKTypingIndicatorModule
        self.typingIndicator = [[BFirebaseTypingIndicatorHandler alloc] init];
#endif

#ifdef ChatSDKVideoMessagesModule
        self.videoMessage = [[BFirebaseVideoMessageHandler alloc] init];
#endif

#ifdef ChatSDKNearbyUsersModule
        self.nearbyUsers = [[BGeoFireManager alloc] init];
        [BInterfaceManager sharedManager].a = [[BGeoFireInterfaceAdapter alloc] init];
#endif

#ifdef ChatSDKContactBookModule
		self.contact = [[BFirebasePhonebookContactHandler alloc] init];
#endif
        
#ifdef ChatSDKSocialLoginModule
        self.socialLogin = [[BFirebaseSocialLoginHandler alloc] init];
#endif

    }
    return self;
}

@end
